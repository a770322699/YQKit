//
//  YQImageTextView.h
//  Demo
//
//  Created by maygolf on 17/3/27.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQCombinationView.h"

static const CGFloat kYQImageTextViewSpaceDefault = 4.0;

typedef NS_ENUM(NSInteger, YQImageTextViewStyle) {
    YQImageTextViewStyle_normal,                    // 图片在前，文字在后
    YQImageTextViewStyle_reverse,                   // 文字在前，图片在后
};

@interface YQImageTextView : YQCombinationView

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel *label;
@property (nonatomic, readonly) YQImageTextViewStyle style; // 默认为：YQImageTextViewStyle_normal

- (instancetype)initWithStyle:(YQImageTextViewStyle)style;

@end
