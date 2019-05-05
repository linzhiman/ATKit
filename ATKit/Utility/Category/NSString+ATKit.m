//
//  NSString+ATKit.m
//  ATKit
//
//  Created by linzhiman on 2019/4/30.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "NSString+ATKit.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ATKit)

#pragma mark - Length

- (BOOL)at_empty
{
    return self.length == 0;
}

- (BOOL)at_notEmpty
{
    return self.length > 0 ;
}

- (NSUInteger)at_composedLength
{
    NSUInteger composedLength = 0;
    NSRange range = NSMakeRange(0, 0);
    for (NSUInteger i = 0; i < self.length; i += range.length) {
        range = [self rangeOfComposedCharacterSequenceAtIndex:i];
        composedLength++;
    }
    return composedLength;
}

- (NSUInteger)at_lengthFromComposedLength:(NSUInteger)composedLength
{
    NSUInteger charLen = 0;
    NSUInteger len = 0;
    NSRange range = NSMakeRange(0, 0);
    for (; charLen < self.length; charLen += range.length) {
        range = [self rangeOfComposedCharacterSequenceAtIndex:charLen];
        len++;
        if (len == composedLength) {
            charLen += range.length;
            break;
        }
    }
    return charLen;
}

#pragma mark - Truncate

- (NSString *)at_truncateLength:(NSUInteger)length
{
    NSRange stringRange = {0, MIN(self.length, length)};
    stringRange = [self rangeOfComposedCharacterSequencesForRange:stringRange];
    NSString *shortString = [self substringWithRange:stringRange];
    return shortString;
}

- (NSString *)at_truncateEllipsLength:(NSUInteger)length
{
    NSString *string = [self at_truncateLength:length];
    return [string stringByAppendingString:@"..."];
}

- (NSString *)at_appendingString:(NSString * _Nullable)appendString
{
    if (appendString == nil) {
        return self;
    }
    return [self stringByAppendingString:appendString];
}

#pragma mark - Number

- (NSUInteger)at_unsignedIntegerValue
{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    return [formatter numberFromString:self].unsignedIntegerValue;
}

- (BOOL)at_isNumber
{
    if (self.length <= 0) {
        return NO;
    }
    NSString *num = [NSString stringWithFormat:@"^[0-9]\\d{%lu}$", (unsigned long)self.length - 1];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    if ([regextestct evaluateWithObject:self] == YES) {
        return YES;
    }
    return NO;
}

+ (NSString *)at_stringWithThousandBitSeparatorNumber:(NSInteger)num
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:@(num)];
}

+ (NSString *)at_stringRomaNumberForNum:(uint8_t)num
{
    if (num == 0 || num > 10) {
        return @"";
    }
    
    NSArray *array = @[@"I", @"II", @"III", @"IV", @"V", @"VI", @"VII", @"VIII", @"IX", @"X"];
    return array[num - 1];
}

+ (NSString *)at_stringHanNumberForNum:(int32_t)num
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    return [formatter stringFromNumber:[NSNumber numberWithInteger:num]];
}

#pragma mark - Size

- (CGSize)at_sizeWithFont:(UIFont *)font
{
    CGSize inSize = [self sizeWithAttributes:@{ NSFontAttributeName : font }];
    inSize.width = ceil(inSize.width);
    inSize.height = ceil(inSize.height);
    return inSize;
}

- (CGSize)at_sizeWithFont:(UIFont *)font limitWidth:(CGFloat)limitWidth
{
    return [self at_sizeWithFont:font limitWidth:limitWidth lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)at_sizeWithFont:(UIFont *)font limitWidth:(CGFloat)limitWidth lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize rectSize = CGSizeMake(limitWidth, MAXFLOAT);
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
    textStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{ NSFontAttributeName : font,
                                  NSParagraphStyleAttributeName : textStyle };
    CGSize inSize = [self boundingRectWithSize:rectSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil].size;
    inSize.width = ceil(inSize.width);
    inSize.height = ceil(inSize.height);
    return inSize;
}

#pragma mark - Url

- (NSString *)at_urlEncode
{
    NSString *newString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return newString != nil ? newString : @"";
}

- (NSDictionary *)at_getURLParameters
{
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    
    if ([parametersString containsString:@"&"]) {
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                }
                else {
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                [params setValue:value forKey:key];
            }
        }
    }
    else {
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        if (pairComponents.count == 1) {
            return nil;
        }
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        if (key == nil || value == nil) {
            return nil;
        }
        [params setValue:value forKey:key];
    }
    return [params copy];
}

#pragma mark - MD5

- (NSString *)at_MD5
{
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0x00};
    const char *cstr = [self UTF8String];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

+  (NSString *)at_MD5FromData:(NSData *)data
{
    void *cData = malloc([data length]);
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0x00};
    [data getBytes:cData length:[data length]];
    
    CC_MD5(cData, (CC_LONG)[data length], result);
    free(cData);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return [hash lowercaseString];
}

#pragma mark - Filter

- (NSString *)at_trimWhitespaceAndNewline
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)at_trimCompositeString
{
    @autoreleasepool {
        NSString *string = [self stringByTrimmingCharactersInSet:[NSString addExtraFilterCharacterSet]];
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decomposableCharacterSet]];
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet illegalCharacterSet]];
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet capitalizedLetterCharacterSet]];
        return string;
    }
}

+ (NSCharacterSet *)addExtraFilterCharacterSet
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet new];
    [characterSet addCharactersInString:@"\u200F\u202B"];
    return characterSet;
}

- (NSString *)at_filterXMLEscapeChar
{
    NSString *temp = [self stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    [temp stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    [temp stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    [temp stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    [temp stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return temp;
}

#pragma mark - Chinese

+ (BOOL)at_hasChinese:(NSString *)string
{
    for (int i = 0; i < string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (ch > 0x4e00 && ch < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

@end
