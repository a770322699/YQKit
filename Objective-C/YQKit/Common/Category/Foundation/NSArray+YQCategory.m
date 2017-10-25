//
//  NSArray+YQCategory.m
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSArray+YQCategory.h"

@implementation NSArray (YQCategory)

// 将数组中元素的某一属性用separator连接起来
- (NSString *)yq_componentsJoinedKeyPath:(NSString *)keyPath ByString:(NSString *)separator{
//    int i=0;
//    NSMutableString *compenStr = nil;
//    for (NSObject *objc in self) {
//        if (i == 0) {
//            compenStr = [NSMutableString stringWithFormat:@"%@",[objc valueForKeyPath:keyPath]];
//        }else{
//            [compenStr appendFormat:@"%@%@",separator,[objc valueForKeyPath:keyPath]];
//        }
//        i++;
//    }
//    return compenStr;
    
    NSArray *components = [self valueForKeyPath:keyPath];
    return [components componentsJoinedByString:separator];
}

+ (instancetype)yq_arrayWithOrderSet:(NSOrderedSet *)orderSet{    
    return [orderSet objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, orderSet.count)]];
}

- (instancetype)yq_addObjectsFromOrderSet:(NSOrderedSet *)orderSet{
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:self];
    [resultArray addObjectsFromArray:[NSArray yq_arrayWithOrderSet:orderSet]];
    
    return resultArray;
}

- (instancetype)yq_addObjectsFromArray:(NSArray *)array{
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:self];
    
    [resultArray addObjectsFromArray:array];
    return resultArray;
}
- (instancetype)yq_addObject:(id)object{
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:self];
    [resultArray addObject:object];
    
    return resultArray;
}
- (instancetype)yq_insetObject:(id)object atIndex:(NSInteger)index{
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:self];
    [resultArray insertObject:object atIndex:index];
    
    return resultArray;
}


+ (instancetype)yq_arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) return array;
    return nil;
}

+ (instancetype)yq_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self yq_arrayWithPlistData:data];
}

// 从多个数组创建一个数组
+ (instancetype)yq_arrayWithArrays:(NSArray *)firstArray, ...{
    NSMutableArray *resultArrays = [NSMutableArray array];
    
    va_list argList;
    
    if (firstArray) {
        [resultArrays addObjectsFromArray:firstArray];
        
        va_start(argList, firstArray);
        
        id temp;
        
        while ((temp = va_arg(argList, NSArray *))) {
            [resultArrays addObjectsFromArray:temp];
        }
    }
    
    va_end(argList);
    
    return resultArrays.count ? resultArrays : nil;
}

- (NSData *)yq_plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)yq_plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];;
    return nil;
}

- (id)yq_randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (id)yq_objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

@end


@implementation NSMutableArray (YQCategory)

+ (instancetype)yq_arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

+ (instancetype)yq_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self yq_arrayWithPlistData:data];
}

- (void)yq_removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)yq_removeLastObject {
    if (self.count) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

#pragma clang diagnostic pop


- (id)yq_popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self yq_removeFirstObject];
    }
    return obj;
}

- (id)yq_popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

- (void)yq_appendObject:(id)anObject {
    [self addObject:anObject];
}

- (void)yq_prependObject:(id)anObject {
    [self insertObject:anObject atIndex:0];
}

- (void)yq_appendObjects:(NSArray *)objects {
    if (!objects) return;
    [self addObjectsFromArray:objects];
}

- (void)yq_prependObjects:(NSArray *)objects {
    if (!objects) return;
    NSUInteger i = 0;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)yq_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)yq_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)yq_shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end
