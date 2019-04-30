//
//  ATKitNotificationTest.m
//  ATKitUnitTest
//
//  Created by linzhiman on 2019/4/30.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ATNotificationUtils.h"
#import "ATWeakObject.h"

AT_DECLARE_NOTIFICATION(kNotification1);
AT_DECLARE_NOTIFICATION(kNotification2);

@interface ATNotificationUtils(XCTestCase)

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *observers;//name->[WrapObj]
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableSet *> *notifications;//ObjKey->[name]

@end

@interface ATKitNotificationTest : XCTestCase

@property (nonatomic, strong) NSDictionary *userInfo1;
@property (nonatomic, strong) NSDictionary *userInfo2;

@end

@implementation ATKitNotificationTest

- (void)setUp {
    [AT_NOTIFICATION_SIGNALTON.observers removeAllObjects];
    [AT_NOTIFICATION_SIGNALTON.notifications removeAllObjects];
}

- (void)tearDown {
    [AT_NOTIFICATION_SIGNALTON.observers removeAllObjects];
    [AT_NOTIFICATION_SIGNALTON.notifications removeAllObjects];
}

- (void)testExample {
    [AT_NOTIFICATION_SIGNALTON addObserver:self name:kNotification1 callback:^(NSDictionary * _Nullable userInfo) {
        ;
    }];
    XCTAssert(AT_NOTIFICATION_SIGNALTON.observers.count == 1);
    NSMutableArray *observers = [AT_NOTIFICATION_SIGNALTON.observers objectForKey:kNotification1];
    XCTAssert(observers != nil);
    ATWeakObject *aWrapObj = observers.firstObject;
    XCTAssert(aWrapObj.target == self);
    XCTAssert(AT_NOTIFICATION_SIGNALTON.notifications.count == 1);
    NSMutableSet *notifications = [AT_NOTIFICATION_SIGNALTON.notifications objectForKey:[ATWeakObject objectKey:self]];
    XCTAssert(notifications.count == 1);
    XCTAssert([notifications containsObject:kNotification1]);
}

- (void)testExample2 {
    [AT_NOTIFICATION_SIGNALTON addObserver:self name:kNotification1 callback:^(NSDictionary * _Nullable userInfo) {
        ;
    }];
    [AT_NOTIFICATION_SIGNALTON addObserver:self name:kNotification2 callback:^(NSDictionary * _Nullable userInfo) {
        ;
    }];
    XCTAssert(AT_NOTIFICATION_SIGNALTON.observers.count == 2);
    NSMutableArray *observers = [AT_NOTIFICATION_SIGNALTON.observers objectForKey:kNotification1];
    XCTAssert(observers != nil);
    ATWeakObject *aWrapObj = observers.firstObject;
    XCTAssert(aWrapObj.target == self);
    NSMutableArray *observers2 = [AT_NOTIFICATION_SIGNALTON.observers objectForKey:kNotification2];
    XCTAssert(observers2 != nil);
    ATWeakObject *aWrapObj2 = observers2.firstObject;
    XCTAssert(aWrapObj2.target == self);
    XCTAssert(AT_NOTIFICATION_SIGNALTON.notifications.count == 1);
    NSMutableSet *notifications = [AT_NOTIFICATION_SIGNALTON.notifications objectForKey:[ATWeakObject objectKey:self]];
    XCTAssert(notifications.count == 2);
    XCTAssert([notifications containsObject:kNotification1]);
    XCTAssert([notifications containsObject:kNotification2]);
}

- (void)testExample3 {
    [AT_NOTIFICATION_SIGNALTON addObserver:self name:kNotification1 callback:^(NSDictionary * _Nullable userInfo) {
        ;
    }];
    [AT_NOTIFICATION_SIGNALTON addObserver:self name:kNotification2 callback:^(NSDictionary * _Nullable userInfo) {
        ;
    }];
    [AT_NOTIFICATION_SIGNALTON removeObserver:self name:kNotification1];
    XCTAssert(AT_NOTIFICATION_SIGNALTON.observers.count == 1);
    NSMutableArray *observers = [AT_NOTIFICATION_SIGNALTON.observers objectForKey:kNotification2];
    XCTAssert(observers != nil);
    ATWeakObject *aWrapObj = observers.firstObject;
    XCTAssert(aWrapObj.target == self);
    XCTAssert(AT_NOTIFICATION_SIGNALTON.notifications.count == 1);
    NSMutableSet *notifications = [AT_NOTIFICATION_SIGNALTON.notifications objectForKey:[ATWeakObject objectKey:self]];
    XCTAssert(notifications.count == 1);
    XCTAssert([notifications containsObject:kNotification2]);
}

- (void)testExample4 {
    [AT_NOTIFICATION_SIGNALTON addObserver:self name:kNotification1 callback:^(NSDictionary * _Nullable userInfo) {
        ;
    }];
    [AT_NOTIFICATION_SIGNALTON addObserver:self name:kNotification2 callback:^(NSDictionary * _Nullable userInfo) {
        ;
    }];
    [AT_NOTIFICATION_SIGNALTON removeObserver:self];
    XCTAssert(AT_NOTIFICATION_SIGNALTON.observers.count == 0);
    XCTAssert(AT_NOTIFICATION_SIGNALTON.notifications.count == 0);
}

- (void)testExample5 {
    AT_WEAKIFY_SELF;
    [AT_NOTIFICATION_SIGNALTON addObserver:self name:kNotification1 callback:^(NSDictionary * _Nullable userInfo) {
        weak_self.userInfo1 = userInfo;;
    }];
    [AT_NOTIFICATION_SIGNALTON addObserver:self name:kNotification2 callback:^(NSDictionary * _Nullable userInfo) {
        weak_self.userInfo2 = userInfo;
    }];
    AT_POST_NOTIFICATION_USERINFO(kNotification2, @{@"abc":@(123)});
    XCTAssert(self.userInfo1 == nil);
    XCTAssert([self.userInfo2 isEqualToDictionary:@{@"abc":@(123)}]);
}

@end
