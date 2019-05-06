//
//  ATTaskQueueTest.m
//  ATKitUnitTest
//
//  Created by linzhiman on 2019/5/6.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ATTaskQueue.h"
#import "ATGlobalMacro.h"

@interface ATTaskQueueTest : XCTestCase

@property (nonatomic, strong) ATTaskQueue *taskQueue;
@property (nonatomic, strong) XCTestExpectation *exception;
@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, strong) NSMutableArray *finisheds;
@property (nonatomic, strong) dispatch_queue_t notifyQueue;

@end

@implementation ATTaskQueueTest

- (void)setUp {
    self.actions = [[NSMutableArray alloc] init];
    self.finisheds = [[NSMutableArray alloc] init];
}

- (void)tearDown {
    [self.actions removeAllObjects];
    [self.finisheds removeAllObjects];
}

- (void)testExample {
    self.exception = [self expectationWithDescription:@"1"];
    self.notifyQueue = nil;
    self.taskQueue = [[ATTaskQueue alloc] initWithType:ATTaskQueueTypeMainQueue notifyQueue:self.notifyQueue];
    AT_WEAKIFY_SELF;
    for (NSUInteger i = 0; i < 10; ++i) {
        ATTaskNormal *task = [[ATTaskNormal alloc] init];
        task.actionBlock = ^id(ATTaskNormal * _Nonnull task, id  _Nullable params) {
            NSLog(@"ATTaskQueueTest action %@ params %@", @(task.taskId), params);
            [weak_self.actions addObject:@(task.taskId)];
            return nil;
        };
        task.completeBlock = ^(ATTaskNormal * _Nonnull task, id  _Nullable result) {
            NSLog(@"ATTaskQueueTest finished %@ result %@", @(task.taskId), result);
            [weak_self.finisheds addObject:@(task.taskId)];
            if (weak_self.finisheds.count == 10) {
                [self.exception fulfill];
            }
        };
        [self.taskQueue push:task];
    }
    [self.taskQueue schedule];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testExample2 {
    self.exception = [self expectationWithDescription:@"2"];
    self.notifyQueue = dispatch_queue_create("ATTaskQueueTestQueue", DISPATCH_QUEUE_SERIAL);
    self.taskQueue = [[ATTaskQueue alloc] initWithType:ATTaskQueueTypeSerial notifyQueue:self.notifyQueue];
    AT_WEAKIFY_SELF;
    for (NSUInteger i = 0; i < 10; ++i) {
        ATTaskNormal *task = [[ATTaskNormal alloc] init];
        task.actionBlock = ^id(ATTaskNormal * _Nonnull task, id  _Nullable params) {
            NSLog(@"ATTaskQueueTest action %@ params %@", @(task.taskId), params);
            [weak_self.actions addObject:@(task.taskId)];
            return nil;
        };
        task.completeBlock = ^(ATTaskNormal * _Nonnull task, id  _Nullable result) {
            NSLog(@"ATTaskQueueTest finished %@ result %@", @(task.taskId), result);
            [weak_self.finisheds addObject:@(task.taskId)];
            if (weak_self.finisheds.count == 10) {
                [self.exception fulfill];
            }
        };
        [self.taskQueue push:task];
    }
    [self.taskQueue schedule];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testExample3 {
    self.exception = [self expectationWithDescription:@"3"];
    self.notifyQueue = dispatch_queue_create("ATTaskQueueTestQueue", DISPATCH_QUEUE_SERIAL);
    self.taskQueue = [[ATTaskQueue alloc] initWithType:ATTaskQueueTypeConcurrent notifyQueue:self.notifyQueue];
    AT_WEAKIFY_SELF;
    for (NSUInteger i = 0; i < 10; ++i) {
        ATTaskNormal *task = [[ATTaskNormal alloc] init];
        task.actionBlock = ^id(ATTaskNormal * _Nonnull task, id  _Nullable params) {
            NSLog(@"ATTaskQueueTest action %@ params %@ thread %@", @(task.taskId), params, [NSThread currentThread]);
            [weak_self.actions addObject:@(task.taskId)];
            return nil;
        };
        task.completeBlock = ^(ATTaskNormal * _Nonnull task, id  _Nullable result) {
            NSLog(@"ATTaskQueueTest finished %@ result %@", @(task.taskId), result);
            [weak_self.finisheds addObject:@(task.taskId)];
            if (weak_self.finisheds.count == 10) {
                [self.exception fulfill];
            }
        };
        [self.taskQueue push:task];
    }
    [self.taskQueue schedule];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testExample4 {
    self.exception = [self expectationWithDescription:@"4"];
    self.notifyQueue = dispatch_queue_create("ATTaskQueueTestQueue", DISPATCH_QUEUE_SERIAL);
    self.taskQueue = [[ATTaskQueue alloc] initWithType:ATTaskQueueTypeConcurrent notifyQueue:self.notifyQueue];
    AT_WEAKIFY_SELF;
    for (NSUInteger i = 0; i < 11; ++i) {
        ATTaskNormal *task = [[ATTaskNormal alloc] init];
        task.paramBlock = ^id(ATTaskNormal * _Nonnull task) {
            return @(100 + i);
        };
        task.actionBlock = ^id(ATTaskNormal * _Nonnull task, id  _Nullable params) {
            NSLog(@"ATTaskQueueTest action %@ params %@ thread %@", @(task.taskId), params, [NSThread currentThread]);
            [weak_self.actions addObject:@(task.taskId)];
            return params;
        };
        task.completeBlock = ^(ATTaskNormal * _Nonnull task, id  _Nullable result) {
            NSLog(@"ATTaskQueueTest finished %@ result %@", @(task.taskId), result);
            [weak_self.finisheds addObject:@(task.taskId)];
            if (weak_self.finisheds.count == 10) {
                [self.exception fulfill];
            }
        };
        [self.taskQueue push:task];
        if (i == 10) {
            [self.taskQueue schedule];
        }
    }
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testExample5 {
    self.exception = [self expectationWithDescription:@"5"];
    self.notifyQueue = nil;
    self.taskQueue = [[ATTaskQueue alloc] initWithType:ATTaskQueueTypeSerial notifyQueue:self.notifyQueue];
    AT_WEAKIFY_SELF;
    for (NSUInteger i = 0; i < 10; ++i) {
        ATTaskNormal *task = [[ATTaskNormal alloc] init];
        task.actionBlock = ^id(ATTaskNormal * _Nonnull task, id  _Nullable params) {
            NSLog(@"ATTaskQueueTest action %@ params %@", @(task.taskId), params);
            [weak_self.actions addObject:@(task.taskId)];
            return nil;
        };
        task.completeBlock = ^(ATTaskNormal * _Nonnull task, id  _Nullable result) {
            NSLog(@"ATTaskQueueTest finished %@ result %@", @(task.taskId), result);
            [weak_self.finisheds addObject:@(task.taskId)];
            if (weak_self.finisheds.count == 10) {
                [self.exception fulfill];
            }
        };
        [self.taskQueue push:task];
        if (i % 3 == 0) {
            [self.taskQueue push:[ATTaskDelay task:2.5]];
        }
    }
    [self.taskQueue schedule];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
