//
//  YQMarginLabel.h
//  Demo
//
//  Created by maygolf on 17/3/27.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQMarginView.h"

@interface YQMarginLabel : YQMarginView

@property (nonatomic, readonly) UILabel *contentLabel;

// 设置为圆角
- (void)makeRound;
- (void)makeRoundWithBoardColor:(UIColor *)color width:(CGFloat)width;

@end
