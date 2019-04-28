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

@interface ATProtocolManager()

@property (nonatomic, strong) NSMutableDictionary *groups;// <group, NSMutableArray<ATProtocolManagerMeta *>>

@end

@implementation ATProtocolManager

- (id)moduleForProtocol:(Protocol *)protocol
{
    return [modulesMap() objectForKey:protocol];
}

- (void)addModule:(id)module protocol:(Protocol *)protocol
{
    [self addModule:module protocol:protocol group:kATProtocolManagerDefaultGroup];
}

- (void)addModule:(id)module protocol:(Protocol *)protocol group:(NSInteger)group
{
    if ([module conformsToProtocol:protocol]) {
        [modulesMap() setObject:module forKey:protocol];
        
        ATProtocolManagerMeta *meta = [[ATProtocolManagerMeta alloc] init];
        meta.protocol = protocol;
        meta.module = module;
        [self addMeta:meta group:group];
    }
}

- (void)removeModule:(Protocol *)protocol
{
    id obj = [modulesMap() objectForKey:protocol];
    if (obj != nil) {
        [modulesMap() removeObjectForKey:protocol];
        
        ATProtocolManagerMeta *meta = [[ATProtocolManagerMeta alloc] init];
        meta.protocol = protocol;
        meta.module = obj;
        [self removeMeta:meta];
    }
}

- (Class)classForProtocol:(Protocol *)protocol
{
    return [moduleClassesMap() objectForKey:protocol];
}

- (void)registerClass:(Class)aClass protocol:(Protocol *)protocol
{
    [self registerClass:aClass protocol:protocol group:kATProtocolManagerDefaultGroup];
}

- (void)registerClass:(Class)aClass protocol:(Protocol *)protocol group:(NSInteger)group
{
    if ([aClass conformsToProtocol:protocol]) {
        [moduleClassesMap() setObject:aClass forKey:protocol];
        
        ATProtocolManagerMeta *meta = [[ATProtocolManagerMeta alloc] init];
        meta.protocol = protocol;
        meta.aClass = aClass;
        [self addMeta:meta group:group];
    }
}

- (void)unRegisterClass:(Protocol *)protocol
{
    id obj = [moduleClassesMap() objectForKey:protocol];
    if (obj != nil) {
        [moduleClassesMap() removeObjectForKey:protocol];
        
        ATProtocolManagerMeta *meta = [[ATProtocolManagerMeta alloc] init];
        meta.protocol = protocol;
        meta.aClass = obj;
        [self removeMeta:meta];
    }
}

- (id)module:(Protocol *)protocol
{
    id obj = [self moduleForProtocol:protocol];
    if (obj == nil) {
        Class class = [self classForProtocol:protocol];
        if (class != NULL) {
            obj = [[class alloc] init];
            [self addModule:obj protocol:protocol group:[self groupForProtocol:protocol]];
        }
    }
    return obj;
}

- (void)removeProtocol:(Protocol *)protocol
{
    [self removeModule:protocol];
    [self unRegisterClass:protocol];
}

- (NSArray *)modulesInGroup:(NSInteger)group createIfNeed:(BOOL)createIfNeed
{
    NSMutableArray *value = [[NSMutableArray alloc] init];
    NSArray *aArray = [[self.groups objectForKey:@(group)] copy];
    for (ATProtocolManagerMeta *curMeta in aArray) {
        if (createIfNeed) {
            [value addObject:[self module:curMeta.protocol]];
        }
        else {
            id obj = [self moduleForProtocol:curMeta.protocol];
            if (obj != nil) {
                [value addObject:obj];
            }
        }
    }
    return [value copy];
}

- (void)addMeta:(ATProtocolManagerMeta *)meta group:(NSInteger)group
{
    if (self.groups == nil) {
        self.groups = [[NSMutableDictionary alloc] init];
    }
    NSMutableArray *aArray = [self.groups objectForKey:@(group)];
    if (aArray == nil) {
        aArray = [[NSMutableArray alloc] init];
        [self.groups setObject:aArray forKey:@(group)];
    }
    for (ATProtocolManagerMeta *curMeta in aArray) {
        if (curMeta.protocol == meta.protocol) {
            if (meta.aClass != NULL) {
                curMeta.aClass = meta.aClass;
            }
            if (meta.module != nil) {
                curMeta.module = meta.module;
            }
            return;
        }
    }
    [aArray addObject:meta];
}

- (void)removeMeta:(ATProtocolManagerMeta *)meta
{
    for (NSMutableArray *aArray in self.groups.allValues) {
        for (ATProtocolManagerMeta *curMeta in aArray) {
            if (curMeta.protocol == meta.protocol) {
                if (meta.aClass != NULL) {
                    curMeta.aClass = NULL;
                }
                if (meta.module != nil) {
                    curMeta.module = nil;
                }
                if (curMeta.aClass == NULL && curMeta.module == nil) {
                    [aArray removeObject:curMeta];
                    return;
                }
            }
        }
    }
}

- (NSInteger)groupForProtocol:(Protocol *)protocol
{
    for (NSUInteger i = 0; i < self.groups.allValues.count; ++i) {
        NSMutableArray *aArray = self.groups.allValues[i];
        for (ATProtocolManagerMeta *curMeta in aArray) {
            if (curMeta.protocol == protocol) {
                return i;
            }
        }
    }
    return -1;
}

@end
