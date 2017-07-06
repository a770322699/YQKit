//
//  NSObject+YQObject.m
//  Demo
//
//  Created by maygolf on 17/6/26.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "NSObject+YQObject.h"

@implementation NSObject (YQObject)

+ (NSString *)yq_className{
    return NSStringFromClass(self);
}

- (NSString *)yq_className{
    return NSStringFromClass([self class]);
}

@end
