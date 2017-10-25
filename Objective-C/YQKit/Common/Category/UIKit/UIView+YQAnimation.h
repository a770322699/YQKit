//
//  UIView+YQAnimation.h
//  Demo
//
//  Created by maygolf on 2017/7/11.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YQAnimation)

// 仿苹果抖动动画
- (void)yq_shakeStart;
- (void)yq_shakeStartWithDuration:(NSTimeInterval)duration angle:(CGFloat)degrees;
- (void)yq_shakeStop;

@end
