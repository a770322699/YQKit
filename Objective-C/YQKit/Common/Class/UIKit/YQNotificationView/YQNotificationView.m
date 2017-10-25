//
//  YQNotificationView.m
//  Demo
//
//  Created by maygolf on 17/5/4.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "Masonry.h"

#import "YQGlobalValue.h"
#import "YQNotificationView.h"
#import "YQCombinationView.h"

static const CGFloat        kTitleFontSize      = 15.0;
static const CGFloat        kDescFontSize       = 14.0;
static const NSInteger      kDescLines          = 2;
static const CGFloat        kImageSize          = 60;
static const CGFloat        kTitleDescSpace     = 2.0;
static const CGFloat        kImageTextSpace     = 5.0;

#define kContentInsets      UIEdgeInsetsMake(5, 5, 5, 5)
#define kBgViewInsets       UIEdgeInsetsMake(20, 5, 5, 5)

static const NSTimeInterval kAnimationDuration  = 0.25;
static const NSTimeInterval kDisplayDuration    = 2;

@interface YQNotificationView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) MASConstraint *titleDescSpaceConstraint;
@property (nonatomic, strong) MASConstraint *yConstraint;

@property (nonatomic, assign) BOOL isShow;

@end

@implementation YQNotificationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.animationDuration = kAnimationDuration;
        self.displayDuration = kDisplayDuration;
        
        YQIntrinsicContentSizeView *textView = [[YQIntrinsicContentSizeView alloc] init];
        textView.backgroundColor = [UIColor clearColor];
        [textView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.top.mas_equalTo(@0);
            make.trailing.mas_lessThanOrEqualTo(@0);
        }];
        
        [textView addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.bottom.mas_equalTo(@0);
            make.trailing.mas_lessThanOrEqualTo(@0);
            self.titleDescSpaceConstraint = make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
        }];
        
        YQCombinationView *contentView = [[YQCombinationView alloc] initWithLeadingView:self.imageView trailingView:textView];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.space = kImageTextSpace;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kImageSize, kImageSize));
        }];
        
        YQIntrinsicContentSizeView *bgView = [[YQIntrinsicContentSizeView alloc] init];
        YQViewBorderRadius(bgView, 4, 0, kYQColorClear);
        bgView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(@(kContentInsets.left));
            make.top.mas_equalTo(@(kContentInsets.top));
            make.bottom.mas_equalTo(@(- kContentInsets.bottom));
            make.trailing.mas_lessThanOrEqualTo(@(- kContentInsets.right));
        }];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [kYQColorBlack colorWithAlphaComponent:0.6];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(kBgViewInsets);
        }];
    }
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];
    
    self.titleDescSpaceConstraint.offset = self.title.length && self.desc.length ? kTitleDescSpace : 0;
    if (self.superview) {
        [self.yConstraint uninstall];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.isShow) {
                self.yConstraint = make.top.mas_equalTo(self.superview.mas_top);
            }else{
                self.yConstraint = make.bottom.mas_equalTo(self.superview.mas_top);
            }
        }];
    }
}

#pragma mark - getter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        YQViewBorderRadius(_imageView, 4, 0, kYQColorClear);
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
    }
    return _titleLabel;
}

- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descLabel.font = [UIFont systemFontOfSize:kDescFontSize];
        _descLabel.numberOfLines = kDescLines;
    }
    return _descLabel;
}

#pragma mark - setting
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setDesc:(NSString *)desc{
    _desc = desc;
    self.descLabel.text = desc;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

#pragma mark - private
- (void)dismiss{
    self.isShow = NO;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - public
- (void)show{
    if (self.isShow) {
        return;
    }
    
    if (!self.image && !self.title.length && !self.desc.length) {
        return;
    }
    
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    if (self.superview != superView) {
        [superView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.mas_equalTo(@0);
        }];
    }
    
    self.imageView.hidden = !self.image;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self.superview layoutIfNeeded];
    
    self.isShow = YES;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        YQTimerStart(self.displayDuration, self.displayDuration, NULL, ^{
            [self dismiss];
        });
    }];
}

+ (void)showNotificationWithTitle:(NSString *)title
                             desc:(NSString *)desc
                            image:(UIImage *)image{
    [self showNotificationWithTitle:title
                               desc:desc
                              image:image
                  animationDuration:kAnimationDuration
                    displayDuration:kDisplayDuration];
}

+ (void)showNotificationWithTitle:(NSString *)title
                             desc:(NSString *)desc
                            image:(UIImage *)image
                animationDuration:(NSTimeInterval)animationDuration
                  displayDuration:(NSTimeInterval)displayDuration{
    YQNotificationView *view = [[YQNotificationView alloc] init];
    view.title = title;
    view.desc = desc;
    view.image = image;
    view.animationDuration = animationDuration;
    view.displayDuration = displayDuration;
    
    [view show];
}

@end
