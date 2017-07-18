//
//  YQTableView.m
//  TableViewTest
//
//  Created by maygolf on 2017/7/13.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQTableView.h"

#import "UIView+YQFrame.h"
#import "UITableView+YQCardGroup.h"

@implementation YQTableView

//- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
//    if (self = [super initWithFrame:frame style:style]) {
//        [self addObserver:self forKeyPath:@"_wrapperView.frame" options:NSKeyValueObservingOptionNew context:NULL];
//        UIView *wrapperView = [self valueForKey:@"_wrapperView"];
//        NSLog(@"%@", wrapperView);
//        
//        CGRect frame = wrapperView.frame;
//        frame.origin.x = 30;
//        frame.size.width = 260;
//        wrapperView.frame = frame;
//    }
//    return self;
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    [self yq_updateGroupCardFrame];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    
//    UIView *wrapperView = [self valueForKey:@"_wrapperView"];
//    if (wrapperView.frame.size.width != 260) {
//        CGRect frame = wrapperView.frame;
//        frame.origin.x = 30;
//        frame.size.width = 260;
//        wrapperView.frame = frame;
//    }
//    
//    if (object == self && [keyPath isEqualToString:@"_wrapperView"]) {
//        UIView *wrapperView = [self valueForKey:@"_wrapperView"];
//        CGRect frame = wrapperView.frame;
//        frame.origin.x = 30;
//        frame.size.width = 260;
//        wrapperView.frame = frame;
//    }
//}

@end
