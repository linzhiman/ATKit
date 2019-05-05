//
//  NSObject+ATKit.m
//  ATKit
//
//  Created by linzhiman on 2019/5/5.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "NSObject+ATKit.h"
#import <objc/runtime.h>
#import "ATGlobalMacro.h"
#import "ATWeakObject.h"

AT_STRING_DEFINE(kATObjectAssociatedPropertys);

@interface ATWeakPerformSelectorObject : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) id object;

@end

@implementation ATWeakPerformSelectorObject

- (void)action
{
    if (self.target != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self.object];
#pragma clang diagnostic pop
    }
}

@end

@implementation NSObject (ATKit)

- (void)bs_performSelector:(SEL)selector withObject:(id)object afterDelay:(NSTimeInterval)delay
{
    ATWeakPerformSelectorObject *selectorObject = [[ATWeakPerformSelectorObject alloc] init];
    selectorObject.target = self;
    selectorObject.selector = selector;
    selectorObject.object = object;
    [selectorObject performSelector:@selector(action) withObject:nil afterDelay:delay];
    
    objc_setAssociatedObject(self, selector, selectorObject, OBJC_ASSOCIATION_RETAIN);
}

+ (void)bs_cancelPreviousPerformRequestsWithTarget:(id)target selector:(SEL)selector
{
    ATWeakPerformSelectorObject *selectorObject = objc_getAssociatedObject(target, selector);
    if (selectorObject && selectorObject.target == target) {
        [NSObject cancelPreviousPerformRequestsWithTarget:selectorObject selector:@selector(action) object:nil];
    }
}

- (NSMutableDictionary *)propertys
{
    id props = [self bs_associatedObject:kATObjectAssociatedPropertys];
    if (props == nil) {
        props = [[NSMutableDictionary alloc] init];
        [self bs_setAssociatedObject:props key:kATObjectAssociatedPropertys];
    }
    return props;
}

- (id)bs_getProperty:(NSString *)name
{
    return [[self propertys] objectForKey:name];
}

- (void)bs_setProperty:(id)property withName:(NSString *)name
{
    @synchronized (self) {
        [[self propertys] setObject:property forKey:name];
    }
}

- (void)bs_removeProperty:(NSString *)name
{
    id props = [self bs_associatedObject:kATObjectAssociatedPropertys];
    if (props != nil) {
        NSMutableDictionary *propDic = props;
        [propDic removeObjectForKey:name];
        if (propDic.count == 0) {
            [self bs_removeAssociatedObject:kATObjectAssociatedPropertys];
        }
    }
}

- (id)bs_associatedObject:(NSString *)key
{
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

- (void)bs_setAssociatedObject:(id)object key:(NSString *)key
{
    objc_setAssociatedObject(self, (__bridge const void *)(key), object, OBJC_ASSOCIATION_RETAIN);
}

- (void)bs_removeAssociatedObject:(NSString *)key
{
    objc_setAssociatedObject(self, (__bridge const void *)(key), nil, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)bs_delegates
{
    NSMutableArray *delegates = objc_getAssociatedObject(self, _cmd);
    if (delegates == nil) {
        delegates = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, delegates, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegates;
}

- (void)bs_addDelegate:(id)delegate
{
    ATWeakObject *weakObject = [[ATWeakObject alloc] init];
    weakObject.target = delegate;
    [[self bs_delegates] addObject:weakObject];
}

- (void)bs_removeDelegate:(id)delegate
{
    ATWeakObject *weakObject = [ATWeakObject new];
    weakObject.target = delegate;
    [[self bs_delegates] removeObject:weakObject];
}

- (void)bs_checkSelector:(SEL)selector callback:(void (^)(id delegate))callback
{
    for (ATWeakObject *weakObject in [self bs_delegates]) {
        if ([weakObject.target respondsToSelector:selector]) {
            callback(weakObject.target);
        }
    }
}

@end
