//
//  YQStruct.h
//  Demo
//
//  Created by Yiquan Ma on 2017/4/15.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#ifndef YQStruct_h
#define YQStruct_h

struct YQIntSize {
    NSInteger width;
    NSInteger height;
};
typedef struct YQIntSize YQIntSize;

static inline YQIntSize
YQIntSizeMake(NSInteger width, NSInteger height){
    YQIntSize size; size.width = width; size.height = height; return size;
}

static inline BOOL
YQIntSizeIsEqual(YQIntSize first, YQIntSize second){
    return first.width == second.width && first.height == second.height;
}

struct YQIntPoint {
    NSInteger x;
    NSInteger y;
};
typedef struct YQIntPoint YQIntPoint;

static inline YQIntPoint
YQIntPointMake(NSInteger x, NSInteger y){
    YQIntPoint point; point.x = x; point.y = y; return point;
}

static inline BOOL
YQIntPointIsEqual(YQIntPoint first, YQIntPoint second){
    return first.x == second.x && first.y == second.y;
}

#endif /* YQStruct_h */
