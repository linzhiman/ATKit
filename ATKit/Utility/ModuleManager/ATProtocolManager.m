//
//  ATProtocolManager.m
//  ATKit
//
//  Created by linzhiman on 2019/4/26.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ATProtocolManager.h"

static NSMapTable *modulesMap() {
    static NSMapTable *map = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        map = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
    });
    return map;
}

static NSMapTable *moduleClassesMap() {
    static NSMapTable *map = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        map = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
    });
    return map;
}

@implementation ATProtocolManager

- (id)moduleForProtocol:(Protocol *)protocol
{
    return [modulesMap() objectForKey:protocol];
}

- (void)addModule:(id)module withProtocol:(Protocol *)protocol
{
    if ([module conformsToProtocol:protocol]) {
        [modulesMap() setObject:module forKey:protocol];
    }
}

- (void)removeModuleWithProtocol:(Protocol *)protocol
{
    id obj = [modulesMap() objectForKey:protocol];
    if (obj != nil) {
        [modulesMap() removeObjectForKey:protocol];
    }
}

- (Class)classForProtocol:(Protocol *)protocol
{
    return [moduleClassesMap() objectForKey:protocol];
}

- (void)registerClass:(Class)aClass withProtocol:(Protocol *)protocol
{
    if ([aClass conformsToProtocol:protocol]) {
        [moduleClassesMap() setObject:aClass forKey:protocol];
    }
}

- (void)unRegisterClassWithProtocol:(Protocol *)protocol
{
    id obj = [moduleClassesMap() objectForKey:protocol];
    if (obj != nil) {
        [moduleClassesMap() removeObjectForKey:protocol];
    }
}

- (id)moduleForProtocolEx:(Protocol *)protocol
{
    id obj = [self moduleForProtocol:protocol];
    if (obj == nil) {
        Class class = [self classForProtocol:protocol];
        if (class != NULL) {
            obj = [[class alloc] init];
            [self addModule:obj withProtocol:protocol];
        }
    }
    return obj;
}

@end
