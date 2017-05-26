//
//  YQMultiCombinationView.m
//  Demo
//
//  Created by maygolf on 17/5/26.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <objc/runtime.h>
#import "Masonry.h"
#import "NSArray+YQCategory.h"

#import "YQMultiCombinationView.h"

static const char *kRuntimeSaveKey_yq_multiCombinationViewBeforConstraint = "kRuntimeSaveKey_yq_multiCombinationViewBeforConstraint";
static const char *kRuntimeSaveKey_yq_multiCombinationViewNextConstraint = "kRuntimeSaveKey_yq_multiCombinationViewNextConstraint";

@interface UIView (YQMultiCombinationViewProperty)

@property (nonatomic, strong) MASConstraint *yq_multiCombinationViewBeforConstraint;
@property (nonatomic, strong) MASConstraint *yq_multiCombinationViewNextConstraint;

@end

@implementation UIView (YQMultiCombinationViewProperty)

- (void)setYq_multiCombinationViewBeforConstraint:(MASConstraint *)yq_multiCombinationViewBeforConstraint{
    objc_setAssociatedObject(self, kRuntimeSaveKey_yq_multiCombinationViewBeforConstraint, yq_multiCombinationViewBeforConstraint, OBJC_ASSOCIATION_RETAIN);
}

- (MASConstraint *)yq_multiCombinationViewBeforConstraint{
    return objc_getAssociatedObject(self, kRuntimeSaveKey_yq_multiCombinationViewBeforConstraint);
}

- (void)setYq_multiCombinationViewNextConstraint:(MASConstraint *)yq_multiCombinationViewNextConstraint{
    objc_setAssociatedObject(self, kRuntimeSaveKey_yq_multiCombinationViewNextConstraint, yq_multiCombinationViewNextConstraint, OBJC_ASSOCIATION_RETAIN);
}

- (MASConstraint *)yq_multiCombinationViewNextConstraint{
    return objc_getAssociatedObject(self, kRuntimeSaveKey_yq_multiCombinationViewNextConstraint);
}

@end

//YQMultiCombinationViewProperty end
/******************************************************************************************/
//YQMultiCombinationView start

@interface YQMultiCombinationView ()

@property (nonatomic, assign) YQMultiCombinationViewPattern pattern; // 组合模式
@property (nonatomic, copy) NSArray<UIView *> *views; // 组合的视图集合
@property (nonatomic, assign) CGFloat space; // 间距

@end

@implementation YQMultiCombinationView

- (void)dealloc{
    for (UIView *view in self.views) {
        [view removeObserver:self forKeyPath:@"hidden"];
    }
}

- (instancetype)initWithViews:(NSArray<UIView *> *)views parttern:(YQMultiCombinationViewPattern)pattern space:(CGFloat)space{
    if (self = [super init]) {
        self.pattern = pattern;
        self.views = views;
        self.space = space;
        
        UIView *beforView = nil;
        for (int i = 0; i < views.count; i++) {
            UIView *view = views[i];
            [self addSubview:view];
            
            if (pattern == YQMultiCombinationViewPattern_horizontal) {  // 水平排列
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(self);
                    make.height.mas_lessThanOrEqualTo(self);
                    if (beforView) {
                        view.yq_multiCombinationViewBeforConstraint = make.leading.mas_equalTo(beforView.mas_trailing).offset(space);
                        beforView.yq_multiCombinationViewNextConstraint = view.yq_multiCombinationViewBeforConstraint;
                    }else{
                        view.yq_multiCombinationViewBeforConstraint = make.leading.mas_equalTo(@0);
                    }
                }];
            }else{  // 纵向排列
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self);
                    make.width.mas_lessThanOrEqualTo(self);
                    if (beforView) {
                        view.yq_multiCombinationViewBeforConstraint = make.top.mas_equalTo(beforView.mas_bottom).offset(self.space);
                        beforView.yq_multiCombinationViewNextConstraint = view.yq_multiCombinationViewBeforConstraint;
                    }else{
                        view.yq_multiCombinationViewBeforConstraint = make.top.mas_equalTo(@0);
                    }
                }];
            }
            
            beforView = view;
            
            [view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        }
        
        if (beforView) {
            if (pattern == YQMultiCombinationViewPattern_horizontal) { // 水平排列
                [beforView mas_makeConstraints:^(MASConstraintMaker *make) {
                    beforView.yq_multiCombinationViewNextConstraint = make.trailing.mas_equalTo(@0);
                }];
            }else{  // 纵向排列
                [beforView mas_makeConstraints:^(MASConstraintMaker *make) {
                    beforView.yq_multiCombinationViewNextConstraint = make.bottom.mas_equalTo(@0);
                }];
            }
        }
    }
    
    return self;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    BOOL oldValue = [[change valueForKey:NSKeyValueChangeOldKey] boolValue];
    BOOL newValue = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
    
    // 更新约束
    if (oldValue != newValue) {
        NSInteger index = [self.views indexOfObject:object];
        UIView *current = object;
        UIView *befor = nil;
        UIView *next = nil;
        for (NSInteger i = index + 1; i < self.views.count; i++) {
            UIView *view = [self.views yq_objectOrNilAtIndex:i];
            if (view && view.isHidden == NO) {
                next = view;
                break;
            }
        }
        for (NSInteger i = index - 1; i >= 0; i--) {
            UIView *view = [self.views yq_objectOrNilAtIndex:i];
            if (view && view.isHidden == NO) {
                befor = view;
                break;
            }
        }
        
        if (newValue) { // 如果现在隐藏，
            [current.yq_multiCombinationViewBeforConstraint uninstall];
            [current.yq_multiCombinationViewNextConstraint uninstall];
            current.yq_multiCombinationViewNextConstraint = nil;
            current.yq_multiCombinationViewBeforConstraint = nil;
            befor.yq_multiCombinationViewNextConstraint = nil;
            next.yq_multiCombinationViewBeforConstraint = nil;
            
            if (self.pattern == YQMultiCombinationViewPattern_horizontal) {
                if (befor) {
                    if (next) {
                        [next mas_makeConstraints:^(MASConstraintMaker *make) {
                            next.yq_multiCombinationViewBeforConstraint = make.leading.mas_equalTo(befor.mas_trailing).offset(self.space);
                            befor.yq_multiCombinationViewNextConstraint = next.yq_multiCombinationViewBeforConstraint;
                        }];
                    }else{
                        [befor mas_makeConstraints:^(MASConstraintMaker *make) {
                            befor.yq_multiCombinationViewNextConstraint = make.trailing.mas_equalTo(@0);
                        }];
                    }
                }else if (next){
                    [next mas_makeConstraints:^(MASConstraintMaker *make) {
                        next.yq_multiCombinationViewBeforConstraint = make.leading.mas_equalTo(@0);
                    }];
                }
            }else{
                if (befor) {
                    if (next) {
                        [next mas_makeConstraints:^(MASConstraintMaker *make) {
                            next.yq_multiCombinationViewBeforConstraint = make.top.mas_equalTo(befor.mas_bottom).offset(self.space);
                            befor.yq_multiCombinationViewNextConstraint = next.yq_multiCombinationViewBeforConstraint;
                        }];
                    }else{
                        [befor mas_makeConstraints:^(MASConstraintMaker *make) {
                            befor.yq_multiCombinationViewNextConstraint = make.bottom.mas_equalTo(@0);
                        }];
                    }
                }else if (next){
                    [next mas_makeConstraints:^(MASConstraintMaker *make) {
                        next.yq_multiCombinationViewBeforConstraint = make.top.mas_equalTo(@0);
                    }];
                }
            }
        }
    }
}

@end
