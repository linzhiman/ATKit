//
//  NSObject+ATKit.h
//  ATKit
//
//  Created by linzhiman on 2019/5/5.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ATKit)

- (void)bs_performSelector:(SEL)selector withObject:(id)object afterDelay:(NSTimeInterval)delay;
+ (void)bs_cancelPreviousPerformRequestsWithTarget:(id)target selector:(SEL)selector;

- (id)bs_getProperty:(NSString *)name;
- (void)bs_setProperty:(id)property withName:(NSString *)name;
- (void)bs_removeProperty:(NSString *)name;

- (id)bs_associatedObject:(NSString *)key;
- (void)bs_setAssociatedObject:(id)object key:(NSString *)key;
- (void)bs_removeAssociatedObject:(NSString *)key;

- (void)bs_addDelegate:(id)delegate;
- (void)bs_removeDelegate:(id)delegate;
- (void)bs_checkSelector:(SEL)selector callback:(void (^)(id delegate))callback;

@end

NS_ASSUME_NONNULL_END
