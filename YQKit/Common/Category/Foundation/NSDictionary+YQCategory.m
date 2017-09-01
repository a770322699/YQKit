//
//  NSDictionary+YQCategory.m
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSDictionary+YQCategory.h"

@implementation NSDictionary (YQCategory)

+ (NSDictionary *)yq_parameterDictionaryFromURLString:(NSString *)urlString{
    NSString *parameterString = [[urlString componentsSeparatedByString:@"?"] lastObject];
    NSArray *parameterArray = [parameterString componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *resultDic = nil;
    for (NSString *parameterItem in parameterArray) {
        if (resultDic == nil) {
            resultDic = [NSMutableDictionary dictionary];
        }
        
        NSArray *parameterKeyValue = [parameterItem componentsSeparatedByString:@"="];
        [resultDic setValue:[parameterKeyValue lastObject] forKey:[parameterKeyValue firstObject]];
    }
    
    return resultDic;
}

+ (NSDictionary *)yq_dictionaryWithDictionarys:(NSArray *)dics{
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in dics) {
        [resultDic setValuesForKeysWithDictionary:dic];
    }
    
    return resultDic;
}

+ (NSDictionary *)yq_groupDictionaryFromMembers:(NSArray *)members withKeyPath:(NSString *)keyPath{
    return [self yq_groupDictionaryFromMembers:members toGroup:nil otherMemberKeyPath:keyPath defaultKey:kGroupDictionaryKeyDefault];
}

+ (NSDictionary *)yq_groupDictionaryFromMembers:(NSArray *)members toGroup:(id(^)(id member))groupKey otherMemberKeyPath:(NSString *)keyPath defaultKey:(id)defaultKey{
    if (members.count == 0) return nil;
    
    // 定义结果字典
    NSMutableDictionary *resultDictionary = nil;
    
    for (id member in members) {
        // 获取member应该被分组的key
        id key = nil;
        // 从block重获取key
        if (groupKey) key = groupKey(member);
        if (key == nil) {   // 么有从block中获取到key
            if (keyPath) {  // 根据keyPath获取key
                // 获取keyPath对应的值
                id keyPathValue = [member valueForKeyPath:keyPath];
                
                // 获取keyPath对应值的字符串表示
                NSString *keyPathString = nil;
                if ([keyPathValue isKindOfClass:[NSString class]]) {
                    keyPathString = keyPathValue;
                }else{
                    keyPathString = [NSString stringWithFormat:@"%@",keyPathValue];
                }
                
                if (keyPathString.length) {
                    // 获取首字母
                    NSString *prefix = [keyPathString substringToIndex:1];
                    [prefix uppercaseString];
                    if ('A' <= *[prefix UTF8String] && *[prefix UTF8String] <= 'Z') {
                        key = prefix;
                    }
                }
            }
        }
        if (key == nil) { // 根据keyPath规则也没获取到key
            if (defaultKey) key = defaultKey;
        }
        
        if (key) { // 若获取到key，放成员放入分组
            if (resultDictionary == nil) resultDictionary = [NSMutableDictionary dictionary];
            
            // 获取分组数组
            NSMutableArray *groupArray = [resultDictionary objectForKey:key];
            // 若还没有该分组，创建一个分组,并存入结果字典
            if (groupArray == nil) {
                groupArray = [NSMutableArray array];
                [resultDictionary setObject:groupArray forKey:key];
            }
            // 将成员添加到该分组
            [groupArray addObject:member];
        }
    }
    return resultDictionary;
}

- (BOOL)yq_hasKey:(NSString *)key {
    return [self valueForKey:key] != nil;
}

- (NSString*)yq_stringForKey:(id)key {
    id value = [self valueForKey:key];
    if (value == nil || value == [NSNull null]){
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}

- (NSNumber*)yq_numberForKey:(id)key {
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (NSDecimalNumber *)yq_decimalNumberForKey:(id)key {
    id value = [self valueForKey:key];
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber*)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString * str = (NSString*)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    return nil;
}


- (NSArray*)yq_arrayForKey:(id)key {
    id value = [self valueForKey:key];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary*)yq_dictionaryForKey:(id)key {
    id value = [self valueForKey:key];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSInteger)yq_integerForKey:(id)key {
    id value = [self valueForKey:key];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}
- (NSUInteger)yq_unsignedIntegerForKey:(id)key {
    id value = [self valueForKey:key];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntegerValue];
    }
    return 0;
}
- (BOOL)yq_boolForKey:(id)key {
    id value = [self valueForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return NO;
}
- (int16_t)yq_int16ForKey:(id)key {
    id value = [self valueForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}
- (int32_t)yq_int32ForKey:(id)key {
    id value = [self valueForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}
- (int64_t)yq_int64ForKey:(id)key {
    id value = [self valueForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value longLongValue];
    }
    return 0;
}

- (char)yq_charForKey:(id)key{
    id value = [self valueForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value charValue];
    }
    return 0;
}
- (short)yq_shortForKey:(id)key {
    id value = [self valueForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (float)yq_floatForKey:(id)key {
    id value = [self valueForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    }
    return 0;
}

- (double)yq_doubleForKey:(id)key {
    id value = [self valueForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value doubleValue];
    }
    return 0;
}

- (long long)yq_longLongForKey:(id)key {
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value longLongValue];
    }
    return 0;
}

