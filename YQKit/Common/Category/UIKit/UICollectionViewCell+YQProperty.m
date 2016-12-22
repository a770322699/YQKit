//
//  UICollectionViewCell+YQProperty.m
//  Demo
//
//  Created by maygolf on 16/11/4.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <objc/runtime.h>

#import "UICollectionViewCell+YQProperty.h"

@implementation UICollectionViewCell (YQProperty)
@dynamic yq_selectBgImage, yq_bgImage, yq_bgColor, yq_selectBgColor;

#pragma mark - private
- (UIView *)yq_createBgView{
    return [[UIView alloc] init];
}

- (UIImageView *)yq_createBgImageView{
    return [[UIImageView alloc] init];
}

- (UIView *)yq_createSelectBgView{
    return [[UIView alloc] init];
}

- (UIImageView *)yq_createSelectBgImageView{
    return [[UIImageView alloc] init];
}

#pragma mark - getter
- (UIColor *)yq_selectBgColor{
    return self.selectedBackgroundView.backgroundColor;
}

- (UIColor *)yq_bgColor{
    return self.backgroundView.backgroundColor;
}

- (UIImage *)yq_bgImage{
    if ([self.backgroundView isKindOfClass:[UIImageView class]]) {
        return [(UIImageView *)self.backgroundView image];
    }
    return nil;
}

- (UIImage *)yq_selectBgImage{
    if ([self.selectedBackgroundView isKindOfClass:[UIImageView class]]) {
        return [(UIImageView *)self.selectedBackgroundView image];
    }
    return nil;
}

#pragma mark - setting
- (void)setYq_selectBgColor:(UIColor *)yq_selectBgColor{
    if (yq_selectBgColor) { // 有颜色
        if (self.selectedBackgroundView == nil) {
            self.selectedBackgroundView = [self yq_createSelectBgView];
        }
        self.selectedBackgroundView.backgroundColor = yq_selectBgColor;
    }else{  // 无颜色，有图片
        if (self.selectedBackgroundView && [self.selectedBackgroundView isKindOfClass:[UIImageView class]] && [(UIImageView *)self.selectedBackgroundView image]) {
            self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        }else{ // 无颜色，无图片
            self.selectedBackgroundView = nil;
        }
    }
}

- (void)setYq_bgColor:(UIColor *)yq_bgColor{
    if (yq_bgColor) {
        if (self.backgroundView == nil) {
            self.backgroundView = [self yq_createBgView];
        }
        self.backgroundView.backgroundColor = yq_bgColor;
    }else{
        if (self.backgroundView && [self.backgroundView isKindOfClass:[UIImageView class]] && [(UIImageView *)self.backgroundView image]) {
            self.backgroundView.backgroundColor = [UIColor clearColor];
        }else{
            self.backgroundView = nil;
        }
    }
}

- (void)setYq_bgImage:(UIImage *)yq_bgImage{
    if (!yq_bgImage) {  // 无图片
        if ((self.backgroundView && self.backgroundView.backgroundColor && ![self.backgroundView.backgroundColor isEqual:[UIColor clearColor]]) == NO) { // 无颜色
            self.backgroundView = nil;
        }
    }else{
        UIColor *color = nil;
        if (self.backgroundView == nil || ![self.backgroundView isKindOfClass:[UIImageView class]]) {
            color = self.backgroundView.backgroundColor ?: [UIColor clearColor];
            self.backgroundView = [self yq_createBgImageView];
        }
        self.backgroundView.backgroundColor = color;
        [(UIImageView *)self.backgroundView setImage:yq_bgImage];
    }
}

- (void)setYq_selectBgImage:(UIImage *)yq_selectBgImage{
    if (!yq_selectBgImage) {
        if ((self.selectedBackgroundView && self.selectedBackgroundView.backgroundColor && ![self.selectedBackgroundView.backgroundColor isEqual:[UIColor clearColor]]) == NO) {
            self.selectedBackgroundView = nil;
        }
    }else{
        UIColor *color = nil;
        if (self.selectedBackgroundView == nil || ![self.selectedBackgroundView isKindOfClass:[UIImageView class]]) {
            color = self.selectedBackgroundView.backgroundColor ?: [UIColor clearColor];
            self.selectedBackgroundView = [self yq_createSelectBgImageView];
        }
        self.selectedBackgroundView.backgroundColor = color;
        [(UIImageView *)self.selectedBackgroundView setImage:yq_selectBgImage];
    }
}

@end
