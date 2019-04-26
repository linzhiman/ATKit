//
//  ATModuleManager.m
//  ATModuleManager
//
//  Created by linzhiman on 2018/5/3.
//  Copyright © 2018年 linzhiman. All rights reserved.
//

#import "ATModuleManager.h"

const NSInteger kATModuleDefaultGroup = 0;

@interface ATModuleManager()

@property (nonatomic, strong) NSMutableDictionary *modules;// <identifier, id<ATModuleProtocol>>
@property (nonatomic, strong) NSMutableDictionary *groups;// <group, NSMutableArray<id<ATModuleProtocol>>>

@end

@implementation ATModuleManager

- (id<ATModuleProtocol>)moduleWithIdentifier:(NSString *)identifier
{
    if (!_modules) {
        return nil;
    }
    else {
        return [_modules objectForKey:identifier];
    }
}

- (void)addModule:(id<ATModuleProtocol>)module identifier:(NSString *)identifier
{
    [self addModule:module identifier:identifier group:kATModuleDefaultGroup];
}

- (void)addModule:(id<ATModuleProtocol>)module identifier:(NSString *)identifier group:(NSInteger)group
{
    if (!_modules) {
        _modules = [[NSMutableDictionary alloc] init];
    }
    [_modules setObject:module forKey:identifier];
    
    if (!_groups) {
        _groups = [[NSMutableDictionary alloc] init];
    }
    NSMutableArray *aArray = [_groups objectForKey:@(group)];
    if (!aArray) {
        aArray = [[NSMutableArray alloc] init];
        [_groups setObject:aArray forKey:@(group)];
    }
    [aArray addObject:module];
}

- (void)removeModuleWithIdentifier:(NSString *)identifier
{
    [self removeModuleWithIdentifier:identifier group:kATModuleDefaultGroup];
}

- (void)removeModuleWithIdentifier:(NSString *)identifier group:(NSInteger)group
{
    id<ATModuleProtocol> obj = [self moduleWithIdentifier:identifier];
    
    [_modules removeObjectForKey:identifier];
    
    NSMutableArray *aArray = [_groups objectForKey:@(group)];
    [aArray removeObject:obj];
}

- (void)initModuleWithGroup:(NSInteger)group
{
    NSMutableArray *aArray = [_groups objectForKey:@(group)];
    if (aArray) {
        [aArray makeObjectsPerformSelector:@selector(initModule)];
    }
}

- (void)uninitModuleWithGroup:(NSInteger)group
{
    NSMutableArray *aArray = [_groups objectForKey:@(group)];
    if (aArray) {
        [aArray makeObjectsPerformSelector:@selector(uninitModule)];
    }
}

@end
