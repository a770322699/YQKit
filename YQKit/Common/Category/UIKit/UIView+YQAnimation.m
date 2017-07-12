//
//  UIView+YQAnimation.m
//  Demo
//
//  Created by maygolf on 2017/7/11.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQMacro.h"

#import "UIView+YQAnimation.h"

@implementation UIView (YQAnimation)

// 仿苹果抖动动画
- (void)yq_shakeStart{
    [self yq_shakeStartWithDuration:0.25 angle:5];
}
- (void)yq_shakeStartWithDuration:(NSTimeInterval)duration angle:(CGFloat)degrees{
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, YQRadian(- degrees));
    [UIView animateWithDuration:duration delay:0.0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) animations:^ {
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, YQRadian(degrees));
    } completion:nil];
}
- (void)yq_shakeStop{
    [UIView animateWithDuration:0.25 delay:0.0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear) animations:^ {
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
