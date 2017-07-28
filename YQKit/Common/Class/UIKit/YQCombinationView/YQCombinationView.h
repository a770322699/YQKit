//
//  YQCombinationView.h
//  Demo
//
//  Created by maygolf on 17/3/27.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQIntrinsicContentSizeView.h"

typedef NS_ENUM(NSInteger, YQCombinationViewPattern) {
    YQCombinationViewPattern_horizontal,                    // 水平方向组合
    YQCombinationViewPattern_Vertical,                      // 垂直方向组合
};

typedef NS_ENUM(NSInteger, YQCombinationViewIntrinsicPriority) {
    YQCombinationViewIntrinsicPriority_leading,         // 前面的视图自身大小优先级高
    YQCombinationViewIntrinsicPriority_trainling,       // 后面视图的自身大小优先级高
};

typedef NS_ENUM(NSInteger, YQCombinationViewAlignment) {
    YQCombinationViewAlignment_center,                     // 居中对齐
    YQCombinationViewAlignment_leading,                    // 左对齐、上对齐
    YQCombinationViewAlignment_trailing,                   // 下对齐、右对齐
};

// 注意： 不能使用copy
// 组合视图，将两个视图居中对齐，组合在一起
@interface YQCombinationView : YQIntrinsicContentSizeView

@property (nonatomic, assign) YQCombinationViewPattern pattern; // 组合模式，默认：YQCombinationViewPattern_horizontal
@property (nonatomic, assign) YQCombinationViewIntrinsicPriority viewPriority; // 默认：YQCombinationViewIntrinsicPriority

@property (nonatomic, assign) CGFloat space; // 两个视图之间的间距, 默认为0
@property (nonatomic, assign) UIEdgeInsets contentInset; //

@property (nonatomic, assign) YQCombinationViewAlignment alignment; // 对齐方式

@property (nonatomic, readonly) UIView *leadingView;  // 前面的视图，上面的或者左边的
@property (nonatomic, readonly) UIView *trailingView;  // 后面的视图, 下面的或者右边的

- (instancetype)initWithLeadingView:(UIView *)leading trailingView:(UIView *)trailing NS_DESIGNATED_INITIALIZER;

@end
