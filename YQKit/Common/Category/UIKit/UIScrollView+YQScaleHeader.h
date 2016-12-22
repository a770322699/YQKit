//
//  UIScrollView+YQScaleHeader.h
//  Demo
//
//  Created by maygolf on 16/12/15.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (YQScaleHeader)

@property (nonatomic, strong) UIView *yq_scaleHeaderView;
@property (nonatomic, assign) CGFloat yq_scaleHeaderViewVisibleHeight;
@property (nonatomic, assign) CGFloat yq_scaleRatio;                            // 缩放系数,默认为1

@end
