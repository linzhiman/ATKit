//
//  ATComponentService.m
//  ATKit
//
//  Created by linzhiman on 2019/4/28.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ATComponentService.h"

AT_STRING_DEFINE_VALUE(kATComponentServiceCode, @"ATCode")
AT_STRING_DEFINE_VALUE(kATComponentServiceMsg, @"ATMsg")

static NSMapTable *ComponentMap() {
    static NSMapTable *map = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        map = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
    });
    return map;
}

@implementation ATComponentService

+ (BOOL)registerTarget:(NSString *)name aClass:(Class)aClass
{
    if ([ComponentMap() objectForKey:name] == nil) {
        [ComponentMap() setObject:[[aClass alloc] init] forKey:name];
        return YES;
    }
    return NO;
}

+ (BOOL)unRegisterTarget:(NSString *)name aClass:(Class)aClass
{
    id oldObject = [ComponentMap() objectForKey:name];
    if (oldObject != nil && [oldObject isKindOfClass:aClass]) {
        [ComponentMap() removeObjectForKey:name];
        return YES;
    }
    return NO;
}

+ (NSDictionary *)callTarget:(NSString *)name action:(NSString *)action params:(NSDictionary * _Nullable)params
{
    return [self callTarget:name action:action params:params callback:nil];
}

+ (NSDictionary *)callTarget:(NSString *)name action:(NSString *)action params:(NSDictionary * _Nullable)params
                    callback:(ATComponentCallback _Nullable)callback
{
    NSDictionary *aDictionary = nil;
    
    if (name.length == 0 || action.length == 0) {
        aDictionary = [NSDictionary atcs_dicWithCode:ATComponentServiceCodeArgErr msg:@"Argument error"];
    }
    else {
        id anObject = [ComponentMap() objectForKey:name];
        if (anObject == nil) {
            aDictionary = [NSDictionary atcs_dicWithCode:ATComponentServiceCodeNoTarget msg:[NSString stringWithFormat:@"No target named %@", name]];
        }
        else {
            NSString *actionString = [NSString stringWithFormat:@"%@:callback:", action];
            SEL selector = NSSelectorFromString(actionString);
            
            if ([anObject respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                id value = [anObject performSelector:selector withObject:params withObject:callback];
#pragma clang diagnostic pop
                if (value == nil || ![value isKindOfClass:[NSDictionary class]]) {
                    aDictionary = [NSDictionary atcs_dicWithCode:ATComponentServiceCodeResultError msg:[NSString stringWithFormat:@"Result error action %@ in %@", action, name]];
                }
                else {
                    aDictionary = value;
                }
            }
            else {
                aDictionary = [NSDictionary atcs_dicWithCode:ATComponentServiceCodeNoAction msg:[NSString stringWithFormat:@"Unsupported action %@ in %@", action, name]];
            }
        }
    }
    
    return aDictionary;
}

+ (NSDictionary *)callTargetUrl:(NSURL *)url
{
    return [ATComponentService callTargetUrl:url callback:nil];
}

+ (NSDictionary *)callTargetUrl:(NSURL *)url callback:(ATComponentCallback _Nullable)callback
{
    NSString *target = [ATComponentService nameFromUrl:url];
    NSString *action = [ATComponentService actionFromUrl:url];
    NSDictionary *params = [ATComponentService paramsFromUrl:url];
    
    return [ATComponentService callTarget:target action:action params:params callback:callback];
}

+ (NSString *)nameFromUrl:(NSURL *)url
{
    return url.host;
}

+ (NSString *)actionFromUrl:(NSURL *)url
{
    return [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
}

+ (NSDictionary *)paramsFromUrl:(NSURL *)url
{
    NSMutableDictionary *argument = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if (elts.count < 2) {
            continue;
        }
        [argument setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    return [NSDictionary dictionaryWithDictionary:argument];
}

@end


@implementation NSDictionary(ATComponentService)

- (BOOL)atcs_success
{
    return self.atcs_code == 0;
}

- (BOOL)atcs_error
{
    return self.atcs_code != 0;
}

- (NSInteger)atcs_code
{
    id value = self[kATComponentServiceCode];
    if (value != nil && [value isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)value).integerValue;
    }
    return -1;
}

- (NSString *)atcs_msg
{
    return self[kATComponentServiceMsg];
}

+ (instancetype)atcs_resultDic
{
    return [NSDictionary atcs_dicWithCode:ATComponentServiceCodeOK msg:nil];
}

+ (instancetype)atcs_dicWithCode:(NSInteger)code msg:(NSString * _Nullable)msg
{
    return @{ kATComponentServiceCode : @(code),
              kATComponentServiceMsg : msg ?: @""
              };
}

@end


@implementation NSMutableDictionary(ATComponentService)

+ (instancetype)atcs_resultDic
{
    return [[NSDictionary atcs_resultDic] mutableCopy];
}

@end
