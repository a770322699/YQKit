//
//  YQTestModelView.m
//  Demo
//
//  Created by maygolf on 16/12/30.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQTestModelView.h"
#import "YQCategory.h"

@implementation YQTestModelView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 100, 100)];
        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)show{
    [self showBegin:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.frame = self.superview.bounds;
        self.contentView.yq_maxX = 0;
        self.contentView.yq_maxY = 0;
    } end:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.contentView.yq_x = 100;
        self.contentView.yq_y = 100;
    }];
}
- (void)dismiss{
    [self dismissEnd:^{
        self.contentView.yq_maxX = 0;
        self.contentView.yq_maxY = 0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }];
}

@end
