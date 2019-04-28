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
    [self.protocolManager registerClass:[ATKitProtocolManagerClassB class] withProtocol:@protocol(ATKitProtocolManagerProtocolB)];
}

- (void)uninitModule
{
    [self.protocolManager removeModuleWithProtocol:@protocol(ATKitProtocolManagerProtocolA)];
    [self.protocolManager removeModuleWithProtocol:@protocol(ATKitProtocolManagerProtocolB)];
}

@end

@implementation ATKitProtocolManagerDemo

- (void)demo
{
    {{
        [ATKITDEMO_GET_MODULE_PROTOCOL(ATKitProtocolManagerProtocolA) methodA];
        ATKITDEMO_GET_MODULE_PROTOCOL_VARIABLE(ATKitProtocolManagerProtocolB, protocolB);
        [protocolB methodB];
    }}
    
    [[ATKitProtocolManager sharedObject] uninitModule];
    
    [ATKITDEMO_GET_MODULE_PROTOCOL(ATKitProtocolManagerProtocolA) methodA];
    ATKITDEMO_GET_MODULE_PROTOCOL_VARIABLE(ATKitProtocolManagerProtocolB, protocolBB);
    [protocolBB methodB];
}

@end
