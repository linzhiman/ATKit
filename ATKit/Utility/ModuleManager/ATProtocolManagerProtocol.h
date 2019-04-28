//
//  ATProtocolManagerProtocol.h
//  ATKit
//
//  Created by linzhiman on 2019/4/26.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AT_GET_MODULE_PROTOCOL(atManager, atProtocol) \
    ((id<atProtocol>)[atManager moduleForProtocolEx:@protocol(atProtocol)])

#define AT_GET_MODULE_PROTOCOL_VARIABLE(atManager, atProtocol, atVariable) \
    id<atProtocol> atVariable = (id<atProtocol>)[atManager moduleForProtocolEx:@protocol(atProtocol)];

NS_ASSUME_NONNULL_BEGIN

@protocol ATProtocolManagerProtocol <NSObject>

- (id)moduleForProtocol:(Protocol *)protocol;

- (void)addModule:(id)module withProtocol:(Protocol *)protocol;

- (void)removeModuleWithProtocol:(Protocol *)protocol;

- (Class)classForProtocol:(Protocol *)procotol;

- (void)registerClass:(Class)aClass withProtocol:(Protocol *)protocol;

- (void)unRegisterClassWithProtocol:(Protocol *)protocol;

/**
 先查module表，再查class表，有则创建对象并addModule添加到module表
 */
- (id)moduleForProtocolEx:(Protocol *)protocol;

@end

NS_ASSUME_NONNULL_END
