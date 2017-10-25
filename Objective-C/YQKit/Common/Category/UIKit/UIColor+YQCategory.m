//
//  UIColor+YQCategory.m
//  Demo
//
//  Created by maygolf on 16/11/7.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UIColor+YQCategory.h"

@implementation UIColor (YQCategory)

+ (UIColor *)yq_colorWithHexStrint:(NSString *)hexString alpha:(CGFloat)alpha{
    // 去掉前后空格和换行符
    NSString *cString=[[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length]<6) return [UIColor clearColor];
    
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }else if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6) return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location=2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location=4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r,g,b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
}

+ (UIColor *)yq_colorWithHexStrint:(NSString *)hexString{
    return [self yq_colorWithHexStrint:hexString alpha:1];
}

@end
