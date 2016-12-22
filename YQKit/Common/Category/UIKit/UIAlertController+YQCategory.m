//
//  UIAlertController+YQCategory.m
//  Demo
//
//  Created by maygolf on 16/12/20.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UIAlertController+YQCategory.h"

#import "UIViewController+YQCategory.h"

@implementation UIAlertController (YQCategory)

+ (void)yq_showInfoAlertViewWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:action];
    
    [[UIViewController yq_topPresentedController] presentViewController:alertView animated:YES completion:nil];
}

+ (void)yq_showAskAlertViewWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle action:(YQAlertAction)handle{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handle) {
            handle(action);
        }
    }];
    [alertView addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    
    [[UIViewController yq_topPresentedController] presentViewController:alertView animated:YES completion:nil];
}

@end
