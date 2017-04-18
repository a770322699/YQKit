//
//  YQMarginLabel.m
//  Demo
//
//  Created by maygolf on 17/3/27.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQMacro.h"
#import "YQCorlorConst.h"

#import "UIView+YQFrame.h"

#import "YQMarginLabel.h"

@interface YQMarginLabel ()
{
    BOOL _round;                // 是否设置过圆角
    UIColor *_boardColor;       // 边框颜色
    CGFloat _boardWidth;        // 边框宽度
}

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation YQMarginLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView = self.contentLabel;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置圆角
    if (_round) {
        YQViewBorderRadius(self, self.yq_height / 2, _boardWidth, _boardColor);
    }
}

#pragma mark - getter
- (UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentLabel;;
}

#pragma mark - public
- (void)makeRound{
    [self makeRoundWithBoardColor:kYQColorClear width:0];
}
// 设置为圆角
- (void)makeRoundWithBoardColor:(UIColor *)color width:(CGFloat)width{
    _round = YES;
    _boardColor = color;
    _boardWidth = width;
    YQViewBorderRadius(self, self.yq_height / 2, width, color);
}

@end
