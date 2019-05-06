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
    ATTaskStateInit        = 0x01 << 0,
    ATTaskStatePending     = 0x01 << 1,
    ATTaskStateDoing       = 0x01 << 2,
    ATTaskStateDone        = 0x01 << 3
};

typedef NS_ENUM(NSUInteger, ATTaskQueueType) {
    ATTaskQueueTypeMainQueue,
    ATTaskQueueTypeSerial,
    ATTaskQueueTypeConcurrent
};

@class ATTask;

typedef id (^ATTaskParamBlock)(ATTask *task);
typedef id (^ATTaskActionBlock)(ATTask *task, id _Nullable params);
typedef void (^ATTaskCompleteBlock)(ATTask *task, id _Nullable result);

@interface ATTask : NSObject <NSCopying>

@property (nonatomic, assign, readonly) NSUInteger taskId;
@property (nonatomic, assign, readonly) ATTaskState state;
@property (nonatomic, copy, nullable) ATTaskParamBlock paramBlock;
@property (nonatomic, copy) ATTaskActionBlock actionBlock;
@property (nonatomic, copy, nullable) ATTaskCompleteBlock completeBlock;

@end

@interface ATTaskQueue : NSObject

- (id)initWithType:(ATTaskQueueType)type notifyQueue:(dispatch_queue_t _Nullable)notifyQueue;
- (BOOL)empty;
- (void)push:(ATTask *)task;
- (void)schedule;

@end

NS_ASSUME_NONNULL_END
