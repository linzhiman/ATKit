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

@interface ATKitComponentA : NSObject

AT_COMPONENT_ACTION(version);

@end

@interface ATKitComponentDemo : NSObject

- (void)demo;

@end

NS_ASSUME_NONNULL_END
