//
//  UIScrollView+YQCategory.m
//  Demo
//
//  Created by maygolf on 16/11/15.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UIScrollView+YQCategory.h"

@implementation UIScrollView (YQCategory)

//contentInset
- (void)setYq_insetTop:(CGFloat)yq_insetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = yq_insetTop;
    self.contentInset = inset;
}

- (CGFloat)yq_insetTop {
    return self.contentInset.top;
}

- (void)setYq_insetLeft:(CGFloat)yq_insetLeft {
    UIEdgeInsets inset = self.contentInset;
    inset.left = yq_insetLeft;
    self.contentInset = inset;
}

- (CGFloat)yq_insetLeft {
    return self.contentInset.left;
}

- (void)setYq_insetBottom:(CGFloat)yq_insetBottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = yq_insetBottom;
    self.contentInset = inset;
}

- (CGFloat)yq_insetBottom {
    return self.contentInset.bottom;
}

- (void)setYq_insetRight:(CGFloat)yq_insetRight {
    UIEdgeInsets inset = self.contentInset;
    inset.right = yq_insetRight;
    self.contentInset = inset;
}

- (CGFloat)yq_insetRight {
    return self.contentInset.right;
}

//contentOffset
- (void)setYq_offsetX:(CGFloat)yq_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = yq_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)yq_offsetX {
    return self.contentOffset.x;
}

- (void)setYq_offsetY:(CGFloat)yq_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = yq_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)yq_offsetY {
    return self.contentOffset.y;
}

//contentSize
- (void)setYq_contentWidth:(CGFloat)yq_contentWidth {
    CGSize contentSize = self.contentSize;
    contentSize.width = yq_contentWidth;
    self.contentSize = contentSize;
}

- (CGFloat)yq_contentWidth {
    return self.contentSize.width;
}

- (void)setYq_contentHeight:(CGFloat)yq_contentHeight {
    CGSize contentSize = self.contentSize;
    contentSize.height = yq_contentHeight;
    self.contentSize = contentSize;
}

- (CGFloat)yq_contentHeight {
    return self.contentSize.height;
}


- (CGPoint)yq_topContentOffset {
    return CGPointMake(0.f, -self.yq_insetTop);
}

- (CGPoint)yq_leftContentOffset {
    return CGPointMake(-self.yq_insetLeft, 0.f);
}

- (CGPoint)yq_bottomContentOffset {
    return CGPointMake(0.f, self.yq_contentHeight - self.bounds.size.height + self.yq_insetBottom);
}

- (CGPoint)yq_rightContentOffset {
    return CGPointMake(self.yq_contentWidth - self.bounds.size.width + self.yq_insetRight, 0.f);
}

- (void)yq_scrollToTop {
    [self yq_scrollToTopAnimated:YES];
}

- (void)yq_scrollToLeft {
    [self yq_scrollToLeftAnimated:YES];
}

- (void)yq_scrollToBottom {
    [self yq_scrollToBottomAnimated:YES];
}

- (void)yq_scrollToRight {
    [self yq_scrollToRightAnimated:YES];
}

- (void)yq_scrollToTopAnimated:(BOOL)animated {
    [self setContentOffset:[self yq_topContentOffset] animated:animated];
}

- (void)yq_scrollToLeftAnimated:(BOOL)animated {
    [self setContentOffset:[self yq_leftContentOffset] animated:animated];
}

- (void)yq_scrollToBottomAnimated:(BOOL)animated {
    [self setContentOffset:[self yq_bottomContentOffset] animated:animated];
}

- (void)yq_scrollToRightAnimated:(BOOL)animated {
    [self setContentOffset:[self yq_rightContentOffset] animated:animated];
}

@end
