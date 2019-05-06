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

NSUInteger ATTaskGenTaskId()
{
    static NSUInteger taskId = 0;
    return ++taskId;
}

@interface ATTask()

@property (nonatomic, assign) NSUInteger taskId;
@property (nonatomic, assign) ATTaskState state;

@end

@implementation ATTask

- (id)copyWithZone:(NSZone *)zone
{
    ATTask *copyInstance = [ATTask allocWithZone:zone];
    if (copyInstance != nil) {
        copyInstance.state = self.state;
        copyInstance.taskId = self.taskId;
        copyInstance.paramBlock = self.paramBlock;
        copyInstance.actionBlock = self.actionBlock;
        copyInstance.completeBlock = self.completeBlock;
    }
    return copyInstance;
}

- (BOOL)isEqual:(ATTask *)object
{
    return self == object || self.taskId == object.taskId;
}

@end

@interface ATTaskQueue()

@property (nonatomic, strong) dispatch_queue_t taskQueue;
@property (nonatomic, strong) dispatch_queue_t notifyQueue;
@property (nonatomic, strong) NSMutableArray<ATTask *> *taskList;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, ATTask *> *taskMap;
@property (nonatomic, strong) NSLock *mutexLock;
@property (atomic, assign) BOOL scheduling;

@end

@implementation ATTaskQueue

- (id)initWithType:(ATTaskQueueType)type notifyQueue:(dispatch_queue_t _Nullable)notifyQueue
{
    if (self = [super init]) {
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

- (void)push:(ATTask *)task
{
    if (task.actionBlock == nil) {
        return;
    }
    
    task.taskId = ATTaskGenTaskId();
    task.state = ATTaskStateInit;
    
    [self.mutexLock lock];
    if (self.taskMap[@(task.taskId)] == nil) {
        ATTask *aTask = task.copy;
        [self.taskList addObject:aTask];
        self.taskMap[@(aTask.taskId)] = aTask;
    }
    [self.mutexLock unlock];
    
    if (self.scheduling) {
        [self dispatchTask:task];
    }
}

- (void)popTask:(ATTask *)task
{
    if (task.state != ATTaskStateDone) {
        return;
    }
    
    [self.mutexLock lock];
    [self.taskList removeObject:task];
    [self.taskMap  removeObjectForKey:@(task.taskId)];
    [self.mutexLock unlock];
}

- (void)schedule
{
    if (self.empty || self.scheduling) {
        return;
    }
    
    self.scheduling = YES;
    
    [self.mutexLock lock];
    for (ATTask *task in self.taskList) {
        [self dispatchTask:task];
    }
    [self.mutexLock unlock];
}

- (void)dispatchTask:(ATTask *)task
{
    if (task.state != ATTaskStateInit) {
        return;
    }
    
    task.state = ATTaskStatePending;
    
    AT_WEAKIFY_SELF;
    dispatch_async(self.taskQueue, ^{
        [weak_self actionTask:task];
    });
}

- (void)actionTask:(ATTask *)task
{
    NSLog(@"ATTaskQueueTest run %@ in %@", @(task.taskId), [NSThread currentThread]);
    
    if (task.state != ATTaskStatePending) {
        return;
    }
    
    task.state = ATTaskStateDoing;
    
    id param = nil;
    if (task.paramBlock != nil) {
        param = task.paramBlock(task);
    }
    id result = task.actionBlock(task, param);
    
    task.state = ATTaskStateDone;
    
    ATTaskCompleteBlock block = task.completeBlock;
    if (block != nil) {
        dispatch_async(self.notifyQueue ?: dispatch_get_main_queue(), ^{
            block(task, result);
        });
    }
}

@end
