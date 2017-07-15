//
//  UILabel+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/11/11.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (YQCategory)

- (void)yq_setAttrStrWithStr:(NSString *)text diffColorStr:(NSString *)diffColorStr diffColor:(UIColor *)diffColor;
- (void)yq_addAttrDict:(NSDictionary *)attrDict toStr:(NSString *)str;
- (void)yq_addAttrDict:(NSDictionary *)attrDict toRange:(NSRange)range;

// 计算某段文本的frame
- (CGRect)yq_boundingRectForCharacterRange:(NSRange)range;

@end
