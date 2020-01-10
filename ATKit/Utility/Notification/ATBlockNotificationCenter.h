//
//  ATBlockNotificationCenter.h
//  ATKit
//
//  Created by linzhiman on 2019/8/22.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATGlobalMacro.h"

// 如果编译不通过，提示类似下面信息，请添加下面的宏
// 常用系统类型在这里添加，自定义类型在app工程对应文件添加，建议添加一个公用文件并加入预编译便于使用
// Unknown type name 'AT_BN_PROPERTY_HANDLER_abc'
// #define AT_BN_PROPERTY_HANDLER_abc AT_BN_PROPERTY_ASSIGN abc

NS_ASSUME_NONNULL_BEGIN

#define AT_BN_CENTER [ATBlockNotificationCenter sharedObject]

#define AT_BN_DEFINE_STR(atName) NSString * const atName = @"ATBN_"#atName;
#define AT_BN_EXTERN_STR(atName) extern NSString * const atName;

#define AT_BN_CENTER [ATBlockNotificationCenter sharedObject]

#define AT_BN_TYPE(atName) metamacro_concat(ATBN_, atName)

#define AT_BN_POST_ARGS_HANDLER(first, second) second:(first)second
#define AT_BN_POST_ARGS_(...) metamacro_concat(AT_MAKE_ARG_, metamacro_argcount(__VA_ARGS__))(AT_MAKE_ARG_SPACE, AT_MAKE_ARG_SPACE, AT_BN_POST_ARGS_HANDLER, __VA_ARGS__)
#define AT_BN_POST_ARGS(...) AT_BN_POST_ARGS_(__VA_ARGS__)

#define AT_BN_PROPERTY_ASSIGN @property (nonatomic, assign)
#define AT_BN_PROPERTY_STRONG @property (nonatomic, strong)
#define AT_BN_PROPERTY_COPY   @property (nonatomic, copy)

// C Types
#define AT_BN_PROPERTY_HANDLER_bool     AT_BN_PROPERTY_ASSIGN bool
#define AT_BN_PROPERTY_HANDLER_char     AT_BN_PROPERTY_ASSIGN char
#define AT_BN_PROPERTY_HANDLER_short    AT_BN_PROPERTY_ASSIGN short
#define AT_BN_PROPERTY_HANDLER_int      AT_BN_PROPERTY_ASSIGN int
#define AT_BN_PROPERTY_HANDLER_long     AT_BN_PROPERTY_ASSIGN long
#define AT_BN_PROPERTY_HANDLER_float    AT_BN_PROPERTY_ASSIGN float
#define AT_BN_PROPERTY_HANDLER_double   AT_BN_PROPERTY_ASSIGN double
#define AT_BN_PROPERTY_HANDLER_unsigned AT_BN_PROPERTY_ASSIGN unsigned
#define AT_BN_PROPERTY_HANDLER_int8_t   AT_BN_PROPERTY_ASSIGN int8_t
#define AT_BN_PROPERTY_HANDLER_int16_t  AT_BN_PROPERTY_ASSIGN int16_t
#define AT_BN_PROPERTY_HANDLER_int32_t  AT_BN_PROPERTY_ASSIGN int32_t
#define AT_BN_PROPERTY_HANDLER_int64_t  AT_BN_PROPERTY_ASSIGN int64_t
#define AT_BN_PROPERTY_HANDLER_uint8_t  AT_BN_PROPERTY_ASSIGN uint8_t
#define AT_BN_PROPERTY_HANDLER_uint16_t AT_BN_PROPERTY_ASSIGN uint16_t
#define AT_BN_PROPERTY_HANDLER_uint32_t AT_BN_PROPERTY_ASSIGN uint32_t
#define AT_BN_PROPERTY_HANDLER_uint64_t AT_BN_PROPERTY_ASSIGN uint64_t
// NS Types
#define AT_BN_PROPERTY_HANDLER_BOOL             AT_BN_PROPERTY_ASSIGN BOOL
#define AT_BN_PROPERTY_HANDLER_Boolean          AT_BN_PROPERTY_ASSIGN Boolean
#define AT_BN_PROPERTY_HANDLER_NSInteger        AT_BN_PROPERTY_ASSIGN NSInteger
#define AT_BN_PROPERTY_HANDLER_NSUInteger       AT_BN_PROPERTY_ASSIGN NSUInteger
#define AT_BN_PROPERTY_HANDLER_NSTimeInterval   AT_BN_PROPERTY_ASSIGN NSTimeInterval
#define AT_BN_PROPERTY_HANDLER_CGFloat          AT_BN_PROPERTY_ASSIGN CGFloat
#define AT_BN_PROPERTY_HANDLER_CGSize           AT_BN_PROPERTY_ASSIGN CGSize
#define AT_BN_PROPERTY_HANDLER_CGRect           AT_BN_PROPERTY_ASSIGN CGRect
#define AT_BN_PROPERTY_HANDLER_Class            AT_BN_PROPERTY_ASSIGN Class
#define AT_BN_PROPERTY_HANDLER_SEL              AT_BN_PROPERTY_ASSIGN SEL
#define AT_BN_PROPERTY_HANDLER_IMP              AT_BN_PROPERTY_ASSIGN IMP
// NS class
#define AT_BN_PROPERTY_HANDLER_id                   AT_BN_PROPERTY_STRONG id
#define AT_BN_PROPERTY_HANDLER_NSObject             AT_BN_PROPERTY_STRONG NSObject
#define AT_BN_PROPERTY_HANDLER_NSString             AT_BN_PROPERTY_COPY   NSString
#define AT_BN_PROPERTY_HANDLER_NSMutableString      AT_BN_PROPERTY_COPY   NSMutableString
#define AT_BN_PROPERTY_HANDLER_NSValue              AT_BN_PROPERTY_STRONG NSValue
#define AT_BN_PROPERTY_HANDLER_NSNumber             AT_BN_PROPERTY_STRONG NSNumber
#define AT_BN_PROPERTY_HANDLER_NSDecimalNumber      AT_BN_PROPERTY_STRONG NSDecimalNumber
#define AT_BN_PROPERTY_HANDLER_NSData               AT_BN_PROPERTY_COPY   NSData
#define AT_BN_PROPERTY_HANDLER_NSMutableData        AT_BN_PROPERTY_COPY   NSMutableData
#define AT_BN_PROPERTY_HANDLER_NSDate               AT_BN_PROPERTY_STRONG NSDate
#define AT_BN_PROPERTY_HANDLER_NSURL                AT_BN_PROPERTY_STRONG NSURL
#define AT_BN_PROPERTY_HANDLER_NSArray              AT_BN_PROPERTY_COPY   NSArray
#define AT_BN_PROPERTY_HANDLER_MutableArray         AT_BN_PROPERTY_COPY   MutableArray
#define AT_BN_PROPERTY_HANDLER_NSDictionary         AT_BN_PROPERTY_COPY   NSDictionary
#define AT_BN_PROPERTY_HANDLER_NSMutableDictionary  AT_BN_PROPERTY_COPY   NSMutableDictionary
#define AT_BN_PROPERTY_HANDLER_NSSet                AT_BN_PROPERTY_COPY   NSSet
#define AT_BN_PROPERTY_HANDLER_NSMutableSet         AT_BN_PROPERTY_COPY   NSMutableSet
#define AT_BN_PROPERTY_HANDLER_UIColor              AT_BN_PROPERTY_STRONG UIColor
#define AT_BN_PROPERTY_HANDLER_UIView               AT_BN_PROPERTY_STRONG UIView

