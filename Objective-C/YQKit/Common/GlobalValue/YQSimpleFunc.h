//
//  YQSimpleFunc.h
//  Demo
//
//  Created by maygolf on 16/11/4.
//  Copyright © 2016年 yiquan. All rights reserved.
//

// 简单的函数，静态inline函数

#ifndef YQSimpleFunc_h
#define YQSimpleFunc_h

#import <UIKit/UIKit.h>

// 通过一个原点和一个size创建一个rect
static inline CGRect YQRectMakeOriginSize(CGPoint origin, CGSize size){
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

#endif /* YQSimpleFunc_h */
