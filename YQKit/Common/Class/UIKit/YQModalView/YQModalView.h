//
//  YQModalView.h
//  Demo
//
//  Created by maygolf on 16/12/30.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQModalView;
@protocol YQModalViewDelegate <NSObject>

- (void)modalViewWillShow:(YQModalView *)view;
- (void)modalViewDidShow:(YQModalView *)view;
- (void)modalViewWillDismiss:(YQModalView *)view;
- (void)modalViewDidDismiss:(YQModalView *)view;


@end

/**************************************************************************************/
/**************************************************************************************/

@interface YQModalView : UIView

@property (nonatomic, weak) id<YQModalViewDelegate> delegate;
@property (nonatomic, weak) UIView *fromView;                               // 从这个视图上弹出popView，默认为keyWindow
@property (nonatomic, strong) UIView *contentView;                          // 内容视图
@property (nonatomic, readonly) BOOL isShow;                                // 是否已经显示
@property (nonatomic, assign) BOOL dismissWhenTapBgView;                    // 点击背景区域时是否自动隐藏， 默认yes
@property (nonatomic, assign) NSTimeInterval duration;                      // 动画时间,默认0.25


/**
 显示

 @param beginBlock 执行动画之前调用，可以在此block种更新contentView、self的frame、背景色等
 @param endBlock   设置动画执行结果的显示效果
 */
- (void)showBegin:(void(^)())beginBlock end:(void(^)())endBlock;

/**
 隐藏

 @param endBlock 设置动画执行结果的显示效果
 */
- (void)dismissEnd:(void(^)())endBlock;

// 默认直接调用showBegin:nil end:nil
- (void)show;
// 默认直接调用dismissEnd:nil;
- (void)dismiss;

@end
