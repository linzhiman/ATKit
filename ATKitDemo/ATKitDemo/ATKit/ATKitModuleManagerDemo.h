//
//  ATKitModuleManagerDemo.h
//  ATKitDemo
//
//  Created by linzhiman on 2019/4/28.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATModuleManager.h"
#import "ATGlobalMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATKitModuleManagerClassA : NSObject<ATModuleProtocol>

- (void)methodA;

@end

@interface ATKitModuleManagerClassB : NSObject<ATModuleProtocol>

- (void)methodB;

@end

#define ATKITDEMO_GET_MODULE(atModuleClass) \
    AT_GET_MODULE([ATKitModuleManager sharedObject].moduleManager, atModuleClass)
#define ATKITDEMO_GET_MODULE_VARIABLE(atModuleClass, atVariable) \
    AT_GET_MODULE_VARIABLE([ATKitModuleManager sharedObject].moduleManager, atModuleClass, atVariable)

@interface ATKitModuleManager : NSObject

AT_DECLARE_SINGLETON;

@property (nonatomic, strong) ATModuleManager *moduleManager;

@end

@interface ATKitModuleManagerDemo : NSObject

- (void)demo;

@end

NS_ASSUME_NONNULL_END
