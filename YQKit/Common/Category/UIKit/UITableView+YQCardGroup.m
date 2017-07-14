//
//  UITableView+YQCardGroup.m
//  Demo
//
//  Created by maygolf on 2017/7/13.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+YQCardGroup.h"

static const char *kRuntimeSaveKey_property = "kRuntimeSaveKey_property";

@interface YQTableViewPropertyForCardGroup : NSObject

@property (nonatomic, weak) id<YQCardGroupDataSource> dataSource;

@property (nonatomic, assign) NSInteger visibleSectionMin; // 显示着的最小的section
@property (nonatomic, assign) NSInteger visibleSectionMax; // 显示着的最大的ssection

@end

@implementation YQTableViewPropertyForCardGroup

- (instancetype)init{
    if (self = [super init]) {
        self.visibleSectionMax = -1;
        self.visibleSectionMin = -1;
    }
    return self;
}


@end

@interface UITableView (YQCardGroupProperty)

@property (nonatomic, strong) YQTableViewPropertyForCardGroup *property;

@end

@implementation UITableView (YQCardGroupProperty)

- (YQTableViewPropertyForCardGroup *)property{
    YQTableViewPropertyForCardGroup *property = objc_getAssociatedObject(self, kRuntimeSaveKey_property);
    if (!property) {
        property = [[YQTableViewPropertyForCardGroup alloc] init];
        self.property = property;
    }
    
    return property;
}

- (void)setProperty:(YQTableViewPropertyForCardGroup *)property{
    objc_setAssociatedObject(self, kRuntimeSaveKey_property, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UITableView (YQCardGroup)

#pragma mark - getter
- (id<YQCardGroupDataSource>)yq_cardGroupDataSource{
    return self.property.dataSource;
}

#pragma mark - setting
- (void)setYq_cardGroupDataSource:(id<YQCardGroupDataSource>)yq_cardGroupDataSource{
    self.property.dataSource = yq_cardGroupDataSource;
}

#pragma mark - private
- (void)yq_updateSectionFrameData{
    NSArray<NSIndexPath *> *visibleIndexPaths = [self indexPathsForVisibleRows];
    
    if (!visibleIndexPaths.count) {
        return;
    }
    
    NSInteger minSection = [visibleIndexPaths firstObject].section;
    NSInteger maxSection = [visibleIndexPaths lastObject].section;
    
    if (minSection < self.property.visibleSectionMin) {
//        <#statements#>
    }
    
}

@end
