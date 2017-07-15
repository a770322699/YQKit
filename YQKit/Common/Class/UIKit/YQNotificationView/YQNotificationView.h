//
//  YQNotificationView.h
//  Demo
//
//  Created by maygolf on 17/5/4.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YQIntrinsicContentSizeView.h"

@interface YQNotificationView : YQIntrinsicContentSizeView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) NSTimeInterval displayDuration;

- (void)show;
+ (void)showNotificationWithTitle:(NSString *)title
                             desc:(NSString *)desc
                            image:(UIImage *)image;

+ (void)showNotificationWithTitle:(NSString *)title
                             desc:(NSString *)desc
                            image:(UIImage *)image
                animationDuration:(NSTimeInterval)animationDuration
                  displayDuration:(NSTimeInterval)displayDuration;

@end
