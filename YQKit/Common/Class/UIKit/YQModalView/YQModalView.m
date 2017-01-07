//
//  YQModalView.m
//  Demo
//
//  Created by maygolf on 16/12/30.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQModalView.h"

@interface YQModalView ()<UIGestureRecognizerDelegate>
{
    struct {
        BOOL willShow;
        BOOL didShow;
        BOOL willDismiss;
        BOOL didDismiss;
    }_delegateFlag;
}

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;

@end

@implementation YQModalView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.duration = 0.25;
        self.dismissWhenTapBgView = YES;
    }
    return self;
}

#pragma mark - getter
- (UIView *)fromView{
    if (!_fromView) {
        _fromView = [UIApplication sharedApplication].keyWindow;
    }
    return _fromView;
}

- (UITapGestureRecognizer *)tapGes{
    if (!_tapGes) {
        _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        _tapGes.delegate = self;
    }
    return _tapGes;
}

#pragma mark - setting
- (void)setDelegate:(id<YQModalViewDelegate>)delegate{
    _delegateFlag.willShow = NO;
    _delegateFlag.didShow = NO;
    _delegateFlag.willDismiss = NO;
    _delegateFlag.didDismiss = NO;
    
    if (delegate && [delegate respondsToSelector:@selector(modalViewWillShow:)]) {
        _delegateFlag.willShow = YES;
    }
    if (delegate && [delegate respondsToSelector:@selector(modalViewDidShow:)]) {
        _delegateFlag.didShow = YES;
    }
    if (delegate && [delegate respondsToSelector:@selector(modalViewWillDismiss:)]) {
        _delegateFlag.willDismiss = YES;
    }
    if (delegate && [delegate respondsToSelector:@selector(modalViewDidDismiss:)]) {
        _delegateFlag.didDismiss = YES;
    }
    
    _delegate = delegate;
}

- (void)setDismissWhenTapBgView:(BOOL)dismissWhenTapBgView{
    if (dismissWhenTapBgView) {
        if (self.tapGes.view != self) {
            [self addGestureRecognizer:self.tapGes];
        }
    }else{
        if (_tapGes && _tapGes.view == self) {
            [self removeGestureRecognizer:_tapGes];
        }
    }
}

#pragma mark - public
- (void)showBegin:(void(^)())beginBlock end:(void(^)())endBlock{
    
    // 将self和contentView添加到父视图
    if (self.superview != self.fromView) {
        [self.fromView addSubview:self];
    }
    if (self.contentView && self.contentView.superview != self) {
        [self addSubview:self.contentView];
    }
    
    // 动画前的配置
    if (beginBlock) {
        beginBlock();
    }else{
        self.alpha = 0;
    }
    
    // 调用代理方法
    if (_delegateFlag.willShow) {
        [self.delegate modalViewWillShow:self];
    }
    
    // 显示视图
    if (self.duration) {
        [UIView animateWithDuration:self.duration animations:^{
            if (endBlock) {
                endBlock();
            }else{
                self.alpha = 1;
            }
        } completion:^(BOOL finished) {
            // 调用代理方法
            if (_delegateFlag.didShow) {
                [self.delegate modalViewDidShow:self];
            }
        }];
    }else{
        if (endBlock) {
            endBlock();
        }else{
            self.alpha = 1;
        }
        
        // 调用代理方法
        if (_delegateFlag.didShow) {
            [self.delegate modalViewDidShow:self];
        }
    }
    
    // 更新状态
    self.isShow = YES;
}

- (void)dismissEnd:(void(^)())endBlock{
    
    // 调用代理方法
    if (_delegateFlag.willDismiss) {
        [self.delegate modalViewWillDismiss:self];
    }
    
    // 隐藏视图
    if (self.duration) {
        [UIView animateWithDuration:self.duration animations:^{
            if (endBlock) {
                endBlock();
            }else{
                self.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            // 调用代理方法
            if (_delegateFlag.didDismiss) {
                [self.delegate modalViewDidDismiss:self];
            }
        }];
    }else{
        self.alpha = 0;
        [self removeFromSuperview];
        
        // 调用代理方法
        if (_delegateFlag.didDismiss) {
            [self.delegate modalViewDidDismiss:self];
        }
    }
    
    // 更新状态
    self.isShow = NO;
}

- (void)show{
    [self showBegin:nil end:nil];
}

- (void)dismiss{
    [self dismissEnd:nil];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if ([touch.view isKindOfClass:[YQModalView class]]) {
        return YES;
    }
    return NO;
}

@end
