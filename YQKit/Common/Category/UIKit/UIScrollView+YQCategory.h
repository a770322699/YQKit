//
//  UIScrollView+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/11/15.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (YQCategory)

//contentInset
@property (nonatomic, assign) CGFloat yq_insetTop;
@property (nonatomic, assign) CGFloat yq_insetLeft;
@property (nonatomic, assign) CGFloat yq_insetBottom;
@property (nonatomic, assign) CGFloat yq_insetRight;
//contentOffset
@property (nonatomic, assign) CGFloat yq_offsetX;
@property (nonatomic, assign) CGFloat yq_offsetY;
//contentSize
@property (nonatomic, assign) CGFloat yq_contentWidth;
@property (nonatomic, assign) CGFloat yq_contentHeight;

- (CGPoint)yq_topContentOffset;
- (CGPoint)yq_leftContentOffset;
- (CGPoint)yq_bottomContentOffset;
- (CGPoint)yq_rightContentOffset;

- (void)yq_scrollToTop;
- (void)yq_scrollToLeft;
- (void)yq_scrollToBottom;
- (void)yq_scrollToRight;
- (void)yq_scrollToTopAnimated:(BOOL)animated;
- (void)yq_scrollToLeftAnimated:(BOOL)animated;
- (void)yq_scrollToBottomAnimated:(BOOL)animated;
- (void)yq_scrollToRightAnimated:(BOOL)animated;

@end
