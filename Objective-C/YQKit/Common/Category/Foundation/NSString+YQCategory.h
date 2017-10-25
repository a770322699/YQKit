//
//  NSString+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YQCategory)

// md5加密
- (NSString *)yq_md5Encrypt;
// DES加密
- (NSString *)yq_DESEncryptForKey:(NSString *)key;
// DES解密
- (NSString *)yq_DESDecryptForKey:(NSString *)key;
// base64
- (NSData *)yq_base64Data;
+ (NSString *)yq_stringWithBase64Data:(NSData *)data;

+ (NSString *)yq_stringWithInt:(int)intValue;
+ (NSString *)yq_stringWithInteger:(NSInteger)integerValue;
+ (NSString *)yq_stringWithDoubleValue:(double)value;
+ (NSString *)yq_stringWithDoubleLocate:(double)value;

// 首字母大写
- (NSString *)yq_uppercaseFirstString;

// 将数组、字典转换成json
+ (NSString *)yq_jsonStringWithObject:(id)object;

// 根据格式显示时间
+ (NSString *)yq_dateStringWithDate1970:(NSTimeInterval) date formatter:(NSString *)formatter;
// 根据格式显示时间
+ (NSString *)yq_dateStringWithDate:(NSDate *)date formatter:(NSString *)formatter;

/**
 *  根据距离今天的天数从formatter中获取格式化字符串，并根据格式化字符串格式化时间
 *
 *  @param date      要格式化的时间相对1970年的秒数
 *  @param formatter 获取格式化字符串的block，参数为指定时间到今天的天数，返回一个格式化字符串
 *
 *  @return 返回一个格式化的字符串
 */
+ (NSString *)yq_dateStringWithDate:(NSTimeInterval)date formatterBlock:(NSString *(^)(NSInteger numberOfDay, NSInteger numberOfMonth, NSInteger numberOfYear))formatter;

@end
