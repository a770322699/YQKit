//
//  UIView+YQLoading.h
//  Demo
//
//  Created by maygolf on 16/11/15.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YQLoadingStyle) {
    YQLoadingStyle_normal,
};

@protocol YQLoadingView <NSObject>

@optional
@property (nonatomic, strong) NSString *loadingText;

@required
@property (nonatomic, readonly) BOOL isLoading;

- (void)beginLoadingCompletion:(void(^)()) completion;
- (void)stopLoadingCompletion:(void(^)()) completion;

@end

// YQLoadingView end
//****************************************************************************************************************************//

//****************************************************************************************************************************//
// YQLoading   start

@interface UIView (YQLoading)

// 加载动画风格，当设置yq_loadingView后无效,若想在beginloading后更改，必须先设置yq_loadingView为nil
@property (nonatomic, assign) YQLoadingStyle yq_loadingStyle;
@property (nonatomic, strong) UIView<YQLoadingView> *yq_loadingView;
@property (nonatomic, assign) UIEdgeInsets yq_loadingViewInsets;

//#####!!!!!!!!!!
// 一下属性必须在yq_loadingStyle或者yq_loadingView确定以后设置才会生效
// 也就是说，若果yq_loadingStyle或者yq_loadingView不用默认值，一下属性必须在yq_loadingStyle、yq_loadingView之后设置，否则无效
@property (nonatomic, strong) NSString *yq_loadingText;
@property (nonatomic, readonly) BOOL yq_isLoading;
// 当正在加载时是否可以接受交互
@property (nonatomic, assign) BOOL yq_userInteractionEnabledWhenLoaing;

- (void)yq_beginLoading;
- (void)yq_stopLoading;

@end
