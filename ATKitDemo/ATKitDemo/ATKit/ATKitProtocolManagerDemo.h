//
//  ATKitProtocolManagerDemo.h
//  ATKitDemo
//
//  Created by linzhiman on 2019/4/28.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATProtocolManager.h"
#import "ATGlobalMacro.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ATKitProtocolManagerProtocolBase <NSObject>

- (void)base;

@end

@protocol ATKitProtocolManagerProtocolA <ATKitProtocolManagerProtocolBase>

- (void)methodA;

@end

@protocol ATKitProtocolManagerProtocolB <ATKitProtocolManagerProtocolBase>

- (void)methodB;

@end

@protocol ATKitProtocolManagerProtocolC <ATKitProtocolManagerProtocolBase>

- (void)methodC;

@end

@protocol ATKitProtocolManagerProtocolD <ATKitProtocolManagerProtocolBase>

- (void)methodD;

@end

@interface ATKitProtocolManagerClassA : NSObject<ATKitProtocolManagerProtocolA>

@end

@interface ATKitProtocolManagerClassB : NSObject<ATKitProtocolManagerProtocolB>

@end

@interface ATKitProtocolManagerClassC : NSObject<ATKitProtocolManagerProtocolC>

@end

@interface ATKitProtocolManagerClassD : NSObject<ATKitProtocolManagerProtocolD>

@end

#define ATKITDEMO_GET_MODULE_PROTOCOL(atProtocol) \
    AT_GET_MODULE_PROTOCOL([ATKitProtocolManager sharedObject].protocolManager, atProtocol)
#define ATKITDEMO_GET_MODULE_PROTOCOL_VARIABLE(atProtocol, atVariable) \
    AT_GET_MODULE_PROTOCOL_VARIABLE([ATKitProtocolManager sharedObject].protocolManager, atProtocol, atVariable)

@interface ATKitProtocolManager : NSObject

AT_DECLARE_SINGLETON;

@property (nonatomic, strong) ATProtocolManager *protocolManager;

@end

@interface ATKitProtocolManagerDemo : NSObject

- (void)demo;

@end

NS_ASSUME_NONNULL_END
