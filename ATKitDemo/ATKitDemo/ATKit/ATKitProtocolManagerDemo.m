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
    
    [self.protocolManager addModule:[[ATKitProtocolManagerClassA alloc] init] withProtocol:@protocol(ATKitProtocolManagerProtocolA)];
    [self.protocolManager addModule:[[ATKitProtocolManagerClassB alloc] init] withProtocol:@protocol(ATKitProtocolManagerProtocolB) group:1];
    [self.protocolManager registerClass:[ATKitProtocolManagerClassC class] withProtocol:@protocol(ATKitProtocolManagerProtocolC)];
    [self.protocolManager registerClass:[ATKitProtocolManagerClassD class] withProtocol:@protocol(ATKitProtocolManagerProtocolD) group:1];
}

- (void)uninitModule
{
    [self.protocolManager removeModuleWithProtocol:@protocol(ATKitProtocolManagerProtocolA)];
    [self.protocolManager removeModuleWithProtocol:@protocol(ATKitProtocolManagerProtocolB)];
    [self.protocolManager removeModuleWithProtocol:@protocol(ATKitProtocolManagerProtocolC)];
    [self.protocolManager removeModuleWithProtocol:@protocol(ATKitProtocolManagerProtocolD)];
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
    
    [[ATKitProtocolManager sharedObject] uninitModule];
    
    [ATKITDEMO_GET_MODULE_PROTOCOL(ATKitProtocolManagerProtocolA) methodA];
    ATKITDEMO_GET_MODULE_PROTOCOL_VARIABLE(ATKitProtocolManagerProtocolC, protocolC);
    [protocolC methodC];
}

@end
