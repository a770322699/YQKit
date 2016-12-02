//
//  UIView+YQLoading.m
//  Demo
//
//  Created by maygolf on 16/11/15.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <objc/runtime.h>

#import "YQGlobalValue.h"
#import "Masonry.h"

#import "UIView+YQLoading.h"
#import "YQIntrinsicContentSizeView.h"

static const NSInteger kloadingTextColor = 0xa2a2a2;

@interface YQNormalLoadingView : UIView<YQLoadingView>

@property (nonatomic, strong) NSString *loadingText;
@property (nonatomic, assign) BOOL isLoading;

@end

@interface YQNormalLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) MASConstraint *labelLoadingSpaceConstraint;

@end

@implementation YQNormalLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        YQIntrinsicContentSizeView *contentView = [[YQIntrinsicContentSizeView alloc] init];
        contentView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:self.loadingView];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@0);
            make.width.mas_lessThanOrEqualTo(contentView);
            make.centerX.mas_equalTo(contentView);
        }];
        [contentView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(@0);
            make.width.mas_lessThanOrEqualTo(contentView);
            make.centerX.mas_equalTo(contentView);
            self.labelLoadingSpaceConstraint = make.top.mas_equalTo(self.loadingView.mas_bottom).offset(0);
        }];
        
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_lessThanOrEqualTo(self);
        }];
        
        // 初始化为非加载状态
        [self stopLoadingCompletion:nil];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = YQHexColor(kloadingTextColor);
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}

- (UIActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.hidesWhenStopped = YES;
        _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _loadingView;
}

- (NSString *)loadingText{
    return self.textLabel.text;
}

#pragma mark - setting
- (void)setLoadingText:(NSString *)loadingText{
    self.textLabel.text = loadingText;
    [self.labelLoadingSpaceConstraint setOffset:loadingText.length ? 5.0 : 0];
}

#pragma mark - YQLoadingViewPrototol
- (void)beginLoadingCompletion:(void(^)()) completion{
    self.hidden = NO;
    [self.loadingView startAnimating];
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
    
    self.isLoading = YES;
}

- (void)stopLoadingCompletion:(void(^)()) completion{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self.loadingView stopAnimating];
        if (completion) {
            completion();
        }
    }];
    
    self.isLoading = NO;
}

@end

// YQNormalLoadingView end
//****************************************************************************************************************************//

//****************************************************************************************************************************//
// YQLoadingPrivate   start

static const char *kRuntimeSaveKey_LoadingViewContentInsetConstraint = "kRuntimeSaveKey_LoadingViewContentInsetConstraint";

@interface UIView (YQLoadingPrivate)

@property (nonatomic, strong) MASConstraint *yq_loadingPrivate_loadingViewContentInsetConstraint;

@end

@implementation UIView (YQLoadingPrivate)

- (MASConstraint *)yq_loadingPrivate_loadingViewContentInsetConstraint{
    return objc_getAssociatedObject(self, kRuntimeSaveKey_LoadingViewContentInsetConstraint);
}

- (void)setYq_loadingPrivate_loadingViewContentInsetConstraint:(MASConstraint *)yq_loadingPrivate_loadingViewContentInsetConstraint{
    objc_setAssociatedObject(self, kRuntimeSaveKey_LoadingViewContentInsetConstraint, yq_loadingPrivate_loadingViewContentInsetConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

// YQLoadingPrivate end
//****************************************************************************************************************************//

//****************************************************************************************************************************//
// YQLoading   start

static const char *kRuntimeSaveKey_loadingStyle = "kRuntimeSaveKey_loadingStyle";
static const char *kRuntimeSaveKey_loadingView  = "kRuntimeSaveKey_loadingView";
static const char *kRuntimeSaveKey_loadingInsets = "kRuntimeSaveKey_loadingInsets";
static const char *kRuntimeSaveKey_userInteractionEnabledWhenLoaing = "kRuntimeSaveKey_userInteractionEnabledWhenLoain";

@implementation UIView (YQLoading)

#pragma mark - getter
- (NSString *)yq_loadingText{
    return self.yq_loadingView.loadingText;
}

- (BOOL)yq_isLoading{
    return self.yq_loadingView.isLoading;
}

- (YQLoadingStyle)yq_loadingStyle{
    return [objc_getAssociatedObject(self, kRuntimeSaveKey_loadingStyle) integerValue];
}

- (UIEdgeInsets)yq_loadingViewInsets{
    return [objc_getAssociatedObject(self, kRuntimeSaveKey_loadingInsets) UIEdgeInsetsValue];
}

- (UIView<YQLoadingView> *)yq_loadingView{
    UIView<YQLoadingView> *view = objc_getAssociatedObject(self, kRuntimeSaveKey_loadingView);
    if (!view) {
        switch (self.yq_loadingStyle) {
            case YQLoadingStyle_normal:
                view = [[YQNormalLoadingView alloc] init];
                view.backgroundColor = [UIColor clearColor];
                break;
                
            default:
                break;
        }
        
        if (view) {
            self.yq_loadingView = view;
        }
    }
    
    return view;
}

- (BOOL)yq_userInteractionEnabledWhenLoaing{
    return [objc_getAssociatedObject(self, kRuntimeSaveKey_userInteractionEnabledWhenLoaing) boolValue];
}

#pragma mark - setting
- (void)setYq_loadingText:(NSString *)yq_loadingText{
    self.yq_loadingView.loadingText = yq_loadingText;
}

- (void)setYq_loadingStyle:(YQLoadingStyle)yq_loadingStyle{
    objc_setAssociatedObject(self, kRuntimeSaveKey_loadingStyle, @(yq_loadingStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setYq_loadingView:(UIView<YQLoadingView> *)yq_loadingView{
    objc_setAssociatedObject(self, kRuntimeSaveKey_loadingView, yq_loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setYq_loadingViewInsets:(UIEdgeInsets)yq_loadingViewInsets{
    [self.yq_loadingPrivate_loadingViewContentInsetConstraint setInsets:yq_loadingViewInsets];
    objc_setAssociatedObject(self, kRuntimeSaveKey_loadingInsets, [NSValue valueWithUIEdgeInsets:yq_loadingViewInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setYq_userInteractionEnabledWhenLoaing:(BOOL)yq_userInteractionEnabledWhenLoaing{
    
    self.yq_loadingView.userInteractionEnabled = !yq_userInteractionEnabledWhenLoaing;
    objc_setAssociatedObject(self, kRuntimeSaveKey_userInteractionEnabledWhenLoaing, @(yq_userInteractionEnabledWhenLoaing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - public
- (void)yq_beginLoading{
    if (self.yq_isLoading) {
        return;
    }
    
    if (self.yq_loadingView.superview != self) {
        [self addSubview:self.yq_loadingView];
        [self.yq_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.yq_loadingPrivate_loadingViewContentInsetConstraint = make.edges.mas_equalTo(self.yq_loadingViewInsets);
        }];
    }
    
    [self bringSubviewToFront:self.yq_loadingView];
    [self.yq_loadingView beginLoadingCompletion:nil];
}

- (void)yq_stopLoading{
    if (self.yq_isLoading == NO) {
        return;
    }
    
    [self.yq_loadingView stopLoadingCompletion:nil];
}

@end
