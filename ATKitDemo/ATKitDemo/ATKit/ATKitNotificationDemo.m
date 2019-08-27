//
//  ATKitNotificationDemo.m
//  ATKitDemo
//
//  Created by linzhiman on 2019/4/26.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ATKitNotificationDemo.h"

AT_DECLARE_NOTIFICATION(kNotificationKey)
AT_DECLARE_NOTIFICATION(kNotification1)
AT_DECLARE_NOTIFICATION(kNotification2)

AT_BN_DEFINE(kName, int, a, NSString *, b)
AT_BN_DEFINE(kName2, int, a, NSString *, b, id, c)

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
    [self atbn_addNativeName:kNotification1 block:^(NSDictionary * _Nullable userInfo) {
        NSLog(@"kNotification1 %@", userInfo);
    }];
    [self atbn_addNativeName:kNotification2 block:^(NSDictionary * _Nullable userInfo) {
        NSLog(@"kNotification2 %@", userInfo);
    }];
    
    [self atbn_onkName:^(int a, NSString *b) {
        NSLog(@"atbn_onkName %d %@", a, b);
    }];
    [self atbn_onkName2:^(int a, NSString *b, id c) {
        NSLog(@"atbn_onkName2 %d %@ %@", a, b, c);
    }];
}

- (void)removeNotification
{
    [self atbn_removeNativeAll];
    [self atbn_removeNativeName:kNotification1];
    
    [self atbn_removeALL];
    [self atbn_removeName:kName];
}

- (void)demo
{
    [self removeNotification];
    
    [self atbn_postNativeName:kNotification1 userInfo:@{kNotificationKey:@(1)}];
    [self atbn_postNativeName:kNotification2 userInfo:@{kNotificationKey:@(2)}];
    
    [self atbn_postkName_a:1 b:@"a"];
    [self atbn_postkName2_a:2 b:@"b" c:@(0)];
}

@end
