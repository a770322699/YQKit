//
//  UIColor+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/11/7.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YQCategory)

// 从16进制创建一个UIColor
+ (UIColor *)yq_colorWithHexStrint:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)yq_colorWithHexStrint:(NSString *)hexString;

@end
