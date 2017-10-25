//
//  YQValue.h
//  Demo
//
//  Created by Yiquan Ma on 2017/4/15.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YQStruct.h"

@interface YQValue : NSValue

- (instancetype)initWithIntPoint:(YQIntPoint)point;
+ (instancetype)valueWithIntPoint:(YQIntPoint)point;
- (instancetype)intPointValueWithOffsetIntPoint:(YQIntPoint)offsetPoint;
- (YQIntPoint)intPoint;

- (instancetype)initWithIntSize:(YQIntSize)size;
+ (instancetype)valueWithIntSize:(YQIntSize)size;
- (YQIntSize)intSize;

@end
