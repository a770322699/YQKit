//
//  UIView+YQCategory.m
//  Demo
//
//  Created by maygolf on 16/11/7.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UIView+YQCategory.h"

@implementation UIView (YQCategory)

- (UIViewController *)yq_viewController{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:UIViewController.class]) {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

// 返回子视图上的第一响应者，没有返回nil
- (UIView *)yq_firstResponseView{
    for ( UIView *childView in self.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [childView yq_firstResponseView];
        if ( result ) return result;
    }
    return nil;
}

// 递归查找所有子视图
- (NSArray<UIView *> *)yq_allSubviews{
    NSMutableArray *resultViews = [NSMutableArray array];
    for (UIView *subView in self.subviews) {
        [resultViews addObject:subView];
        NSArray *subViews = subView.yq_allSubviews;
        if (subViews) {
            [resultViews addObjectsFromArray:subView.yq_allSubviews];
        }
    }
    
    return resultViews.count ? resultViews : nil;
}

@end
