//
//  YQCoderObject.m
//  Demo
//
//  Created by maygolf on 16/12/5.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSObject+YQCoder.h"

#import "YQCoderObject.h"

@implementation YQCoderObject

- (instancetype)initWithDictionary:(NSDictionary *)item{
    if (self = [super init]) {
        
    }
    return self;
}

+ (NSArray *)objectsWithItems:(NSArray *)items{
    NSMutableArray *objects = nil;
    for (NSDictionary *item in items) {
        YQCoderObject *object = [[self alloc] initWithDictionary:item];
        if (object) {
            if (objects == nil) objects = [NSMutableArray array];
            [objects addObject:object];
        }
    }
    return objects;
}


#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self yq_encodeWithCoder:aCoder];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self yq_decodeWithCoder:aDecoder];
    }
    return self;
}

@end
