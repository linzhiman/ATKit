//
//  ATKitModuleManagerDemo.m
//  ATKitDemo
//
//  Created by linzhiman on 2019/4/28.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ATKitModuleManagerDemo.h"

@implementation ATKitModuleManagerClassA

- (void)initModule
{
    NSLog(@"ATKitModuleManagerClassA initModule");
}

- (void)uninitModule
{
    NSLog(@"ATKitModuleManagerClassA uninitModule");
}

- (void)methodA
{
    NSLog(@"ATKitModuleManagerClassA methodA");
}

@end

@implementation ATKitModuleManagerClassB

- (void)initModule
{
    NSLog(@"ATKitModuleManagerClassB initModule");
}

- (void)uninitModule
{
    NSLog(@"ATKitModuleManagerClassB uninitModule");
}

- (void)methodB
{
    NSLog(@"ATKitModuleManagerClassB methodB");
}

@end

@implementation ATKitModuleManager

AT_IMPLEMENT_SINGLETON(ATKitModuleManager)

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
    self.moduleManager = [[ATModuleManager alloc] init];
    
    AT_ADD_MODULE(self.moduleManager, ATKitModuleManagerClassA);
    AT_ADD_MODULE_GROUP(self.moduleManager, ATKitModuleManagerClassB , kATModuleGroup1);
    
    {{
        NSArray *modules = [self.moduleManager modulesInGroup:kATModuleDefaultGroup];
        for (id<ATKitModuleProtocol> tmp in modules) {
            if ([tmp respondsToSelector:@selector(initModule)]) {
                [tmp initModule];
            }
        }
    }}
    
    {{
        NSArray *modules = [self.moduleManager modulesInGroup:kATModuleGroup1];
        for (id<ATKitModuleProtocol> tmp in modules) {
            if ([tmp respondsToSelector:@selector(initModule)]) {
                [tmp initModule];
            }
        }
    }}
}

- (void)uninitModule
{
    AT_REMOVE_MODULE(self.moduleManager, ATKitModuleManagerClassA);
    AT_REMOVE_MODULE_GROUP(self.moduleManager, ATKitModuleManagerClassB , kATModuleGroup1);
    
    {{
        NSArray *modules = [self.moduleManager modulesInGroup:kATModuleDefaultGroup];
        for (id<ATKitModuleProtocol> tmp in modules) {
            if ([tmp respondsToSelector:@selector(initModule)]) {
                [tmp uninitModule];
            }
        }
    }}
    
    {{
        NSArray *modules = [self.moduleManager modulesInGroup:kATModuleGroup1];
        for (id<ATKitModuleProtocol> tmp in modules) {
            if ([tmp respondsToSelector:@selector(initModule)]) {
                [tmp uninitModule];
            }
        }
    }}
}

@end

@implementation ATKitModuleManagerDemo

- (void)demo
{
    [ATKITDEMO_GET_MODULE(ATKitModuleManagerClassA) methodA];
    ATKITDEMO_GET_MODULE_VARIABLE(ATKitModuleManagerClassB, moduleB);
    [moduleB methodB];
}

@end
