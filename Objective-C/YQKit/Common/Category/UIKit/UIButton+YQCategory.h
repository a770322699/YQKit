//
//  UIButton+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/11/11.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YQImagePosition) {
    YQImagePositionLeft,    //图片在左，文字在右，默认
    YQImagePositionRight,   //图片在右，文字在左
    YQImagePositionTop,     //图片在上，文字在下
    YQImagePositionBottom,  //图片在下，文字在上
    
};

@interface UIButton (YQCategory)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */

- (void)yq_setImagePosition:(YQImagePosition)postion spacing:(CGFloat)spacing;

@end
