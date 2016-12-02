//
//  UIView+YQFrame.m
//  Demo
//
//  Created by maygolf on 16/11/10.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UIView+YQFrame.h"

@implementation UIView (YQFrame)

- (CGFloat)yq_x{
    return self.yq_origin.x;
}
- (void)setYq_x:(CGFloat)yq_x{
    self.frame = CGRectMake(yq_x, self.yq_y, self.yq_width, self.yq_height);
}

- (CGFloat)yq_y{
    return self.yq_origin.y;
}
- (void)setYq_y:(CGFloat)yq_y{
    self.frame = CGRectMake(self.yq_x, yq_y, self.yq_width, self.yq_height);
}

- (CGFloat)yq_centerX{
    return self.yq_x + self.yq_width / 2.0;
}
- (void)setYq_centerX:(CGFloat)yq_centerX{
    self.yq_x = yq_centerX - self.yq_width / 2.0;
}

- (CGFloat)yq_centerY{
    return self.yq_y + self.yq_height / 2.0;
}
- (void)setYq_centerY:(CGFloat)yq_centerY{
    self.yq_y = yq_centerY - self.yq_height / 2.0;
}

- (CGFloat)yq_maxX{
    return self.yq_x + self.yq_width;
}
- (void)setYq_maxX:(CGFloat)yq_maxX{
    self.yq_x = yq_maxX - self.yq_width;
}

- (CGFloat)yq_maxY{
    return self.yq_y + self.yq_height;
}
- (void)setYq_maxY:(CGFloat)yq_maxY{
    self.yq_y = yq_maxY - self.yq_height;
}

- (CGFloat)yq_width{
    return self.yq_size.width;
}
- (void)setYq_width:(CGFloat)yq_width{
    self.frame = CGRectMake(self.yq_x, self.yq_y, yq_width, self.yq_height);
}

- (CGFloat)yq_height{
    return self.yq_size.height;
}
- (void)setYq_height:(CGFloat)yq_height{
    self.frame = CGRectMake(self.yq_x, self.yq_y, self.yq_width, yq_height);
}

- (CGPoint)yq_origin{
    return self.frame.origin;
}
- (void)setYq_origin:(CGPoint)yq_origin{
    self.frame = CGRectMake(yq_origin.x, yq_origin.y, self.yq_width, self.yq_height);
}

- (CGPoint)yq_center{
    return CGPointMake(self.yq_centerX, self.yq_centerY);
}
- (void)setYq_center:(CGPoint)yq_center{
    self.yq_centerX = yq_center.x;
    self.yq_centerY = yq_center.y;
}

- (CGSize)yq_size{
    return self.frame.size;
}
- (void)setYq_size:(CGSize)yq_size{
    self.frame = CGRectMake(self.yq_x, self.yq_y, yq_size.width, yq_size.height);
}

@end
