//
//  NSString+YQCategory.m
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonCryptor.h>

#import "NSString+YQCategory.h"

@implementation NSString (YQCategory)

// md5加密
- (NSString *)yq_md5Encrypt{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

// DES加密
- (NSString *)yq_DESEncryptForKey:(NSString *)key{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    const void *iv = (const void *) [key UTF8String];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        plainText = [dataTemp base64EncodedStringWithOptions:0];
    } else {
        NSLog(@"DES加密失败");
    }
    return plainText;
}

// DES解密
- (NSString *)yq_DESDecryptForKey:(NSString *)key{
    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    const void *iv = (const void *) [key UTF8String];
    // IV 偏移量不需使用
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

// base64
- (NSData *)yq_base64Data{
    if (![self length]) return nil;
    NSData *decoded = nil;
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        decoded = [[NSData alloc] initWithBase64Encoding:[self stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [self length])]];
#pragma clang diagnostic pop
    }
    else
#endif
    {
        decoded = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    return [decoded length]? decoded: nil;
}
+ (NSString *)yq_stringWithBase64Data:(NSData *)data{
    NSInteger wrapWidth = 0;
    
    if (![data length]) return nil;
    NSString *encoded = nil;
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        encoded = [data base64Encoding];
#pragma clang diagnostic pop
        
    }
    else
#endif
    {
        switch (wrapWidth)
        {
            case 64:
            {
                return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            case 76:
            {
                return [data base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            }
            default:
            {
                encoded = [data base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
            }
        }
    }
    if (!wrapWidth || wrapWidth >= [encoded length])
    {
        return encoded;
    }
    wrapWidth = (wrapWidth / 4) * 4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [encoded length]; i+= wrapWidth)
    {
        if (i + wrapWidth >= [encoded length])
        {
            [result appendString:[encoded substringFromIndex:i]];
            break;
        }
        [result appendString:[encoded substringWithRange:NSMakeRange(i, wrapWidth)]];
        [result appendString:@"\r\n"];
    }
    return result;
}

+ (NSString *)yq_stringWithInt:(int)intValue
{
    return [NSString stringWithFormat:@"%d",intValue];
}

+ (NSString *)yq_stringWithInteger:(NSInteger)integerValue
{
    return [NSString stringWithFormat:@"%ld",(long)integerValue];
}

+ (NSString *)yq_stringWithDoubleValue:(double)value
{
    return [NSString stringWithFormat:@"%.1lf",value];
}

+ (NSString *)yq_stringWithDoubleLocate:(double)value
{
    return [NSString stringWithFormat:@"%lf",value];
}

// 首字母大写
- (NSString *)yq_uppercaseFirstString{
    if (self.length > 0) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] capitalizedString]];
    }
    return nil;
}

// 将数组、字典转换成json
+ (NSString *)yq_jsonStringWithObject:(id)object
{
    if (object && [NSJSONSerialization isValidJSONObject:object]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        
        if ([jsonData length] > 0 && error == nil) {
            
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
    }
    return nil;
}

// 根据格式显示时间
+ (NSString *)yq_dateStringWithDate1970:(NSTimeInterval) date formatter:(NSString *)formatter{
    return [self yq_dateStringWithDate:[NSDate dateWithTimeIntervalSince1970:date] formatter:formatter];
}

// 根据格式显示时间
+ (NSString *)yq_dateStringWithDate:(NSDate *)date formatter:(NSString *)formatter{
    static NSDateFormatter *dateFormatter = nil;
    @synchronized(@"dateFormatter"){
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
        }
    }
    
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:date];
}

/**
 *  根据距离今天的天数从formatter中获取格式化字符串，并根据格式化字符串格式化时间
 *
 *  @param date      要格式化的时间相对1970年的秒数
 *  @param formatter 获取格式化字符串的block，参数为指定时间到今天的天数，返回一个格式化字符串
 *
 *  @return 返回一个格式化的字符串
 */
+ (NSString *)yq_dateStringWithDate:(NSTimeInterval)date formatterBlock:(NSString *(^)(NSInteger numberOfDay, NSInteger numberOfMonth, NSInteger numberOfYear))formatter{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *fromDay = nil;
    NSDate *toDay = nil;
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDay interval:NULL forDate:[NSDate dateWithTimeIntervalSince1970:date]];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDay interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitDay fromDate:fromDay toDate:toDay options:0];
    
    NSDate *fromMonth = nil;
    NSDate *toMonth = nil;
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&fromMonth interval:NULL forDate:[NSDate dateWithTimeIntervalSince1970:date]];
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&toMonth interval:NULL forDate:[NSDate date]];
    NSDateComponents *monthComponents = [calendar components:NSCalendarUnitMonth fromDate:fromMonth toDate:toMonth options:0];
    
    NSDate *fromYear = nil;
    NSDate *toYear = nil;
    [calendar rangeOfUnit:NSCalendarUnitYear startDate:&fromYear interval:NULL forDate:[NSDate dateWithTimeIntervalSince1970:date]];
    [calendar rangeOfUnit:NSCalendarUnitYear startDate:&toYear interval:NULL forDate:[NSDate date]];
    NSDateComponents *yearComponents = [calendar components:NSCalendarUnitYear fromDate:fromYear toDate:toYear options:0];
    
    return [self yq_dateStringWithDate1970:date formatter:formatter(dayComponents.day, monthComponents.month, yearComponents.year)];
}

@end
