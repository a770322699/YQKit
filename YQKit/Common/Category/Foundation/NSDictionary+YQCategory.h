//
//  NSDictionary+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kGroupDictionaryKeyDefault           @"#"

@interface NSDictionary (YQCategory)

// 获取url的参数
+ (NSDictionary *)yq_parameterDictionaryFromURLString:(NSString *)urlString;
// 由多个字典创建一个字典
+ (NSDictionary *)yq_dictionaryWithDictionarys:(NSArray *)dics;

// 将数组中的成员进行分组，将同一组中的成员放入同一数组中，并作为value以给定的key放入结果字典中
+ (NSDictionary *)yq_groupDictionaryFromMembers:(NSArray *)members withKeyPath:(NSString *)keyPath;

/**
 *  将数组中的成员进行分组，将同一组中的成员放入同一数组中，并作为value以给定的key放入结果字典中
 *
 *  @param members    要进行分组的成员数组
 *  @param groupKey   一个通过成员返回该成员对应分组key的block
 *  @param keyPath    若groupKey为nil，或者groupKey返回一个nil，那么根据成员的keyPath属性进行按首字母分组，首字母部分大小写(即：A与a分在同一组)，并放入以其首字母为key的分组中
 *  @param defaultKey 若既没有按照groupKey分组（groupKey为nil，或者返回nil），又没有按照keyPath分组（keyPath为nil），那么就放入以defaultKey为key的分组中，若defaultkey为nil，那么该成员不被分组
 *
 *  @return 返回一个完成分组的字典
 */
+ (NSDictionary *)yq_groupDictionaryFromMembers:(NSArray *)members toGroup:(id(^)(id member))groupKey otherMemberKeyPath:(NSString *)keyPath defaultKey:(id)defaultKey;

- (BOOL)yq_hasKey:(NSString *)key;

- (NSString*)yq_stringForKey:(id)key;

- (NSNumber*)yq_numberForKey:(id)key;

- (NSDecimalNumber *)yq_decimalNumberForKey:(id)key;

- (NSArray*)yq_arrayForKey:(id)key;

- (NSDictionary*)yq_dictionaryForKey:(id)key;

- (NSInteger)yq_integerForKey:(id)key;

- (NSUInteger)yq_unsignedIntegerForKey:(id)key;

- (BOOL)yq_boolForKey:(id)key;

- (int16_t)yq_int16ForKey:(id)key;

- (int32_t)yq_int32ForKey:(id)key;

- (int64_t)yq_int64ForKey:(id)key;

- (char)yq_charForKey:(id)key;

- (short)yq_shortForKey:(id)key;

- (float)yq_floatForKey:(id)key;

- (double)yq_doubleForKey:(id)key;

- (long long)yq_longLongForKey:(id)key;

- (unsigned long long)yq_unsignedLongLongForKey:(id)key;

- (NSDate *)yq_dateForKey:(id)key dateFormat:(NSString *)dateFormat;

//CG
- (CGFloat)yq_CGFloatForKey:(id)key;

- (CGPoint)yq_pointForKey:(id)key;

- (CGSize)yq_sizeForKey:(id)key;

- (CGRect)yq_rectForKey:(id)key;

- (id)yq_objectOrNilForKey:(NSString *)key;
- (id)yq_objectOrNileForKeyPath:(NSString *)keyPath;

@end

@interface NSMutableDictionary (YQCategory)

//往字典里的数组添加数组对象
- (void)yq_addObjectsToArrayInDictionary:(NSDictionary *)otherDictionary;
- (void)yq_appendObject:(id)object toListKey:(id)key;

-(void)yq_setObj:(id)i forKey:(NSString*)key;

-(void)yq_setString:(NSString*)i forKey:(NSString*)key;

-(void)yq_setBool:(BOOL)i forKey:(NSString*)key;

-(void)yq_setInt:(int)i forKey:(NSString*)key;

-(void)yq_setInteger:(NSInteger)i forKey:(NSString*)key;

-(void)yq_setUnsignedInteger:(NSUInteger)i forKey:(NSString*)key;

-(void)yq_setCGFloat:(CGFloat)f forKey:(NSString*)key;

-(void)yq_setChar:(char)c forKey:(NSString*)key;

-(void)yq_setFloat:(float)i forKey:(NSString*)key;

-(void)yq_setDouble:(double)i forKey:(NSString*)key;

-(void)yq_setLongLong:(long long)i forKey:(NSString*)key;

-(void)yq_setPoint:(CGPoint)o forKey:(NSString*)key;

-(void)yq_setSize:(CGSize)o forKey:(NSString*)key;

-(void)yq_setRect:(CGRect)o forKey:(NSString*)key;

@end
