//
//  UITableViewCell+YQCategory.m
//  Demo
//
//  Created by maygolf on 16/11/7.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <objc/runtime.h>
#import "YQGlobalValue.h"

#import "UITableViewCell+YQCategory.h"

static const char *kRuntimeSaveKey_keepBgColor              = "kRuntimeSaveKey_keepBgColor";
static const char *kRuntimeSaveKey_originalColor            = "kRuntimeSaveKey_originalColor";

@interface UIView (YQCategory_tableviewCell_private)

@property (nonatomic, strong) UIColor *yq_originalColor;

@end

@implementation UIView (YQCategory_tableviewCell_private)

- (UIColor *)yq_originalColor{
    return objc_getAssociatedObject(self, kRuntimeSaveKey_originalColor);
}

- (void)setYq_originalColor:(UIColor *)yq_originalColor{
    objc_setAssociatedObject(self, kRuntimeSaveKey_originalColor, yq_originalColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

// YQCategory_tableviewCell_private end
//****************************************************************************************************************************//

//****************************************************************************************************************************//
// YQCategory_tableviewCell   start


@implementation UIView (YQCategory_tableviewCell)

- (BOOL)yq_keepBgColorWhenHilight{
    return [objc_getAssociatedObject(self, kRuntimeSaveKey_keepBgColor) boolValue];
}

- (void)setYq_keepBgColorWhenHilight:(BOOL)yq_keepBgColorWhenHilight{
    objc_setAssociatedObject(self, kRuntimeSaveKey_keepBgColor, @(yq_keepBgColorWhenHilight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - private
- (void)setSubViewsOriginalColorForBgColor{
    if (self.yq_keepBgColorWhenHilight) {
        self.yq_originalColor = self.backgroundColor;
    }
    [self.subviews makeObjectsPerformSelector:@selector(setSubViewsOriginalColorForBgColor)];
}

- (void)setSubviewsBgColorForOriginalColor{
    if (self.yq_keepBgColorWhenHilight) {
        self.backgroundColor = self.yq_originalColor;
    }
    
    [self.subviews makeObjectsPerformSelector:@selector(setSubviewsBgColorForOriginalColor)];
}

@end

// YQCategory_tableviewCell   end
//****************************************************************************************************************************//

//****************************************************************************************************************************//
// YQCategory   start

@implementation UITableViewCell (YQCategory)

+ (void)load{
    YQSwizzle([self class], @selector(setHighlighted:animated:), @selector(yq_setHighlighted:animated:));
}

- (void)yq_setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (self.isHighlighted == 0 && highlighted) {
        [self.contentView setSubViewsOriginalColorForBgColor];
        [self yq_setHighlighted:highlighted animated:animated];
        [self.contentView setSubviewsBgColorForOriginalColor];
    }else{
        [self yq_setHighlighted:highlighted animated:animated];
    }
}

@end
