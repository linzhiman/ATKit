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
#import "ATBaseModule.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ATKitProtocolManagerProtocolA <NSObject>

- (void)methodA;

@end

@protocol ATKitProtocolManagerProtocolB <NSObject>

- (void)methodB;

@end

@protocol ATKitProtocolManagerProtocolC <NSObject>

- (void)methodC;

@end

@protocol ATKitProtocolManagerProtocolD <NSObject>

- (void)methodD;

@end

@interface ATKitProtocolManagerClassA : ATBaseModule<ATKitProtocolManagerProtocolA>

@end

@interface ATKitProtocolManagerClassB : ATBaseModule<ATKitProtocolManagerProtocolB>

@end

@interface ATKitProtocolManagerClassC : ATBaseModule<ATKitProtocolManagerProtocolC>

@end

@interface ATKitProtocolManagerClassD : ATBaseModule<ATKitProtocolManagerProtocolD>

@end

#define ATKITDEMO_GET_MODULE_PROTOCOL(atProtocol) \
    AT_GET_MODULE_PROTOCOL([ATKitProtocolManager sharedObject].protocolManager, atProtocol)
#define ATKITDEMO_GET_MODULE_PROTOCOL_VARIABLE(atProtocol, atVariable) \
    AT_GET_MODULE_PROTOCOL_VARIABLE([ATKitProtocolManager sharedObject].protocolManager, atProtocol, atVariable)

@interface ATKitProtocolManager : NSObject

AT_DECLARE_SINGLETON;

@property (nonatomic, strong) id<ATProtocolManagerProtocol> protocolManager;

@end

@interface ATKitProtocolManagerDemo : NSObject

- (void)demo;

@end

NS_ASSUME_NONNULL_END
