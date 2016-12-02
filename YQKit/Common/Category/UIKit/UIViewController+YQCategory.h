//
//  UIViewController+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/11/16.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YQCategory)

// 获取顶层presentedController
+ (UIViewController *)yq_topPresentedController;
// 获取某个控制器上的顶层presentedController
- (UIViewController *)yq_topPresentedController;

@end
