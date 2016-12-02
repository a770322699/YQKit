//
//  UITableViewCell+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/11/7.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YQCategory_tableviewCell)

// 作为uitableViewCell的子视图时，在cell高亮时是否保持原有背景色
@property (nonatomic, assign) BOOL yq_keepBgColorWhenHilight;

@end

@interface UITableViewCell (YQCategory)

@end
