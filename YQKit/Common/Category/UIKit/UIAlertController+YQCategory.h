//
//  UIAlertController+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/12/20.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YQAlertAction)(UIAlertAction *action);

@interface UIAlertController (YQCategory)

+ (void)yq_showInfoAlertViewWithTitle:(NSString *)title message:(NSString *)message;
+ (void)yq_showAskAlertViewWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle action:(YQAlertAction)handle;

@end
