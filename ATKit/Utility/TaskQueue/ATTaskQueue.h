//
//  ATTaskQueue.h
//  ATKit
//
//  Created by linzhiman on 2019/5/5.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ATTaskState) {
    ATTaskStateInit,
    ATTaskStatePending,
    ATTaskStateDoing,
    ATTaskStateDone
};

typedef NS_ENUM(NSUInteger, ATTaskQueueType) {
    ATTaskQueueTypeMainQueue,
    ATTaskQueueTypeSerial,
    ATTaskQueueTypeConcurrent
};

@interface ATTaskBase : NSObject<NSCopying>

@property (nonatomic, assign, readonly) NSUInteger taskId;
@property (nonatomic, assign, readonly) ATTaskState state;

@end

@class ATTaskNormal;

typedef id (^ATTaskParamBlock)(ATTaskNormal *task);
typedef id (^ATTaskActionBlock)(ATTaskNormal *task, id _Nullable params);
typedef void (^ATTaskCompleteBlock)(ATTaskNormal *task, id _Nullable result);

@interface ATTaskNormal : ATTaskBase

@property (nonatomic, copy, nullable) ATTaskParamBlock paramBlock;
@property (nonatomic, copy) ATTaskActionBlock actionBlock;

@property (nonatomic, assign) BOOL manuallyComplete;
@property (nonatomic, copy, nullable) ATTaskCompleteBlock completeBlock;

@end

@interface ATTaskDelay : ATTaskBase

@property (nonatomic, assign) NSTimeInterval ti;

+ (instancetype)task:(NSTimeInterval)ti;

@end

@interface ATTaskBase(ATKit)

- (BOOL)normalTask;
- (BOOL)delayTask;

@end

@interface ATTaskQueue : NSObject

- (id)initWithType:(ATTaskQueueType)type notifyQueue:(dispatch_queue_t _Nullable)notifyQueue;
- (BOOL)empty;
- (void)push:(ATTaskBase *)task;
- (void)schedule;
- (void)complete:(ATTaskBase *)task;

@end

NS_ASSUME_NONNULL_END
