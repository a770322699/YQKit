//
//  YQButton.h
//  Demo
//
//  Created by meizu on 2017/12/1.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YQButtonStyle) {
    YQButtonStyle_leftRight,        // image在左，title在右
    YQButtonStyle_rightLeft,        // image在右， title在左
    YQButtonStyle_upDown,           // image在上， title在下
    YQButtonStyle_downUp,           // image在下， title在上
};

@interface YQButton : UIButton

@property (nonatomic, assign) YQButtonStyle contentStyle;
@property (nonatomic, assign) CGFloat contentSpace;                      // image和title的距离
@property (nonatomic, assign) UIEdgeInsets contentInsets;               // 内容边缘

@end
