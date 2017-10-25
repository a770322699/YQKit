//
//  UIScrollView+YQEmptyDataSet.h
//  Demo
//
//  Created by maygolf on 17/4/18.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (YQEmptyDataSet)

// 是否应该显示空白页
@property (nonatomic, assign) BOOL *yq_shouldDisplayEmpty;

// 设置空白页
- (void)yq_setDefaultEmptyData;
- (void)yq_setEmptyDataWithImage:(UIImage *)image text:(NSString *)text;

@end
