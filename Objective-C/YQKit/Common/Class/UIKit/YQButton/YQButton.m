//
//  YQButton.m
//  Demo
//
//  Created by meizu on 2017/12/1.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQButton.h"
#import "UIView+YQFrame.h"

@interface YQButton ()

@property (nonatomic, assign) CGSize layoutTitleSize;
@property (nonatomic, assign) CGSize layoutImageSize;
@property (nonatomic, assign) YQButtonStyle layoutStyle;
@property (nonatomic, assign) UIEdgeInsets layoutContentInsets;
@property (nonatomic, assign) CGFloat layoutContentSpace;

@end

@implementation YQButton

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize titleSize = self.titleLabel.yq_size;
    CGSize imageSize = self.imageView.yq_size;
    
    CGFloat space = self.contentSpace;
    if (titleSize.width == 0 || titleSize.height == 0 || imageSize.width == 0 || imageSize.height == 0) {
        space = 0;
    }
    
    BOOL layouted =
    self.layoutStyle == self.contentStyle
    && UIEdgeInsetsEqualToEdgeInsets(self.layoutContentInsets, self.contentInsets)
    && CGSizeEqualToSize(self.layoutTitleSize, titleSize)
    && CGSizeEqualToSize(self.layoutTitleSize, titleSize)
    && self.layoutContentSpace == space;
    if (layouted) {
        return;
    }

    self.layoutImageSize = imageSize;
    self.layoutTitleSize = titleSize;
    self.layoutStyle = self.contentStyle;
    self.layoutContentInsets = self.contentInsets;
    self.layoutContentSpace = space;
    
    switch (self.contentStyle) {
        case YQButtonStyle_leftRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, - space / 2, 0, space / 2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, space / 2, 0, - space / 2);
            self.contentEdgeInsets = UIEdgeInsetsMake(self.contentInsets.top, space / 2 + self.contentInsets.left, self.contentInsets.bottom, space / 2 + self.contentInsets.right);
            break;

        case YQButtonStyle_rightLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + space / 2, 0, - titleSize.width - space / 2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width - space / 2, 0, imageSize.width + space / 2);
            self.contentEdgeInsets = UIEdgeInsetsMake(self.contentInsets.top, space / 2 + self.contentInsets.left, self.contentInsets.bottom, space / 2 + self.contentInsets.right);
            break;

        case YQButtonStyle_upDown:{
            CGFloat imageOffsetY = (titleSize.height + space) / 2;
            CGFloat imageOffsetX = titleSize.width / 2;
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            
            CGFloat titleOffsetY = (imageSize.height + space) / 2;
            CGFloat titleOffsetX = imageSize.width / 2;
            self.titleEdgeInsets = UIEdgeInsetsMake(titleOffsetY, -titleOffsetX, -titleOffsetY, titleOffsetX);
            
            CGFloat contentOffsetY = (titleSize.height + imageSize.height + space - MAX(titleSize.height, imageSize.height))  / 2;
            CGFloat contentOffsetX = (titleSize.width + imageSize.width - MAX(titleSize.width, imageSize.width)) / 2;
            self.contentEdgeInsets = UIEdgeInsetsMake(contentOffsetY + self.contentInsets.top, -contentOffsetX + self.contentInsets.left, contentOffsetY + self.contentInsets.bottom, -contentOffsetX + self.contentInsets.right);
            
            break;
        }

        case YQButtonStyle_downUp:{
            CGFloat imageOffsetY = (titleSize.height + space) / 2;
            CGFloat imageOffsetX = titleSize.width / 2;
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            
            CGFloat titleOffsetY = (imageSize.height + space) / 2;
            CGFloat titleOffsetX = imageSize.width / 2;
            self.titleEdgeInsets = UIEdgeInsetsMake(-titleOffsetY, -titleOffsetX, titleOffsetY, titleOffsetX);
            
            CGFloat contentOffsetY = (titleSize.height + imageSize.height + space - MAX(titleSize.height, imageSize.height))  / 2;
            CGFloat contentOffsetX = (titleSize.width + imageSize.width - MAX(titleSize.width, imageSize.width)) / 2;
            self.contentEdgeInsets = UIEdgeInsetsMake(contentOffsetY + self.contentInsets.top, -contentOffsetX + self.contentInsets.left, contentOffsetY + self.contentInsets.bottom, -contentOffsetX + self.contentInsets.right);
            
            break;
        }

        default:
            break;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
