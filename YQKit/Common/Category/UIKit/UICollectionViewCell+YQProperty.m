//
//  UICollectionViewCell+YQProperty.m
//  Demo
//
//  Created by maygolf on 16/11/4.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <objc/runtime.h>

#import "UICollectionViewCell+YQProperty.h"

static const char *kRuntimeSaveKey_bgView   = "kRuntimeSaveKey_bgView";
static const char *kRunTimeSaveKey_selectedBgView   = "kRunTimeSaveKey_selectedBgView";

@interface UICollectionViewCell (YQPropertyPrivate)

@property (nonatomic, strong) UIView *yq_selectBgView;
@property (nonatomic, strong) UIView *yq_bgView;

@end

@implementation UICollectionViewCell (YQPropertyPrivate)

#pragma mark - getter
- (UIView *)yq_selectBgView{
    UIView *selectBgView = objc_getAssociatedObject(self, kRunTimeSaveKey_selectedBgView);
    if (selectBgView == nil) {
        selectBgView = [[UIView alloc] init];
        self.yq_selectBgView = selectBgView;
    }
    
    return selectBgView;
}

- (UIView *)yq_bgView{
    UIView *bgView = objc_getAssociatedObject(self, kRuntimeSaveKey_bgView);
    if (bgView == nil) {
        bgView = [[UIView alloc] init];
        self.yq_bgView = bgView;
    }
    
    return bgView;
}

#pragma mark - setting
- (void)setYq_selectBgView:(UIView *)yq_selectBgView{
    objc_setAssociatedObject(self, kRunTimeSaveKey_selectedBgView, yq_selectBgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setYq_bgView:(UIView *)yq_bgView{
    objc_setAssociatedObject(self, kRuntimeSaveKey_bgView, yq_bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

// YQPropertyPrivate end
//****************************************************************************************************************************//

//****************************************************************************************************************************//
// YQProperty   start

@implementation UICollectionViewCell (YQProperty)

#pragma mark - getter
- (UIColor *)yq_selectBgColor{
    return self.selectedBackgroundView.backgroundColor;
}

- (UIColor *)yq_bgColor{
    return self.backgroundView.backgroundColor;
}

#pragma mark - setting
- (void)setYq_selectBgColor:(UIColor *)yq_selectBgColor{
    if (yq_selectBgColor) {
        self.yq_selectBgView.backgroundColor = yq_selectBgColor;
        self.selectedBackgroundView = self.yq_selectBgView;
    }else{
        self.selectedBackgroundView = nil;
    }
}

- (void)setYq_bgColor:(UIColor *)yq_bgColor{
    if (yq_bgColor) {
        self.yq_bgView.backgroundColor = yq_bgColor;
        self.backgroundView = self.yq_bgView;
    }else{
        self.backgroundView = nil;
    }
}

@end
