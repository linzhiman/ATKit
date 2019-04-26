//
//  ATModuleManager.h
//  ATModuleManager
//
//  Created by linzhiman on 2018/5/3.
//  Copyright © 2018年 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATModuleProtocol.h"

#define AT_ADD_MODULE_GROUP(atModuleManager, atModuleClass, atGroup) \
    [atModuleManager addModule:[[atModuleClass alloc] init] identifier:@#atModuleClass group:atGroup];

#define AT_ADD_MODULE(atModuleManager, atModuleClass) \
    AT_ADD_MODULE_GROUP(atModuleManager, atModuleClass, kATModuleDefaultGroup);

#define AT_GET_MODULE(atModuleManager, atModuleClass) \
    ((atModuleClass *)[atModuleManager moduleWithIdentifier:@#atModuleClass])

#define AT_GET_MODULE_VARIABLE(atModuleManager, atModuleClass) \
    atModuleClass *aModule = (atModuleClass *)[atModuleManager moduleWithIdentifier:@#atModuleClass];

extern const NSInteger kATModuleDefaultGroup;

@interface ATModuleManager : NSObject

- (id<ATModuleProtocol>)moduleWithIdentifier:(NSString *)identifier;

- (void)addModule:(id<ATModuleProtocol>)module identifier:(NSString *)identifier;
- (void)addModule:(id<ATModuleProtocol>)module identifier:(NSString *)identifier group:(NSInteger)group;

- (void)removeModuleWithIdentifier:(NSString *)identifier;
- (void)removeModuleWithIdentifier:(NSString *)identifier group:(NSInteger)group;

- (void)initModuleWithGroup:(NSInteger)group;
- (void)uninitModuleWithGroup:(NSInteger)group;

@end
