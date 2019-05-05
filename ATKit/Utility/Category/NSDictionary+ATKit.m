//
//  NSDictionary+ATKit.m
//  ATKit
//
//  Created by linzhiman on 2019/5/5.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "NSDictionary+ATKit.h"

id ATDictionarySafeGet(NSDictionary *dic, Class cls, id key)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id val = [dic objectForKey:key];
    if ([val isKindOfClass:cls]) {
        return val;
    }
    return nil;
}

@implementation NSDictionary (ATKit)

- (NSString *)at_getString:(id)key
{
    return ATDictionarySafeGet(self, [NSString class], key);
}

- (NSAttributedString *)at_getAttributedString:(id)key
{
    return ATDictionarySafeGet(self, [NSAttributedString class], key);
}

- (NSNumber *)at_getNumber:(id)key
{
    return ATDictionarySafeGet(self, [NSNumber class], key);
}

- (NSArray *)at_getArray:(id)key
{
    return ATDictionarySafeGet(self, [NSArray class], key);
}

- (NSDictionary *)at_getDictionary:(id)key
{
    return ATDictionarySafeGet(self, [NSDictionary class], key);
}

@end
