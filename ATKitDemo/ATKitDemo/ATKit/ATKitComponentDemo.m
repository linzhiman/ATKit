//
//  ATKitComponentDemo.m
//  ATKitDemo
//
//  Created by linzhiman on 2019/4/29.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ATKitComponentDemo.h"

@implementation ATKitComponentA

AT_COMPONENT_ACTION(version)
{
    NSString *prefix = params[@"prefix"];
    NSString *version = [prefix stringByAppendingString:@"123"];
    NSMutableDictionary *dic = [NSMutableDictionary atcs_resultDic];
    [dic setObject:version forKey:@"version"];
    AT_SAFETY_CALL_BLOCK(callback, dic);
    return dic;
}

@end

@implementation ATComponentService(ComponentA)

+ (NSString *)a_versionWithPrefix:(NSString *)prefix callback:(void(^)(NSString *version))callback
{
    NSDictionary *result = [ATComponentService callTarget:@"A" action:@"version" params:@{@"prefix":prefix} callback:^(NSDictionary * _Nullable params) {
        AT_SAFETY_CALL_BLOCK(callback, params[@"version"]);
    }];
    return result[@"version"];
}

@end

@interface ATKitComponentDemo()

@end

@implementation ATKitComponentDemo

static NSString * _Nonnull extracted() {
    return [ATComponentService a_versionWithPrefix:@"abc" callback:^(NSString * _Nonnull version) {
        NSLog(@"ATKitComponentDemo callback %@", version);
    }];
}

- (void)demo
{
    AT_COMPONENT_REGISTER(A, ATKitComponentA);
    
    NSString *version = extracted();
    NSLog(@"ATKitComponentDemo retrun %@", version);
}

@end
