//
//  ATProtocolManagerProtocol.h
//  ATKit
//
//  Created by linzhiman on 2019/4/26.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AT_GET_MODULE_PROTOCOL(atManager, atProtocol) \
    ((id<atProtocol>)[atManager module:@protocol(atProtocol)])

#define AT_GET_MODULE_PROTOCOL_VARIABLE(atManager, atProtocol, atVariable) \
    id<atProtocol> atVariable = (id<atProtocol>)[atManager module:@protocol(atProtocol)];

NS_ASSUME_NONNULL_BEGIN

extern const NSInteger kATProtocolManagerDefaultGroup;

@interface ATProtocolManagerMeta : NSObject

@property (nonatomic, strong) Protocol *protocol;
@property (nonatomic, strong, nullable) Class aClass;
@property (nonatomic, strong, nullable) id module;

@end

@protocol ATProtocolManagerProtocol <NSObject>

- (id)moduleForProtocol:(Protocol *)protocol;

- (void)addModule:(id)module protocol:(Protocol *)protocol;
- (void)addModule:(id)module protocol:(Protocol *)protocol group:(NSInteger)group;

- (void)removeModule:(Protocol *)protocol;

- (Class)classForProtocol:(Protocol *)procotol;

- (void)registerClass:(Class)aClass protocol:(Protocol *)protocol;
- (void)registerClass:(Class)aClass protocol:(Protocol *)protocol group:(NSInteger)group;

- (void)unRegisterClass:(Protocol *)protocol;

/**
 先查module表，再查class表，有则创建对象并addModule添加到module表
 */
- (id)module:(Protocol *)protocol;

/**
 移除module及class
 */
- (void)removeProtocol:(Protocol *)protocol;

- (NSArray *)modulesInGroup:(NSInteger)group createIfNeed:(BOOL)createIfNeed;

@end

NS_ASSUME_NONNULL_END
