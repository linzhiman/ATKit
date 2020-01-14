//
//  ATKitProtocolManagerDemo.m
//  ATKitDemo
//
//  Created by linzhiman on 2019/4/28.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ATKitProtocolManagerDemo.h"

@implementation ATKitProtocolManagerClassA

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"ATKitProtocolManagerClassA init");
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"ATKitProtocolManagerClassA dealloc");
}

- (void)base
{
    NSLog(@"ATKitProtocolManagerClassA base");
}

- (void)methodA
{
    NSLog(@"ATKitProtocolManagerClassA methodA");
}

@end

@implementation ATKitProtocolManagerClassB

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"ATKitProtocolManagerClassB init");
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"ATKitProtocolManagerClassB dealloc");
}

- (void)base
{
    NSLog(@"ATKitProtocolManagerClassB base");
}

- (void)methodB
{
    NSLog(@"ATKitProtocolManagerClassB methodB");
}

@end

@implementation ATKitProtocolManagerClassC

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"ATKitProtocolManagerClassC init");
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"ATKitProtocolManagerClassC dealloc");
}

- (void)base
{
    NSLog(@"ATKitProtocolManagerClassC base");
}

- (void)methodC
{
    NSLog(@"ATKitProtocolManagerClassC methodC");
}

@end

@implementation ATKitProtocolManagerClassD

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"ATKitProtocolManagerClassD init");
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"ATKitProtocolManagerClassD dealloc");
}

- (void)base
{
    NSLog(@"ATKitProtocolManagerClassD base");
}

- (void)methodD
{
    NSLog(@"ATKitProtocolManagerClassD methodD");
}

@end

@implementation ATKitProtocolManager

AT_IMPLEMENT_SINGLETON(ATKitProtocolManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initModule];
    }
    return self;
}

- (void)dealloc
{
    [self uninitModule];
}

- (void)initModule
{
    self.protocolManager = [[ATProtocolManager alloc] init];
    
    [self.protocolManager addModule:[[ATKitProtocolManagerClassA alloc] init] protocol:@protocol(ATKitProtocolManagerProtocolA)];
    [self.protocolManager addModule:[[ATKitProtocolManagerClassB alloc] init] protocol:@protocol(ATKitProtocolManagerProtocolB) group:1];
    [self.protocolManager registerClass:[ATKitProtocolManagerClassC class] protocol:@protocol(ATKitProtocolManagerProtocolC)];
    [self.protocolManager registerClass:[ATKitProtocolManagerClassD class] protocol:@protocol(ATKitProtocolManagerProtocolD) group:1];
}

- (void)uninitModule
{
    [self.protocolManager removeProtocol:@protocol(ATKitProtocolManagerProtocolA)];
    [self.protocolManager removeProtocol:@protocol(ATKitProtocolManagerProtocolB)];
    [self.protocolManager removeProtocol:@protocol(ATKitProtocolManagerProtocolC)];
    [self.protocolManager removeProtocol:@protocol(ATKitProtocolManagerProtocolD)];
}

- (void)callModulesInGroup1
{
    NSArray *aArray = [self.protocolManager modulesInGroup:1 createIfNeed:YES];
    [aArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<ATKitProtocolManagerProtocolBase> module = obj;
        [module base];
    }];
}

@end

@implementation ATKitProtocolManagerDemo

- (void)demo
{
    {{
        [ATKITDEMO_GET_MODULE_PROTOCOL(ATKitProtocolManagerProtocolA) methodA];
        [ATKITDEMO_GET_MODULE_PROTOCOL(ATKitProtocolManagerProtocolB) methodB];
        ATKITDEMO_GET_MODULE_PROTOCOL_VARIABLE(ATKitProtocolManagerProtocolC, protocolC);
        [protocolC methodC];
        ATKITDEMO_GET_MODULE_PROTOCOL_VARIABLE(ATKitProtocolManagerProtocolD, protocolD);
        [protocolD methodD];
    }}
    
    [[ATKitProtocolManager sharedObject] callModulesInGroup1];
    
    [[ATKitProtocolManager sharedObject] uninitModule];
    
    [ATKITDEMO_GET_MODULE_PROTOCOL(ATKitProtocolManagerProtocolA) methodA];
    ATKITDEMO_GET_MODULE_PROTOCOL_VARIABLE(ATKitProtocolManagerProtocolC, protocolC);
    [protocolC methodC];
}

@end
