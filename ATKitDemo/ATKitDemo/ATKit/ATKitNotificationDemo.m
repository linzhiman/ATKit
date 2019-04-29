//
//  ATKitNotificationDemo.m
//  ATKitDemo
//
//  Created by linzhiman on 2019/4/26.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ATKitNotificationDemo.h"
#import "ATNotificationUtils.h"

AT_DECLARE_NOTIFICATION(kNotificationKey)
AT_DECLARE_NOTIFICATION(kNotification1)
AT_DECLARE_NOTIFICATION(kNotification2)

@implementation ATKitNotificationDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initNotification];
    }
    return self;
}

- (void)dealloc
{
    [self removeNotification];
}

- (void)initNotification
{
    [AT_NOTIFICATION_SIGNALTON addObserver:self name:kNotification1 callback:^(NSDictionary * _Nullable userInfo) {
        NSLog(@"kNotification1 %@", userInfo);
    }];
    [AT_NOTIFICATION_SIGNALTON addObserver:self name:kNotification2 callback:^(NSDictionary * _Nullable userInfo) {
        NSLog(@"kNotification2 %@", userInfo);
    }];
}

- (void)removeNotification
{
    [AT_NOTIFICATION_SIGNALTON removeObserver:self];
}

- (void)demo
{
    AT_POST_NOTIFICATION_USERINFO(kNotification1, @{kNotificationKey:@(1)});
    AT_POST_NOTIFICATION_USERINFO(kNotification2, @{kNotificationKey:@(2)});
}

@end