- (unsigned long long)yq_unsignedLongLongForKey:(id)key {
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedLongLongValue];
    }
    return 0;
}

- (NSDate *)yq_dateForKey:(id)key dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = dateFormat;
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] && !dateFormat) {
        return [formater dateFromString:value];
    }
    return nil;
}


//CG
- (CGFloat)yq_CGFloatForKey:(id)key {
    CGFloat f = [self[key] doubleValue];
    return f;
}

- (CGPoint)yq_pointForKey:(id)key {
    CGPoint point = CGPointFromString(self[key]);
    return point;
}
- (CGSize)yq_sizeForKey:(id)key {
    CGSize size = CGSizeFromString(self[key]);
    return size;
}

- (CGRect)yq_rectForKey:(id)key {
    CGRect rect = CGRectFromString(self[key]);
    return rect;
}

- (id)yq_objectOrNilForKey:(NSString *)key{
    if (![self isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [self objectForKey:key];
}

- (id)yq_objectOrNileForKeyPath:(NSString *)keyPath{
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];
    
    if (keys.count == 0) {
        return nil;
    }
    
    id value = self;
    for (NSString *key in keys) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            value = [value yq_objectOrNilForKey:key];
        }else{
            return nil;
        }
    }
    
    return value;
}

@end

@implementation NSMutableDictionary (YQCategory)

- (void)yq_addObjectsToArrayInDictionary:(NSDictionary *)otherDictionary {
    for (NSString *key in otherDictionary.allKeys) {
        NSMutableArray *keyValuesArray = [self[key] mutableCopy];
        NSArray *array = otherDictionary[key];
        if (keyValuesArray) {
            [keyValuesArray addObjectsFromArray:array];
        } else {
            keyValuesArray = array.mutableCopy;
        }
        [self setObject:keyValuesArray forKey:key];
    }
}

- (void)yq_appendObject:(id)object toListKey:(id)key {
    id obj = [self objectForKey:key];
    if(obj) {
        if([obj isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *list = (NSMutableArray *)obj;
            [list addObject:object];
        }
        else {
            NSMutableArray *list = [NSMutableArray array];
            [list addObjectsFromArray:obj];
            [list addObject:object];
            [self setObject:list forKey:key];
        }
        
    }
    else {
        [self setObject:object forKey:key];
    }
}

-(void)yq_setObj:(id)i forKey:(NSString*)key {
    if (i != nil) {
        self[key] = i;
    }
}
-(void)yq_setString:(NSString*)i forKey:(NSString*)key; {
    if (i) {
        [self setValue:i forKey:key];
    }
}
-(void)yq_setBool:(BOOL)i forKey:(NSString *)key {
    self[key] = @(i);
}
-(void)yq_setInt:(int)i forKey:(NSString *)key {
    self[key] = @(i);
}
-(void)yq_setInteger:(NSInteger)i forKey:(NSString *)key {
    self[key] = @(i);
}
-(void)yq_setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key {
    self[key] = @(i);
}
-(void)yq_setCGFloat:(CGFloat)f forKey:(NSString *)key {
    self[key] = @(f);
}
-(void)yq_setChar:(char)c forKey:(NSString *)key {
    self[key] = @(c);
}
-(void)yq_setFloat:(float)i forKey:(NSString *)key {
    self[key] = @(i);
}
-(void)yq_setDouble:(double)i forKey:(NSString*)key {
    self[key] = @(i);
}
-(void)yq_setLongLong:(long long)i forKey:(NSString*)key {
    self[key] = @(i);
}
-(void)yq_setPoint:(CGPoint)o forKey:(NSString *)key {
    self[key] = NSStringFromCGPoint(o);
}
-(void)yq_setSize:(CGSize)o forKey:(NSString *)key {
    self[key] = NSStringFromCGSize(o);
}
-(void)yq_setRect:(CGRect)o forKey:(NSString *)key {
    self[key] = NSStringFromCGRect(o);
}


@end
