//
//  ATNotificationUtils.h
//  demo
//
//  Created by linzhiman on 2019/4/24.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATNotificationUtils.h"

#define AT_STRING_FROM_OBJECT_NAME(atName) @#atName

//NSString

#define AT_STRING_DEFINE(atName) \
    AT_STRING_DEFINE_VALUE(atName, @#atName)

#define AT_STRING_DEFINE_VALUE(atName, atValue) \
    NSString * const atName = atValue;

#define AT_STRING_EXTERN(atName) \
    extern NSString * const atName;

//Notification

#define AT_DECLARE_NOTIFICATION(atName) \
    NSString * const atName = @#atName;
#define AT_EXTERN_NOTIFICATION(atName) \
    extern NSString * const atName;

#define AT_POST_NOTIFICATION(atName) \
    [ATNotificationUtils postNotificationName:atName object:self];
#define AT_POST_NOTIFICATION(atName, atUserInfo) \
    [ATNotificationUtils postNotificationName:atName object:self userInfo:atUserInfo];
#define AT_REMOVE_NOTIFICATION \
    [AT_NOTIFICATION_SIGNALTON removeObserver:self];

//Singleton

#define AT_DECLARE_SINGLETON \
+ (instancetype)sharedObject;

#define AT_IMPLEMENT_SINGLETON(atType) \
+ (instancetype)sharedObject { \
    static dispatch_once_t __once; \
    static atType *__instance = nil; \
    dispatch_once(&__once, ^{ \
        __instance = [[atType alloc] init]; \
    }); \
    return __instance; \
}

//Block

#define AT_SAFETY_CALL_BLOCK(atBlock, ...) if((atBlock)) { atBlock(__VA_ARGS__); }
