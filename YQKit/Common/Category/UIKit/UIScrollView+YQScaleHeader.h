//
//  UIScrollView+YQScaleHeader.h
//  Demo
//
//  Created by maygolf on 16/12/15.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

// 最大可滚动高度：O
// 缩放点的Y值：Y 即yq_scalePoint的y值
// 缩放因子：S，即yq_scaleRatio
// headerView的总高度：H
// 满足一下关系时，可实现在滚动到最大可滚动高度之前，顶部不出现空白
// 关系式：0/Y*S = H

@interface UIScrollView (YQScaleHeader)

@property (nonatomic, strong) UIView *yq_scaleHeaderView;
@property (nonatomic, assign) CGFloat yq_scaleHeaderViewVisibleHeight;
@property (nonatomic, assign) CGFloat yq_scaleRatio;                            // 缩放系数,默认为1
@property (nonatomic, assign) CGPoint yq_scalePoint;                            // 缩放点，取值为0~1，默认为（0.5， 0.5）

@end
