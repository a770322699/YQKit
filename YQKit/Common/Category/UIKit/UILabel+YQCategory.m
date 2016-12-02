//
//  UILabel+YQCategory.m
//  Demo
//
//  Created by maygolf on 16/11/11.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UILabel+YQCategory.h"

@implementation UILabel (YQCategory)

- (void)yq_setAttrStrWithStr:(NSString *)text diffColorStr:(NSString *)diffColorStr diffColor:(UIColor *)diffColor{
    NSMutableAttributedString *attrStr;
    if (text) {
        attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    }
    if (diffColorStr && diffColor) {
        NSRange diffColorRange = [text rangeOfString:diffColorStr];
        if (diffColorRange.location != NSNotFound) {
            [attrStr addAttribute:NSForegroundColorAttributeName value:diffColor range:diffColorRange];
        }
    }
    self.attributedText = attrStr;
}
- (void)yq_addAttrDict:(NSDictionary *)attrDict toStr:(NSString *)str{
    if (str.length <= 0) {
        return;
    }
    NSMutableAttributedString *attrStr = self.attributedText? self.attributedText.mutableCopy: [[NSMutableAttributedString alloc] initWithString:self.text];
    [self yq_addAttrDict:attrDict toRange:[attrStr.string rangeOfString:str]];
}
- (void)yq_addAttrDict:(NSDictionary *)attrDict toRange:(NSRange)range{
    if (range.location == NSNotFound || range.length <= 0) {
        return;
    }
    NSMutableAttributedString *attrStr = self.attributedText? self.attributedText.mutableCopy: [[NSMutableAttributedString alloc] initWithString:self.text];
    if (range.location + range.length > attrStr.string.length) {
        return;
    }
    [attrStr addAttributes:attrDict range:range];
    self.attributedText = attrStr;
}

@end
