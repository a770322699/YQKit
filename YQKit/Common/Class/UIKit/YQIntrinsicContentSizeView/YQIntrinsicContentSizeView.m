//
//  YQIntrinsicContentSizeView.m
//  Demo
//
//  Created by maygolf on 16/11/15.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQIntrinsicContentSizeView.h"

@implementation YQIntrinsicContentSizeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _customIntrinsicContentSize = CGSizeZero;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (CGSize)intrinsicContentSize{
    CGSize defaultIntrinsicContentSize = [super intrinsicContentSize];
    
    CGSize size = self.customIntrinsicContentSize;
    if (size.width == UIViewNoIntrinsicMetric) {
        size.width = defaultIntrinsicContentSize.width;
    }
    if (size.height == UIViewNoIntrinsicMetric) {
        size.height = defaultIntrinsicContentSize.height;
    }
    
    return size;
}

@end
