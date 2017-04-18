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

struct YQIntPoint {
    NSInteger x;
    NSInteger y;
};
typedef struct YQIntPoint YQIntPoint;

static inline YQIntPoint
YQIntPointMake(NSInteger x, NSInteger y){
    YQIntPoint point; point.x = x; point.y = y; return point;
}

#endif /* YQStruct_h */
