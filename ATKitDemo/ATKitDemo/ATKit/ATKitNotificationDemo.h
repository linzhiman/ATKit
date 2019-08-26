//
//  ATKitNotificationDemo.h
//  ATKitDemo
//
//  Created by linzhiman on 2019/4/26.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATBlockNotificationCenter.h"

NS_ASSUME_NONNULL_BEGIN

AT_BN_DECLARE(kName, int, a, NSString *, b)
AT_BN_DECLARE(kName2, int, a, NSString *, b, id, c)

@interface ATKitNotificationDemo : NSObject

- (void)initNotification;

- (void)removeNotification;

- (void)demo;

@end

NS_ASSUME_NONNULL_END
