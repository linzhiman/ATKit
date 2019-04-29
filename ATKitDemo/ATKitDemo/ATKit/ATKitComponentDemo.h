//
//  ATKitComponentDemo.h
//  ATKitDemo
//
//  Created by linzhiman on 2019/4/29.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATComponentService.h"

NS_ASSUME_NONNULL_BEGIN

/**
 ATComponentService(ComponentA)均由组件提供者实现，调用者使用即可。
 */

@interface ATKitComponentA : NSObject

AT_COMPONENT_ACTION(version);

@end

@interface ATComponentService(ComponentA)

+ (NSString *)a_versionWithPrefix:(NSString *)prefix callback:(void(^)(NSString *version))callback;

@end

@interface ATKitComponentDemo : NSObject

- (void)demo;

@end

NS_ASSUME_NONNULL_END
