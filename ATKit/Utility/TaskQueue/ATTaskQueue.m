//
//  ATTaskQueue.m
//  ATKit
//
//  Created by linzhiman on 2019/5/5.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ATTaskQueue.h"
#import "ATGlobalMacro.h"

#define AT_TASK_QUEUE_SERIAL "AT_TASK_QUEUE_SERIAL"
#define AT_TASK_QUEUE_CONCURRENT "AT_TASK_QUEUE_CONCURRENT"

#define AT_TASK_NORMAL(atTask) ((ATTaskNormal *)atTask)
#define AT_TASK_DELAY(atTask) ((ATTaskDelay *)atTask)

NSUInteger ATTaskGenTaskId()
{
    static NSUInteger taskId = 0;
    return ++taskId;
}

@interface ATTaskBase()

@property (nonatomic, assign) NSUInteger taskId;
@property (nonatomic, assign) ATTaskState state;

@end

@implementation ATTaskBase

- (id)copyWithZone:(NSZone *)zone
{
    ATTaskBase *copyInstance = [self.class allocWithZone:zone];
    if (copyInstance != nil) {
        copyInstance.state = self.state;
        copyInstance.taskId = self.taskId;
    }
    return copyInstance;
}

- (BOOL)isEqual:(ATTaskBase *)object
{
    return self == object || self.taskId == object.taskId;
}

@end

@implementation ATTaskNormal

- (id)copyWithZone:(NSZone *)zone
{
    ATTaskNormal *copyInstance = [super copyWithZone:zone];
    if (copyInstance != nil) {
        copyInstance.paramBlock = self.paramBlock;
        copyInstance.actionBlock = self.actionBlock;
        copyInstance.manuallyComplete = self.manuallyComplete;
        copyInstance.completeBlock = self.completeBlock;
    }
    return copyInstance;
}

@end

@implementation ATTaskDelay

+ (instancetype)task:(NSTimeInterval)ti
{
    ATTaskDelay *task = [[ATTaskDelay alloc] init];
    task.ti = ti;
    return task;
}

- (id)copyWithZone:(NSZone *)zone
{
    ATTaskDelay *copyInstance = [super copyWithZone:zone];
    if (copyInstance != nil) {
        copyInstance.ti = self.ti;
    }
    return copyInstance;
}

@end

@implementation ATTaskBase(ATKit)

- (BOOL)normalTask
{
    return [self isKindOfClass:[ATTaskNormal class]];
}

- (BOOL)delayTask
{
    return [self isKindOfClass:[ATTaskDelay class]];
}

@end

@interface ATTaskQueue()

@property (nonatomic, assign) ATTaskQueueType type;
@property (nonatomic, strong) dispatch_queue_t taskQueue;
@property (nonatomic, strong) dispatch_queue_t notifyQueue;
@property (nonatomic, strong) NSMutableArray<ATTaskBase *> *taskList;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, ATTaskBase *> *taskMap;
@property (nonatomic, strong) NSLock *mutexLock;
@property (atomic, assign) BOOL scheduling;

@end

@implementation ATTaskQueue

- (id)initWithType:(ATTaskQueueType)type notifyQueue:(dispatch_queue_t _Nullable)notifyQueue
{
    if (self = [super init]) {
        _type = type;
        
        if (type == ATTaskQueueTypeMainQueue) {
            _taskQueue = dispatch_get_main_queue();
        }
        else if (type == ATTaskQueueTypeSerial) {
            _taskQueue = dispatch_queue_create(AT_TASK_QUEUE_SERIAL, DISPATCH_QUEUE_SERIAL);
        }
        else {
            _taskQueue = dispatch_queue_create(AT_TASK_QUEUE_CONCURRENT, DISPATCH_QUEUE_CONCURRENT);
        }
        
        _notifyQueue = notifyQueue ?: dispatch_get_main_queue();
        _taskList = [NSMutableArray array];
        _taskMap  = [NSMutableDictionary dictionary];
        _mutexLock = [[NSLock alloc] init];
    }
    return self;
}

- (BOOL)empty
{
    BOOL empty = YES;
    
    [self.mutexLock lock];
    empty = (self.taskList.count == 0);
    [self.mutexLock unlock];
    
    return empty;
}

