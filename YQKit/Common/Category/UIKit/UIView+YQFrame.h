//
//  UIView+YQFrame.h
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

// 注意！！！！！！
// 若要通过设置：yq_centerX/yq_centerY、yq_maxX/yq_MaxY、yq_center来确定视图的位置，必须确定其size

@interface UIView (YQFrame)

@property (nonatomic, assign) CGFloat yq_x;
@property (nonatomic, assign) CGFloat yq_y;
@property (nonatomic, assign) CGFloat yq_centerX;
@property (nonatomic, assign) CGFloat yq_centerY;
@property (nonatomic, assign) CGFloat yq_maxX;
@property (nonatomic, assign) CGFloat yq_maxY;

@property (nonatomic, assign) CGFloat yq_width;
@property (nonatomic, assign) CGFloat yq_height;

@property (nonatomic, assign) CGPoint yq_origin;
@property (nonatomic, assign) CGPoint yq_center;

@property (nonatomic, assign) CGSize yq_size;

@end
