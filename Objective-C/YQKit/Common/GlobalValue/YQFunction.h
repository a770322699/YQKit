//
//  YQFunction.h
//  Demo
//
//  Created by maygolf on 16/11/4.
//  Copyright © 2016年 yiquan. All rights reserved.
//

// 比较复杂的全局函数

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

// 方法替换
void YQSwizzle(Class c, SEL origSEL, SEL newSEL);

// 判断某个矩形内是否包含某个点，boundary为是否含边界
BOOL YQRectIsContainPoint(CGRect aRect, CGPoint aPoint, BOOL boundary);
// 判断某个矩形内是否包含另一个矩形，boundary为是否含边界
BOOL YQRectIsContainOtherRect(CGRect aRect, CGRect otherRect, BOOL boundary);

/**
 定时器

 @param time        定时器运行的总时间（实际运行的时间可能略大于此时间）此值为0时一直执行
 @param timeSpace   执行处理的时间间隔
 @param handle      定时的操作处理(number:执行的次数, remainTime:剩余时间)
 @param completion  定时器执行完成
 
 @return 定时器
 */
dispatch_source_t YQTimerStart(NSTimeInterval time, NSTimeInterval timeSpace, void(^handle)(NSInteger number, NSTimeInterval remainTime), void(^completion)());
