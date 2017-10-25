//
//  UIScrollView+YQScaleHeader.m
//  Demo
//
//  Created by maygolf on 16/12/15.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+YQFrame.h"
#import "YQFunction.h"

#import "UIScrollView+YQScaleHeader.h"

@interface YQScaleHeaderObserver : NSObject

@property (nonatomic, weak) UIScrollView *targetView;
@property (nonatomic, strong, readonly) NSString *observerKeyPath;

@end

@implementation YQScaleHeaderObserver

#pragma mark - getter
- (NSString *)observerKeyPath{
    return NSStringFromSelector(@selector(contentOffset));
}

#pragma mark - public
- (void)addObserverTarget:(UIScrollView *)view{
    [view addObserver:self forKeyPath:self.observerKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    self.targetView = view;
}

- (void)removeObserverTarget{
    [self.targetView removeObserver:self forKeyPath:self.observerKeyPath];
    self.targetView = nil;
}

#pragma mark - KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    CGPoint point = [change[NSKeyValueChangeNewKey] CGPointValue];
    CGFloat offset = point.y + self.targetView.contentInset.top;
    if (offset < 0) {
        CGFloat scale = 0;
        if (self.targetView.bounds.size.height) {
            scale = -offset / self.targetView.bounds.size.height;
        }else{
            scale = -offset / [UIScreen mainScreen].bounds.size.height;
        }
        scale = scale * self.targetView.yq_scaleRatio;
        self.targetView.yq_scaleHeaderView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 + scale, 1 + scale);
    }else{
        self.targetView.yq_scaleHeaderView.transform = CGAffineTransformIdentity;
    }
}

@end

/***************************************************************************************************************/
/***************************************************************************************************************/

static const char *kRuntimeSaveKey_scaleObserve = "kRuntimeSaveKey_scaleObserve";
static const char *kRuntimeSaveKey_scaleHeaderBgView = "kRuntimeSaveKey_scaleHeaderBgView";
static const char *kRuntimeSaveKey_scaleHeaderViewFrame = "kRuntimeSaveKey_scaleHeaderViewFrame";

@interface UIScrollView (YQScaleHeaderPrivate)

@property (nonatomic, strong) YQScaleHeaderObserver *yq_scaleObserve;
@property (nonatomic, strong) UIView *yq_scaleHeaderBgView;

@property (nonatomic, assign) CGRect yq_scaleHeaderViewFrame;   // 相对于scrollerView的frame

@end

@implementation UIScrollView (YQScaleHeaderPrivate)

