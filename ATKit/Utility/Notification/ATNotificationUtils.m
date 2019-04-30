//
//  ATNotificationUtils.m
//  ATKit
//
//  Created by linzhiman on 2019/4/24.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ATNotificationUtils.h"
#import "ATWeakObject.h"

@interface ATNotificationUtils()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *observers;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableSet *> *notifications;

@end

@implementation ATNotificationUtils

AT_IMPLEMENT_SINGLETON(ATNotificationUtils);

- (instancetype)init
{
    self = [super init];
    if (self) {
        _observers = [NSMutableDictionary<NSString *, NSMutableArray *> new];
        _notifications = [NSMutableDictionary<NSString *, NSMutableSet *> new];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (void)addObserver:(id)observer name:(NSString *)name callback:(ATNotificationUtilsCallback)callback
{
    @synchronized(self)
    {
        NSMutableArray *observers = [self.observers objectForKey:name];
        if (observers == nil) {
            observers = [NSMutableArray new];
            [self.observers setObject:observers forKey:name];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:name object:nil];
        }
        
        ATWeakObject *aWrapObj = [[ATWeakObject alloc] init];
        aWrapObj.target = observer;
        aWrapObj.extension = [callback copy];
#ifdef DEBUG
        {{
            NSAssert(![observers containsObject:aWrapObj], @"addObserver %@ twice", name);
        }}
#endif
        [observers addObject:aWrapObj];
        
        NSMutableSet *notifications = [self.notifications objectForKey:aWrapObj.objectKey];
        if (notifications == nil) {
            notifications = [NSMutableSet new];
            [self.notifications setObject:notifications forKey:aWrapObj.objectKey];
        }
        [notifications addObject:name];
    }
}

- (void)removeObserver:(id)observer name:(NSString *)name
{
    @synchronized(self)
    {
        NSMutableArray *observers = [self.observers objectForKey:name];
        if (observers != nil) {
            for (NSUInteger i = 0; i < observers.count; ++i) {
                ATWeakObject *aWrapObj = observers[i];
                if (aWrapObj.target == observer || [aWrapObj.objectKey isEqualToString:[ATWeakObject objectKey:observer]]) {
                    [observers removeObjectAtIndex:i];
                    break;
                }
            }
            if (observers.count == 0) {
                [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:nil];
            }
        }
        
        NSString *objectKey = [ATWeakObject objectKey:observer];
        NSMutableSet *notifications = [self.notifications objectForKey:objectKey];
        if (notifications != nil) {
            [notifications removeObject:name];
            if (notifications.count == 0) {
                [self.notifications removeObjectForKey:objectKey];
            }
        }
    }
}

- (void)removeObserver:(id)observer
{
    @synchronized(self)
    {
        NSString *objectKey = [ATWeakObject objectKey:observer];
        NSMutableSet *notifications = [self.notifications objectForKey:objectKey];
        [notifications enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *name = obj;
            [self removeObserver:observer name:name];
        }];
    }
}

#pragma mark - Private

- (void)onNotification:(NSNotification *)notification
{
    NSMutableArray *callbacks = [NSMutableArray new];
    
    @synchronized(self)
    {
        NSMutableArray *observers = [self.observers objectForKey:notification.name];
        if (observers != nil) {
            NSMutableArray *invalidatedObservers = [NSMutableArray new];
            
            for (ATWeakObject *aWrapObj in observers) {
                if (aWrapObj.target != nil) {
                    [callbacks addObject:aWrapObj.extension];
                }
                else {
                    [invalidatedObservers addObject:aWrapObj];
                }
            }
            
            for (ATWeakObject *aWrapObj in invalidatedObservers) {
                NSString *objectKey = aWrapObj.objectKey;
                NSMutableSet *notifications = [self.notifications objectForKey:objectKey];
                [notifications enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSString *name = obj;
                    NSMutableArray *array = [self.observers objectForKey:name];
                    if (array != nil) {
                        [array removeObject:aWrapObj];
                    }
                }];
                [self.notifications removeObjectForKey:objectKey];
            }
        }
    }
    
    for (ATNotificationUtilsCallback callback in callbacks) {
        AT_SAFETY_CALL_BLOCK(callback, notification.userInfo);
    }
}

+ (void)postNotificationName:(NSString *)name object:(id)object
{
    if ([NSThread isMainThread]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
        });
    }
}

+ (void)postNotificationName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo
{
    if ([NSThread isMainThread]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
        });
    }
}

@end
