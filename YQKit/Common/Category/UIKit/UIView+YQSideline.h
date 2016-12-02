//
//  UIView+YQSideline.h
//  Demo
//
//  Created by maygolf on 16/11/7.
//  Copyright © 2016年 yiquan. All rights reserved.
//

// 分割线

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, YQViewSidelineOption) {
    YQViewSidelineOption_none   = 0,
    
    YQViewSidelineOption_min        = 1,
    YQViewSidelineOption_top        = YQViewSidelineOption_min,
    YQViewSidelineOption_left       = 1 << 1,
    YQViewSidelineOption_bottom     = 1 << 2,
    YQViewSidelineOption_right      = 1 << 3,
    YQViewSidelineOption_max        = YQViewSidelineOption_right,
};

@protocol YQViewSidelineDataSource <NSObject>

// 获取线宽,默认为0.5
- (CGFloat)sidelineWidthForView:(UIView *)view option:(YQViewSidelineOption)option;
// 获取线边距，上、下线只有左右边距有效，左、右线只有上下边距有效，默认为（0，0，0，0）
- (UIEdgeInsets)sidelineInsetsForView:(UIView *)view option:(YQViewSidelineOption)option;
// 获取线条颜色
- (UIColor *)sideColorForView:(UIView *)view option:(YQViewSidelineOption)option;

@end

@interface UIView (YQSideline)

@property (nonatomic, weak) id<YQViewSidelineDataSource> yq_sidelineDataSource;
@property (nonatomic, assign) YQViewSidelineOption yq_sideLineOption;

@end
