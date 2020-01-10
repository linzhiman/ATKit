//
//  ATBlockNotificationCenter.h
//  ATKit
//
//  Created by linzhiman on 2019/8/22.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATGlobalMacro.h"

// 最大支持8个参数，如需调整，修改ATGlobalMacro.h

// 如果编译不通过，提示类似下面信息，请添加下面的宏
// 常用系统类型在这里添加，自定义类型在app工程对应文件添加，建议添加一个公用文件并加入预编译便于使用
// Unknown type name 'AT_PROPERTY_DECLARE_HANDLER_xxx'
// #define AT_PROPERTY_DECLARE_HANDLER_xxx AT_PROPERTY_DECLARE_STRONG xxx

NS_ASSUME_NONNULL_BEGIN

#define AT_BN_CENTER [ATBlockNotificationCenter sharedObject]
#define AT_BN_BLOCK_TYPE(atName) metamacro_concat(ATBN_, atName)

// 头文件添加申明
// AT_BN_DECLARE(kName, int, a, NSString *, b)
#define AT_BN_DECLARE(atName, ...) \
    extern NSString * const atName; \
    @interface ATBN##atName##Obj : NSObject \
    AT_PROPERTY_DECLARE(__VA_ARGS__) \
    @end \
    typedef void(^AT_BN_BLOCK_TYPE(atName))(ATBN##atName##Obj *obj); \
    @interface NSObject (ATBN##atName) \
    - (void)atbn_on##atName:(AT_BN_BLOCK_TYPE(atName))block; \
    - (void)metamacro_concat(atbn_post##atName##_, AT_SELECTOR_ARGS(__VA_ARGS__)); \
    @end

// 实现文件添加定义
// AT_BN_DEFINE(kName, int, a, NSString *, b)
#define AT_BN_DEFINE(atName, ...) \
    NSString * const atName = @"ATBN_"#atName; \
    @implementation ATBN##atName##Obj \
    @end \
    @implementation NSObject (ATBN##atName) \
    - (void)atbn_on##atName:(AT_BN_BLOCK_TYPE(atName))block \
    { \
        [AT_BN_CENTER addObserver:self name:atName block:block]; \
    } \
    - (void)metamacro_concat(atbn_post##atName##_, AT_SELECTOR_ARGS(__VA_ARGS__)) \
    { \
        ATBN##atName##Obj *obj = [ATBN##atName##Obj new]; \
        AT_PROPERTY_SET_VALUE(__VA_ARGS__) \
        NSArray *blocksNamed = [AT_BN_CENTER blocksNamed:atName]; \
        if ([NSThread isMainThread]) { \
            for (id block in blocksNamed) { \
                ((AT_BN_BLOCK_TYPE(atName))block)(obj); \
            } \
        } \
        else { \
            dispatch_async(dispatch_get_main_queue(), ^{ \
                for (id block in blocksNamed) { \
                    ((AT_BN_BLOCK_TYPE(atName))block)(obj); \
                } \
            }); \
        } \
    } \
    @end

// 监听
// [self atbn_onkName:^(ATBNkNameObj * _Nonnull obj) {}];

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
