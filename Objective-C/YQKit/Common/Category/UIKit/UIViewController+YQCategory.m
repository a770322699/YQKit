//
//  UIViewController+YQCategory.m
//  Demo
//
//  Created by maygolf on 16/11/16.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UIViewController+YQCategory.h"

@implementation UIViewController (YQCategory)

// 获取顶层presentedController
+ (UIViewController *)yq_topPresentedController{
    return [[UIApplication sharedApplication].keyWindow.rootViewController yq_topPresentedController];
}
// 获取某个控制器上的顶层presentedController
- (UIViewController *)yq_topPresentedController{
    if (self.presentedViewController) {
        return [self.presentedViewController yq_topPresentedController];
    }else{
        return self;
    }
}

@end
