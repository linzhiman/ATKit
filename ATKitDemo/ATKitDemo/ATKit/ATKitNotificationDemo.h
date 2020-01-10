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

AT_BN_DECLARE(kName)
AT_BN_DECLARE(kName1, int, a)
AT_BN_DECLARE(kName2, int, a, NSString *, b)
AT_BN_DECLARE(kName3, int, a, NSString *, b, id, c)
AT_BN_DECLARE(kName4, int, a, NSString *, b, id, c, id, d)
AT_BN_DECLARE(kName5, int, a, NSString *, b, id, c, id, d, id, e)
AT_BN_DECLARE(kName6, int, a, NSString *, b, id, c, id, d, id, e, id, f)
AT_BN_DECLARE(kName7, int, a, NSString *, b, id, c, id, d, id, e, id, f, id, g)
AT_BN_DECLARE(kName8, int, a, NSString *, b, id, c, id, d, id, e, id, f, id, g, id, h)

@interface ATKitNotificationTest : NSObject
@property (nonatomic, assign) BOOL test;
@end

//#define UseObj
#ifdef UseObj
#define AT_PROPERTY_DECLARE_HANDLER_ATKitNotificationTest AT_PROPERTY_DECLARE_STRONG ATKitNotificationTest
AT_BN_DECLARE(kName9, ATKitNotificationTest *, test);
#else
AT_BN_DECLARE_NO_OBJ(kName9, ATKitNotificationTest *, test);
#endif

@interface ATKitNotificationDemo : NSObject

- (void)demo;

@end

@interface ATKitNotificationDemo2 : ATKitNotificationDemo

- (void)demo;

@end

NS_ASSUME_NONNULL_END
