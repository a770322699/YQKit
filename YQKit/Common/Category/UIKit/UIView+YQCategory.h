//
//  UIView+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/11/7.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YQCategory)

@property (nonatomic, readonly) UIViewController *yq_viewController;
@property (nonatomic, readonly) UIView *yq_firstResponseView;                  
@property (nonatomic, readonly) NSArray<UIView *> *yq_allSubviews;        // 递归查找所有子视图

@end
