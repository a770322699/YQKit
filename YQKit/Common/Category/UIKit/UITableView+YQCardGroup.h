//
//  UITableView+YQCardGroup.h
//  Demo
//
//  Created by maygolf on 2017/7/13.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YQCardGroupDataSource <NSObject>

- (UIView *)tableView:(UITableView *)tableView cardViewForSection:(NSInteger)section;
- (CGFloat)cardViewLeftMarginForTableView:(UITableView *)tableView;
- (CGFloat)cardViewRightMarginForTableView:(UITableView *)tableView;

@end

@interface UITableView (YQCardGroup)

@property (nonatomic, weak) id<YQCardGroupDataSource> yq_cardGroupDataSource;

@end
