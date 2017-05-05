//
//  YQMarginView.m
//  Demo
//
//  Created by maygolf on 17/3/27.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "Masonry.h"

#import "YQMarginView.h"

@interface YQMarginView ()

@property (nonatomic, strong) MASConstraint *marginConstraint;  //

@end

@implementation YQMarginView

#pragma mark - setting
- (void)setContenMargin:(UIEdgeInsets)contenMargin{
    _contenMargin = contenMargin;
    [self.marginConstraint setInsets:contenMargin];
}

- (void)setContentView:(UIView *)contentView{
    if (_contentView != contentView) {
        // 移除原来的视图
        if (_contentView) {
            [_contentView removeFromSuperview];
        }
        
        // 添加新视图
        _contentView = contentView;
        if (contentView) {
            [self addSubview:contentView];
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                self.marginConstraint = make.edges.mas_equalTo(self.contenMargin);
            }];
        }
    }
}

@end
