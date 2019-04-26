//
//  ATNotificationUtils.h
//  demo
//
//  Created by linzhiman on 2019/4/24.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AT_STRING_FROM_OBJECT_NAME(atName) @#atName

//NSString

#define AT_STRING_DEFINE(atName) \
    AT_STRING_DEFINE_VALUE(atName, @#atName)

#define AT_STRING_DEFINE_VALUE(atName, atValue) \
    NSString * const atName = atValue;

#define AT_STRING_EXTERN(atName) \
    extern NSString * const atName;

//Singleton

#define AT_DECLARE_SINGLETON \
+ (instancetype)sharedObject;

#define AT_IMPLEMENT_SINGLETON(__TYPE__) \
+ (instancetype)sharedObject { \
    static dispatch_once_t __once; \
    static __TYPE__ *__instance = nil; \
    dispatch_once(&__once, ^{ \
        __instance = [[__TYPE__ alloc] init]; \
    }); \
    return __instance; \
}

//Block

#define AT_SAFETY_CALL_BLOCK(block, ...) if((block)) { block(__VA_ARGS__); }
