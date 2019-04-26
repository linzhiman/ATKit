//
//  ATProtocolManagerProtocol.h
//  ATKit
//
//  Created by linzhiman on 2019/4/26.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AT_GET_MODULE_PROTOCOL(atManager, atProtocol) \
    ((id<atProtocol>)[atManager moduleWithProtocol:@protocol(atProtocol)])

#define AT_GET_MODULE_PROTOCOL_VARIABLE(atManager, atProtocol, atVariable) \
    id<atProtocol> atVariable = (id<atProtocol>)[atManager moduleWithProtocol:@protocol(atProtocol)];

NS_ASSUME_NONNULL_BEGIN

@protocol ATProtocolManagerProtocol <NSObject>

- (id)moduleWithProtocol:(Protocol *)protocol;

- (void)addModule:(id)module withProtocol:(Protocol *)protocol;

- (void)removeModuleWithProtocol:(Protocol *)protocol;

- (Class)classWithProtocol:(Protocol *)procotol;

- (void)registerClass:(Class)aClass withProtocol:(Protocol *)protocol;

- (void)unRegisterClassWithProtocol:(Protocol *)protocol;

@end

NS_ASSUME_NONNULL_END
