//
//  YQMultiCombinationView.h
//  Demo
//
//  Created by maygolf on 17/5/26.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQIntrinsicContentSizeView.h"

typedef NS_ENUM(NSInteger, YQMultiCombinationViewPattern) {
    YQMultiCombinationViewPattern_horizontal,                   // 水平方向组合
    YQMultiCombinationViewPattern_Vertical,                     // 垂直方向组合
};

typedef NS_ENUM(NSInteger, YQMultiCombinationViewAlignment) {
    YQMultiCombinationViewAlignment_center,                     // 居中对齐
    YQMultiCombinationViewAlignment_leading,                    // 左对齐、上对齐
    YQMultiCombinationViewAlignment_trailing,                   // 下对齐、右对齐
};

@interface YQMultiCombinationView : YQIntrinsicContentSizeView

@property (nonatomic, assign) YQMultiCombinationViewAlignment alignment; // 对齐方式，默认中心对齐

// 在调用改方法之前，views里面的view不能隐藏
- (instancetype)initWithViews:(NSArray<UIView *> *)views parttern:(YQMultiCombinationViewPattern)pattern space:(CGFloat)space;

@end