- (void)push:(ATTaskBase *)task
{
    if (task.normalTask) {
        if (AT_TASK_NORMAL(task).actionBlock == nil) {
            return;
        }
    }
    else if (task.delayTask) {
        if (self.type == ATTaskQueueTypeConcurrent) {
            return;
        }
    }
    else {
        return;
    }
    
    task.taskId = ATTaskGenTaskId();
    task.state = ATTaskStateInit;
    
    [self.mutexLock lock];
    if (self.taskMap[@(task.taskId)] == nil) {
        ATTaskBase *aTask = task.copy;
        [self.taskList addObject:aTask];
        self.taskMap[@(aTask.taskId)] = aTask;
    }
    [self.mutexLock unlock];
    
    if (self.scheduling) {
        if (self.type == ATTaskQueueTypeConcurrent) {
            [self dispatchTask:AT_TASK_NORMAL(task) complete:nil];
        }
        else {
            [self runInSerial];
        }
    }
}

- (void)popTask:(ATTaskBase *)task
{
    if (task.state != ATTaskStateDone) {
        return;
    }
    
    [self.mutexLock lock];
    [self.taskList removeObject:task];
    [self.taskMap  removeObjectForKey:@(task.taskId)];
    [self.mutexLock unlock];
}

- (ATTaskBase *)peepTask
{
    ATTaskBase *task = nil;
    [self.mutexLock lock];
    if (self.taskList.count > 0) {
        task = self.taskList.firstObject;
    }
    [self.mutexLock unlock];
    return task;
}

- (void)schedule
{
    if (self.empty || self.scheduling) {
        return;
    }
    
    self.scheduling = YES;
    
    if (self.type == ATTaskQueueTypeConcurrent) {
        [self.mutexLock lock];
        for (ATTaskNormal *task in self.taskList) {
            [self dispatchTask:task complete:nil];
        }
        [self.mutexLock unlock];
    }
    else {
        [self runInSerial];
    }
}

- (void)complete:(ATTaskBase *)task
{
    if (self.type == ATTaskQueueTypeConcurrent) {
        return;
    }
    if (!task.normalTask) {
        return;
    }
    ATTaskBase *aTask = [self peepTask];
    if ([aTask isEqual:task]) {
        [self completeTask:AT_TASK_NORMAL(task) result:nil];
        [self popTask:task];
        [self runInSerial];
    }
}

- (void)dispatchTask:(ATTaskNormal *)task complete:(dispatch_block_t)complete
{
    if (task.state != ATTaskStateInit) {
        return;
    }
    
    task.state = ATTaskStatePending;
    
    AT_WEAKIFY_SELF;
    dispatch_async(self.taskQueue, ^{
        [weak_self actionTask:task complete:complete];
    });
}

- (void)actionTask:(ATTaskNormal *)task complete:(dispatch_block_t)complete
{
    if (task.state != ATTaskStatePending) {
        return;
    }
    
    task.state = ATTaskStateDoing;
    
    id param = nil;
    if (task.paramBlock != nil) {
        param = task.paramBlock(task);
    }
    id result = task.actionBlock(task, param);
    
    if (!task.manuallyComplete) {
        [self completeTask:task result:result];
        [self popTask:task];
        AT_SAFETY_CALL_BLOCK(complete);
    }
}

- (void)completeTask:(ATTaskNormal *)task result:(id)result
{
    task.state = ATTaskStateDone;
    
    ATTaskCompleteBlock block = task.completeBlock;
    if (block != nil) {
        dispatch_async(self.notifyQueue ?: dispatch_get_main_queue(), ^{
            block(task, result);
        });
    }
}

- (void)runInSerial
{
    ATTaskBase *task = [self peepTask];
    if (task != nil) {
        AT_WEAKIFY_SELF;
        if (task.normalTask) {
            [self dispatchTask:AT_TASK_NORMAL(task) complete:^{
                [weak_self runInSerial];
            }];
        }
        else if (task.delayTask) {
            task.state = ATTaskStateDoing;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AT_TASK_DELAY(task).ti * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                task.state = ATTaskStateDone;
                [weak_self popTask:task];
                [weak_self runInSerial];
            });
        }
        else {
            ;
        }
    }
}

@end
