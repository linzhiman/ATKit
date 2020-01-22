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
AT_DECLARE_NOTIFICATION(kNotification3)

AT_BN_DEFINE(kName)
AT_BN_DEFINE(kName1, int, a)
AT_BN_DEFINE(kName2, int, a, NSString *, b)
AT_BN_DEFINE(kName3, int, a, NSString *, b, id, c)
AT_BN_DEFINE(kName4, int, a, NSString *, b, id, c, id, d)
AT_BN_DEFINE(kName5, int, a, NSString *, b, id, c, id, d, id, e)
AT_BN_DEFINE(kName6, int, a, NSString *, b, id, c, id, d, id, e, id, f)
AT_BN_DEFINE(kName7, int, a, NSString *, b, id, c, id, d, id, e, id, f, id, g)
AT_BN_DEFINE(kName8, int, a, NSString *, b, id, c, id, d, id, e, id, f, id, g, id, h)

@implementation ATKitNotificationTest
@end

#ifdef UseObj
AT_BN_DEFINE(kName9, ATKitNotificationTest *, test);
#else
AT_BN_DEFINE_NO_OBJ(kName9, ATKitNotificationTest *, test);
#endif

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
    
    [self atbn_onkName:^(ATBNkNameObj * _Nonnull obj) {
        NSLog(@"atbn_onkName");
    }];
    [self atbn_onkName3:^(ATBNkName3Obj * _Nonnull obj) {
        NSLog(@"atbn_onkName3 %d %@ %@", obj.a, obj.b, obj.c);
    }];
    
#ifdef UseObj
    [self atbn_onkName9:^(ATBNkName9Obj * _Nonnull obj) {
        NSLog(@"atbn_onkName9 %@", @(obj.test.test));
    }];
#else
    [self atbn_onkName9:^(ATKitNotificationTest * _Nonnull test) {
        NSLog(@"atbn_onkName9 %@", @(test.test));
    }];
#endif
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
//    [self removeNotification];
    
    [self atbn_postNativeName:kNotification1 userInfo:@{kNotificationKey:@(1)}];
    [self atbn_postNativeName:kNotification2 userInfo:@{kNotificationKey:@(2)}];
    
    [self atbn_postkName_];
    [self atbn_postkName3_a:2 b:@"b" c:@(0)];
    
    ATKitNotificationTest *test = [ATKitNotificationTest new];
    test.test = YES;
    [self atbn_postkName9_test:test];
}

@end


@interface ATKitNotificationDemo2 ()

@property (nonatomic, strong) id kNotification2Ob;
@property (nonatomic, strong) id kName3Ob;

@end

@implementation ATKitNotificationDemo2

- (void)demo2_initNotification
{
    [self atbn_addNativeName:kNotification3 block:^(NSDictionary * _Nullable userInfo) {
        NSLog(@"demo2 kNotification3 %@", userInfo);
    }];
// 分类也订阅了kNotification2，子类再次订阅会触发断言，改为force方式
//    [self atbn_addNativeName:kNotification2 block:^(NSDictionary * _Nullable userInfo) {
//        NSLog(@"demo2 kNotification2 %@", userInfo);
//    }];
    self.kNotification2Ob = [self atbn_forceAddNativeName:kNotification2 block:^(NSDictionary * _Nullable userInfo) {
        NSLog(@"demo2 kNotification2 %@", userInfo);
    }];
    
    [self atbn_onkName5:^(ATBNkName5Obj * _Nonnull obj) {
        NSLog(@"demo2 atbn_onkName5");
    }];
// 分类也订阅了kName3，子类再次订阅会触发断言，改为force方式
//    [self atbn_onkName3:^(ATBNkName3Obj * _Nonnull obj) {
//        NSLog(@"demo2 atbn_onkName3");
//    }];
    self.kName3Ob = [self atbn_force_onkName3:^(ATBNkName3Obj * _Nonnull obj) {
        NSLog(@"demo2 atbn_force_onkName3");
    }];
}

- (void)demo2_removeNotification
{
    [self atbn_removeNativeAll];
    [self atbn_removeNativeName:kNotification1];
    [AT_BN_CENTER removeNativeObserver:self.kNotification2Ob];
    
    [self atbn_removeALL];
    [self atbn_removeName:kName];
    [AT_BN_CENTER removeObserver:self.kName3Ob];
}

- (void)demo
{
    [self demo2_initNotification];
    
    [self atbn_postNativeName:kNotification1 userInfo:@{kNotificationKey:@(1)}];
    [self atbn_postNativeName:kNotification2 userInfo:@{kNotificationKey:@(2)}];
    
    [self atbn_postkName_];
    [self atbn_postkName3_a:2 b:@"b" c:@(0)];
    
    [self demo2_removeNotification];
    
    [self atbn_postNativeName:kNotification1 userInfo:@{kNotificationKey:@(1)}];
    [self atbn_postNativeName:kNotification2 userInfo:@{kNotificationKey:@(2)}];
    
    [self atbn_postkName_];
    [self atbn_postkName3_a:2 b:@"b" c:@(0)];
}

@end
