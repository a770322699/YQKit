//
//  YQFunction.m
//  Demo
//
//  Created by maygolf on 16/11/4.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <objc/runtime.h>
#import "YQConst.h"

#import "YQFunction.h"

// 方法替换
void YQSwizzle(Class c, SEL origSEL, SEL newSEL){
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method newMethod = nil;
    if (!origMethod) {
        origMethod = class_getClassMethod(c, origSEL);
        if (!origMethod) {
            return;
        }
        newMethod = class_getClassMethod(c, newSEL);
        if (!newMethod) {
            return;
        }
    }else{
        newMethod = class_getInstanceMethod(c, newSEL);
        if (!newMethod) {
            return;
        }
    }
    
    //自身已经有了就添加不成功，直接交换即可
    if(class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
        class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, newMethod);
    }
}


// 判断某个矩形内是否包含某个点，boundary为是否含边界
BOOL YQRectIsContainPoint(CGRect aRect, CGPoint aPoint, BOOL boundary){
    if (boundary) {
        return aPoint.x >= aRect.origin.x && aPoint.x <= CGRectGetMaxX(aRect) && aPoint.y >= aRect.origin.y && aPoint.y <= CGRectGetMaxY(aRect);
    }else{
        return aPoint.x > aRect.origin.x && aPoint.x < CGRectGetMaxX(aRect) && aPoint.y > aRect.origin.y && aPoint.y < CGRectGetMaxY(aRect);
    }
}
// 判断某个矩形内是否包含另一个矩形，boundary为是否含边界
BOOL YQRectIsContainOtherRect(CGRect aRect, CGRect otherRect, BOOL boundary){
    CGPoint point1 = otherRect.origin;
    CGPoint point2 = CGPointMake(otherRect.origin.x + otherRect.size.width, otherRect.origin.y);
    CGPoint point3 = CGPointMake(otherRect.origin.x, otherRect.origin.y + otherRect.size.height);
    CGPoint point4 = CGPointMake(otherRect.origin.x + otherRect.size.width, otherRect.origin.y + otherRect.size.height);
    
    return
    YQRectIsContainPoint(aRect, point1, boundary)
    && YQRectIsContainPoint(aRect, point2, boundary)
    && YQRectIsContainPoint(aRect, point3, boundary)
    && YQRectIsContainPoint(aRect, point4, boundary);
}

// 定时器
dispatch_source_t YQTimerStart(NSTimeInterval time, NSTimeInterval timeSpace, void(^handle)(NSInteger number, NSTimeInterval remainTime), void(^completion)()){
    __block NSTimeInterval remainTime = time;
    __block NSInteger number = 0;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, kYQDispatchGlobalQueue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), timeSpace * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (time > 0 && remainTime <= 0) {
            dispatch_source_cancel(timer);
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        }else{
            if (handle) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    handle(number, remainTime);
                });
            }
            number++;
            remainTime = remainTime - timeSpace;
        }
    });
    
    dispatch_resume(timer);
    
    return timer;
}
