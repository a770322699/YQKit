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

@interface YQMultiCombinationView : YQIntrinsicContentSizeView

// 在调用改方法之前，views里面的view不能隐藏
- (instancetype)initWithViews:(NSArray<UIView *> *)views parttern:(YQMultiCombinationViewPattern)pattern space:(CGFloat)space;

@end