- (void)setYq_scaleObserve:(YQScaleHeaderObserver *)yq_scaleObserve{
    objc_setAssociatedObject(self, kRuntimeSaveKey_scaleObserve, yq_scaleObserve, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YQScaleHeaderObserver *)yq_scaleObserve{
    YQScaleHeaderObserver *observer = objc_getAssociatedObject(self, kRuntimeSaveKey_scaleObserve);
    if (!observer) {
        observer = [[YQScaleHeaderObserver alloc] init];
        self.yq_scaleObserve = observer;
    }
    return observer;
}

- (void)setYq_scaleHeaderBgView:(UIView *)yq_scaleHeaderBgView{
    objc_setAssociatedObject(self, kRuntimeSaveKey_scaleHeaderBgView, yq_scaleHeaderBgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)yq_scaleHeaderBgView{
    return objc_getAssociatedObject(self, kRuntimeSaveKey_scaleHeaderBgView);
}

- (void)setYq_scaleHeaderViewFrame:(CGRect)yq_scaleHeaderViewFrame{
    objc_setAssociatedObject(self, kRuntimeSaveKey_scaleHeaderViewFrame, [NSValue valueWithCGRect:yq_scaleHeaderViewFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)yq_scaleHeaderViewFrame{
    return [objc_getAssociatedObject(self, kRuntimeSaveKey_scaleHeaderViewFrame) CGRectValue];
}

@end

/***************************************************************************************************************/
/***************************************************************************************************************/

static const char *kRuntimeSaveKey_headerView = "kRuntimeSaveKey_headerView";
static const char *kRuntimeSaveKey_scaleHeaderViewVisibleHeight = "kRuntimeSaveKey_scaleHeaderViewVisibleHeight";
static const char *kRuntimeSaveKey_scaleRatio = "kRuntimeSaveKey_scaleRatio";
static const char *kRuntimeSaveKey_scalePoint = "kRuntimeSaveKey_scalePoint";
static const char *kRuntimeSaveKey_swizzledDealloc = "kRuntimeSaveKey_swizzledDeallocForScaleHeader";

@implementation UIScrollView (YQScaleHeader)

#pragma mark - getter and setting
- (void)setYq_scaleHeaderViewVisibleHeight:(CGFloat)yq_scaleHeaderViewVisibleHeight{
    self.contentInset = UIEdgeInsetsMake(yq_scaleHeaderViewVisibleHeight, self.contentInset.left, self.contentInset.bottom, self.contentInset.right);
    objc_setAssociatedObject(self, kRuntimeSaveKey_scaleHeaderViewVisibleHeight, @(yq_scaleHeaderViewVisibleHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)yq_scaleHeaderViewVisibleHeight{
    return [objc_getAssociatedObject(self, kRuntimeSaveKey_scaleHeaderViewVisibleHeight) floatValue];
}

- (void)setYq_scaleHeaderView:(UIView *)yq_scaleHeaderView{
    
    // 交换delloc方法
    BOOL swizzled = [objc_getAssociatedObject(self.class, kRuntimeSaveKey_swizzledDealloc) boolValue];
    if (!swizzled) {
        YQSwizzle([self class], NSSelectorFromString(@"dealloc"), @selector(yq_deallocForScaleHeaderPrivate));
        objc_setAssociatedObject(self.class, kRuntimeSaveKey_swizzledDealloc, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 移除原来的视图
    if (self.yq_scaleHeaderView && self.yq_scaleHeaderView != yq_scaleHeaderView) {
        [self.yq_scaleHeaderView removeFromSuperview];
    }
    
    // 移除原来的监听
    [self.yq_scaleObserve removeObserverTarget];
    
    
    if (yq_scaleHeaderView) {
        // 添加监听
        [self.yq_scaleObserve addObserverTarget:self];
        
        // 创建背景视图
        if (self.yq_scaleHeaderBgView == nil) {
            self.yq_scaleHeaderBgView = ({
                UIView *bgView = [[UIView alloc] init];
                bgView.backgroundColor = [UIColor clearColor];
                bgView.clipsToBounds = YES;
                [self insertSubview:bgView atIndex:0];
                
                bgView;
            });
        }
        
        if (yq_scaleHeaderView.superview != self.yq_scaleHeaderBgView) {
            [self.yq_scaleHeaderBgView addSubview:yq_scaleHeaderView];
        }
        
        // 存储原始frame
        self.yq_scaleHeaderViewFrame = yq_scaleHeaderView.frame;
    }
    
    objc_setAssociatedObject(self, kRuntimeSaveKey_headerView, yq_scaleHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 更新缩放点
    [self yq_updateHeaderViewScalePoint];
}

- (UIView *)yq_scaleHeaderView{
    return objc_getAssociatedObject(self, kRuntimeSaveKey_headerView);
}

- (void)setYq_scaleRatio:(CGFloat)yq_scaleRatio{
    objc_setAssociatedObject(self, kRuntimeSaveKey_scaleRatio, @(yq_scaleRatio), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)yq_scaleRatio{
    CGFloat scaleRatio = [objc_getAssociatedObject(self, kRuntimeSaveKey_scaleRatio) floatValue];
    if (scaleRatio <= 0) {
        scaleRatio = 1;
        self.yq_scaleRatio = scaleRatio;
    }
    return scaleRatio;
}

- (void)setYq_scalePoint:(CGPoint)yq_scalePoint{
    objc_setAssociatedObject(self, kRuntimeSaveKey_scalePoint, [NSValue valueWithCGPoint:yq_scalePoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self yq_updateHeaderViewScalePoint];
}

- (CGPoint)yq_scalePoint{
    NSValue *pointValue = objc_getAssociatedObject(self, kRuntimeSaveKey_scalePoint);
    CGPoint point = [pointValue CGPointValue];
    
    // 值不正确，或者没有设置过
    if (point.x < 0 || point.y < 0 || point.x > 1 || point.y > 1 || pointValue == nil) {
        point = CGPointMake(0.5, 0.5);
        self.yq_scalePoint = point;
    }
    
    return point;
}

#pragma mark - private
// 更新缩放点
- (void)yq_updateHeaderViewScalePoint{
    if (self.yq_scaleHeaderView == nil || self.yq_scaleHeaderBgView == nil) {
        return;
    }
    
    // 更新bgview的frame
    self.yq_scaleHeaderBgView.yq_width = self.yq_width;
    self.yq_scaleHeaderBgView.yq_height = self.yq_scaleHeaderView.yq_height * (1 - self.yq_scalePoint.y) + self.yq_scaleHeaderView.yq_height * self.yq_scalePoint.y * 2;
    self.yq_scaleHeaderBgView.yq_y = -self.yq_scaleHeaderBgView.yq_height;
    self.yq_scaleHeaderBgView.yq_x = 0;
    
    // 更新headerView的位置
    self.yq_scaleHeaderView.yq_x = self.yq_scaleHeaderViewFrame.origin.x - self.yq_scaleHeaderBgView.yq_x;
    self.yq_scaleHeaderView.yq_y = self.yq_scaleHeaderViewFrame.origin.y - self.yq_scaleHeaderBgView.yq_y;
    
    // 更新锚点
    CGFloat centerX = self.yq_scalePoint.x * self.yq_scaleHeaderView.yq_width + self.yq_scaleHeaderView.yq_x;
    CGFloat centerY = self.yq_scalePoint.y * self.yq_scaleHeaderView.yq_height + self.yq_scaleHeaderView.yq_y;
    self.yq_scaleHeaderView.layer.anchorPoint = self.yq_scalePoint;
    self.yq_scaleHeaderView.center = CGPointMake(centerX, centerY);
}

// 交换的delloc方法
- (void)yq_deallocForScaleHeaderPrivate{
    // 不能直接调用[self.yq_scaleObserve removeObserverTarget];因为此时self.yq_scaleObserve.targetView已经为nil
    YQScaleHeaderObserver *observer = objc_getAssociatedObject(self, kRuntimeSaveKey_scaleObserve);
    if (observer) {
        [self removeObserver:observer forKeyPath:observer.observerKeyPath];
    }
    
    [self yq_deallocForScaleHeaderPrivate];
}

@end
