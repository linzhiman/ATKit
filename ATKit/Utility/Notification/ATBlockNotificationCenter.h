//
//  ATBlockNotificationCenter.h
//  ATKit
//
//  Created by linzhiman on 2019/8/22.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATGlobalMacro.h"

NS_ASSUME_NONNULL_BEGIN

#define AT_BN_CENTER [ATBlockNotificationCenter sharedObject]

#define AT_BN_TYPE(atName) metamacro_concat(ATBN_, atName)

#define AT_BN_POST_ARGS_HANDLER(first, second) second:(first)second
#define AT_BN_POST_ARGS_(...) metamacro_concat(AT_MAKE_ARG_, metamacro_argcount(__VA_ARGS__))(AT_MAKE_ARG_SPACE, AT_BN_POST_ARGS_HANDLER, __VA_ARGS__)
#define AT_BN_POST_ARGS(...) AT_BN_POST_ARGS_(__VA_ARGS__)

// 头文件添加申明
// AT_BN_DECLARE(kName, int, a, NSString *, b)
#define AT_BN_DECLARE(atName, ...) \
    AT_STRING_EXTERN(atName); \
    typedef void(^AT_BN_TYPE(atName))(AT_PAIR_CONCAT_ARGS(__VA_ARGS__)); \
    @interface NSObject (ATBN##atName) \
    - (void)atbn_on##atName:(AT_BN_TYPE(atName))block; \
    - (void)metamacro_concat(atbn_post##atName##_, AT_BN_POST_ARGS(__VA_ARGS__)); \
    @end

// 实现文件添加定义
// AT_BN_DEFINE(kName, int, a, NSString *, b)
#define AT_BN_DEFINE(atName, ...) \
    AT_STRING_DEFINE(atName); \
    @implementation NSObject (ATBN##atName) \
    - (void)atbn_on##atName:(AT_BN_TYPE(atName))block \
    { \
        [AT_BN_CENTER addObserver:self name:atName block:block]; \
    } \
    - (void)metamacro_concat(atbn_post##atName##_, AT_BN_POST_ARGS(__VA_ARGS__)) \
    { \
        NSArray *blocksNamed = [AT_BN_CENTER blocksNamed:atName]; \
        dispatch_async(dispatch_get_main_queue(), ^{ \
            for (id block in blocksNamed) { \
                ((AT_BN_TYPE(atName))block)(AT_EVEN_ARGS(__VA_ARGS__)); \
            } \
        }); \
    } \
    @end

// 监听
// [self atbn_onkName:^(int a, NSString *b) {}];

// 取消监听
// [self atbn_removeName:kName];

// 取消所有监听
// [self atbn_removeALL];

// 发送通知
// [self atbn_postkName_a:123 b:@"abc"];

typedef void (^ATBNNativeBlock)(NSDictionary * _Nullable userInfo);

@interface ATBlockNotificationCenter : NSObject

AT_DECLARE_SINGLETON;

// 建议使用上面描述的方式调用

- (void)addObserver:(id)observer name:(NSString *)name block:(id)block;

- (void)removeObserver:(id)observer name:(NSString *)name;
- (void)removeObserver:(id)observer;

- (NSArray *)blocksNamed:(NSString *)name;

#pragma mark - Native Notification

// 建议使用NSObject (ATBN)中的方法调用

- (void)addNativeObserver:(id)observer name:(NSString *)name block:(ATBNNativeBlock)block;

- (void)removeNativeObserver:(id)observer name:(NSString *)name;
- (void)removeNativeObserver:(id)observer;

@end


@interface NSObject (ATBN)

- (void)atbn_removeALL;
- (void)atbn_removeName:(NSString *)name;

#pragma mark - Native Notification

- (void)atbn_addNativeName:(NSString *)name block:(ATBNNativeBlock)block;

- (void)atbn_removeNativeName:(NSString *)name;
- (void)atbn_removeNativeAll;

- (void)atbn_postNativeName:(NSString *)name;
- (void)atbn_postNativeName:(NSString *)name userInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
