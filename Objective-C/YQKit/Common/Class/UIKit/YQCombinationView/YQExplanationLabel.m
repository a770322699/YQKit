//
//  YQExplanationLabel.m
//  Demo
//
//  Created by maygolf on 2017/9/4.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQExplanationLabel.h"

@interface YQExplanationLabel ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *explanationLabe;

@end

@implementation YQExplanationLabel

- (instancetype)initWithLeadingView:(UIView *)leading trailingView:(UIView *)trailing{
    return [super initWithLeadingView:self.leadingView trailingView:self.explanationLabe];
}

#pragma mark - getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UILabel *)explanationLabe{
    if (!_explanationLabe) {
        _explanationLabe = [[UILabel alloc] init];
        _explanationLabe.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _explanationLabe;
}

@end
