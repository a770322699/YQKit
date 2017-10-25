//
//  YQImageTextView.m
//  Demo
//
//  Created by maygolf on 17/3/27.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQImageTextView.h"

@interface YQImageTextView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) YQImageTextViewStyle style;

@end

@implementation YQImageTextView

- (instancetype)initWithLeadingView:(UIView *)leading trailingView:(UIView *)trailing{
    return [self initWithStyle:YQImageTextViewStyle_normal];
}

- (instancetype)initWithStyle:(YQImageTextViewStyle)style{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *leading = imageView, *trailing = label;
    if (style == YQImageTextViewStyle_reverse) {
        leading = label;
        trailing = imageView;
    }
    
    if (self = [super initWithLeadingView:leading trailingView:trailing]) {
        _imageView = imageView;
        _label = label;
        _style = style;
        
        self.space = kYQImageTextViewSpaceDefault;
    }
    return self;
}

@end