// @property (nonatomic, strong) id a;
#define AT_BN_PROPERTY_HANDLER(first, second) metamacro_concat(AT_BN_PROPERTY_HANDLER_, first)second;
#define AT_BN_PROPERTY_(...) metamacro_concat(AT_MAKE_ARG_, metamacro_argcount(__VA_ARGS__))(AT_MAKE_ARG_SPACE, AT_MAKE_ARG_SPACE, AT_BN_PROPERTY_HANDLER, __VA_ARGS__)
#define AT_BN_PROPERTY(...) AT_BN_PROPERTY_(__VA_ARGS__)

// obj.a = a;
#define AT_BN_PROPERTY_SETVALUE_HANDLER(first, second) obj.second = second;
#define AT_BN_PROPERTY_SETVALUE_(...) metamacro_concat(AT_MAKE_ARG_, metamacro_argcount(__VA_ARGS__))(AT_MAKE_ARG_SPACE, AT_MAKE_ARG_SPACE, AT_BN_PROPERTY_SETVALUE_HANDLER, __VA_ARGS__)
#define AT_BN_PROPERTY_SETVALUE(...) AT_BN_PROPERTY_SETVALUE_(__VA_ARGS__)

// 最大支持8个参数，如需调整，修改ATGlobalMacro.h

// 头文件添加申明
// AT_BN_DECLARE(kName, int, a, NSString *, b)
#define AT_BN_DECLARE(atName, ...) \
    AT_BN_EXTERN_STR(atName); \
    @interface ATBN##atName##Obj : NSObject \
    AT_BN_PROPERTY(__VA_ARGS__) \
    @end \
    typedef void(^AT_BN_TYPE(atName))(ATBN##atName##Obj *obj); \
    @interface NSObject (ATBN##atName) \
    - (void)atbn_on##atName:(AT_BN_TYPE(atName))block; \
    - (void)metamacro_concat(atbn_post##atName##_, AT_BN_POST_ARGS(__VA_ARGS__)); \
    @end

// 实现文件添加定义
// AT_BN_DEFINE(kName, int, a, NSString *, b)
#define AT_BN_DEFINE(atName, ...) \
    AT_BN_DEFINE_STR(atName); \
    @implementation ATBN##atName##Obj \
    @end \
    @implementation NSObject (ATBN##atName) \
    - (void)atbn_on##atName:(AT_BN_TYPE(atName))block \
    { \
        [AT_BN_CENTER addObserver:self name:atName block:block]; \
    } \
    - (void)metamacro_concat(atbn_post##atName##_, AT_BN_POST_ARGS(__VA_ARGS__)) \
    { \
        ATBN##atName##Obj *obj = [ATBN##atName##Obj new]; \
        AT_BN_PROPERTY_SETVALUE(__VA_ARGS__) \
        NSArray *blocksNamed = [AT_BN_CENTER blocksNamed:atName]; \
        if ([NSThread isMainThread]) { \
            for (id block in blocksNamed) { \
                ((AT_BN_TYPE(atName))block)(obj); \
            } \
        } \
        else { \
            dispatch_async(dispatch_get_main_queue(), ^{ \
                for (id block in blocksNamed) { \
                    ((AT_BN_TYPE(atName))block)(obj); \
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
