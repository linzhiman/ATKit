//
//  ATNotificationUtils.h
//  demo
//
//  Created by linzhiman on 2019/4/24.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATGlobalMacro.h"

#define ATNOTIFICATION_SIGNALTON [ATNotificationUtils sharedObject]

NS_ASSUME_NONNULL_BEGIN

typedef void (^ATNotificationUtilsCallback)(NSDictionary * _Nullable userInfo);

@interface ATNotificationUtils : NSObject

AT_DECLARE_SINGLETON;

- (void)addObserver:(id)observer name:(NSString *)name callback:(ATNotificationUtilsCallback)callback;

- (void)removeObserver:(id)observer name:(NSString *)name;
- (void)removeObserver:(id)observer;

@end

NS_ASSUME_NONNULL_END
