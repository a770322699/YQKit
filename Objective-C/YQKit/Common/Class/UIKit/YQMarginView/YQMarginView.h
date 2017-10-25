//
//  YQMarginView.h
//  Demo
//
//  Created by maygolf on 17/3/27.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

// 在内容视图与当前视图之间添加4个边距约束
@interface YQMarginView : UIView

@property (nonatomic, strong) UIView *contentView;  // 内容视图
@property (nonatomic, assign) UIEdgeInsets contenMargin; // 内容边距

@end
