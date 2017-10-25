//
//  YQBuildingManager.m
//  Demo
//
//  Created by maygolf on 17/6/21.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQBuildingManager.h"

@interface YQBuildingManager ()

// 计算大小的视图
@property (nonatomic, retain) UITextView *layoutView;
@property (nonatomic, retain) UILabel *layoutLabel;

@end

@implementation YQBuildingManager
YQ_SYNTHESIZE_SINGLETON_FOR_CLASS(YQBuildingManager)

- (UILabel *)layoutLabel{
    if (!_layoutLabel) {
        _layoutLabel = [[UILabel alloc] init];
        _layoutLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _layoutLabel.numberOfLines = 0;
    };
    return _layoutLabel;
}
- (UITextView *)layoutView{
    if (!_layoutView) {
        _layoutView = [[UITextView alloc] init];
        _layoutView.scrollEnabled = NO;
    }
    
    return _layoutView;
}

// 计算label的高度
- (CGSize)labelSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    self.layoutLabel.preferredMaxLayoutWidth = maxSize.width;
    self.layoutLabel.font = font;
    self.layoutLabel.text = text;
    
    return [self.layoutLabel sizeThatFits:maxSize];
}
// 计算textView的高度(此接口尚未测试)
- (CGSize)textViewSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    self.layoutView.frame = CGRectMake(0, 0, maxSize.width, maxSize.height);
    self.layoutView.font = font;
    self.layoutView.text = text;
    
    CGSize resultSize = [self.layoutView sizeThatFits:maxSize];
    return CGSizeMake(MIN(resultSize.width, maxSize.width), MIN(resultSize.height, maxSize.height));
}

@end
