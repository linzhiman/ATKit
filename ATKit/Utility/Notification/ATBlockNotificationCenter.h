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

#define AT_BN_CONNECT(A, B) A##B
#define AT_BN_TYPE(atName) AT_BN_CONNECT(ATBN_, atName)

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
    - (void)atbn_post##atName:(id)sender AT_BN_POST_ARGS(__VA_ARGS__); \
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
    - (void)atbn_post##atName:(id)sender AT_BN_POST_ARGS(__VA_ARGS__) \
    { \
        [AT_BN_CENTER observersNamed:atName block:^(id _Nonnull block) { \
            ((AT_BN_TYPE(atName))block)(AT_EVEN_ARGS(__VA_ARGS__)); \
        }]; \
    } \
    @end

// 监听
// [self atbn_onkName:^(int a, NSString *b) {}];

// 取消监听
// [self atbn_removeName:kName];

// 取消所有监听
// [self atbn_removeALL];

// 发送通知
// [self atbn_postkName:self a:123 b:@"abc"];

@interface ATBlockNotificationCenter : NSObject

AT_DECLARE_SINGLETON;

- (void)addObserver:(id)observer name:(NSString *)name block:(id)block;

- (void)removeObserver:(id)observer name:(NSString *)name;
- (void)removeObserver:(id)observer;

- (void)observersNamed:(NSString *)name block:(void(^)(id))block;

@end


@interface NSObject (ATBN)

- (void)atbn_removeALL;
- (void)atbn_removeName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
