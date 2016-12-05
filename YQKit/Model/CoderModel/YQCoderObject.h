//
//  YQCoderObject.h
//  Demo
//
//  Created by maygolf on 16/12/5.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQCoderObject : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)item;
+ (NSArray *)objectsWithItems:(NSArray *)items;

@end
