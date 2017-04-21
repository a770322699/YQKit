//
//  YQValue.m
//  Demo
//
//  Created by Yiquan Ma on 2017/4/15.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQValue.h"

@interface YQValue ()

@property (nonatomic, assign) YQIntPoint point;
@property (nonatomic, assign) YQIntSize size;

@end

@implementation YQValue

#pragma mark - public
- (instancetype)initWithIntPoint:(YQIntPoint)point{
    if (self = [super init]) {
        self.point = point;
    }
    return self;
}
+ (instancetype)valueWithIntPoint:(YQIntPoint)point{
    return [[self alloc] initWithIntPoint:point];
}
- (instancetype)intPointValueWithOffsetIntPoint:(YQIntPoint)offsetPoint{
    YQValue *pointValue = [YQValue valueWithIntPoint:self.point];
    YQIntPoint point = YQIntPointMake(pointValue.point.x + offsetPoint.x, pointValue.point.y + offsetPoint.y);
    pointValue.point = point;
    
    return pointValue;
}
- (YQIntPoint)intPoint{
    return self.point;
}

- (instancetype)initWithIntSize:(YQIntSize)size{
    if (self = [super init]) {
        self.size = size;
    }
    return self;
}
+ (instancetype)valueWithIntSize:(YQIntSize)size{
    return [[self alloc] initWithIntSize:size];
}
- (YQIntSize)intSize{
    return self.size;
}

@end
