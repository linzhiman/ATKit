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
    NSMutableDictionary *dic = [NSMutableDictionary atcs_resultDic];
    [dic setObject:@"123" forKey:@"version"];
    return dic;
}

@end

@interface ATKitComponentDemo()

@end

@implementation ATKitComponentDemo

- (void)demo
{
    AT_COMPONENT_REGISTER(A, ATKitComponentA);
    
    NSDictionary *result = [ATComponentService callTarget:@"A" action:@"version" params:nil callback:nil];
    NSLog(@"ATKitComponentDemo version %@", result[@"version"]);
}

@end
