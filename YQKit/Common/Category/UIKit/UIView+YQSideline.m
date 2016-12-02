//
//  UIView+YQSideline.m
//  Demo
//
//  Created by maygolf on 16/11/7.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "Masonry.h"
#import <objc/runtime.h>
#import "YQGlobalValue.h"

#import "UIView+YQSideline.h"

static const char *kRuntimeSaveKey_sidelines    = "kRuntimeSaveKey_sidelines";
static const char *kRuntimeSaveKey_option       = "kRuntimeSaveKey_option";
static const char *kRuntimeSaveKey_dataSource   = "kRuntimeSaveKey_dataSource";

static const NSInteger kLineColorDefault        = 0xe2e2e2;
static const CGFloat kLineWidthDefault          = 0.5;

#define kLineInsetsDefault UIEdgeInsetsZero

@interface UIView (YQSidelinePrivate)

@property (nonatomic, strong) NSMutableDictionary *yq_sidelines;

@end

@implementation UIView (YQSidelinePrivate)

- (void)setYq_sidelines:(NSMutableDictionary *)yq_sidelines{
    objc_setAssociatedObject(self, kRuntimeSaveKey_sidelines, yq_sidelines, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)yq_sidelines{
    NSMutableDictionary *sidelines = objc_getAssociatedObject(self, kRuntimeSaveKey_sidelines);
    if (sidelines == nil) {
        sidelines = [NSMutableDictionary dictionary];
    }
    self.yq_sidelines = sidelines;
    return sidelines;
}

@end

// YQSidelinePrivate end
//****************************************************************************************************************************//

//****************************************************************************************************************************//
// YQSideline   start

@implementation UIView (YQSideline)

#pragma mark - getter
- (YQViewSidelineOption)yq_sideLineOption{
    return [objc_getAssociatedObject(self, kRuntimeSaveKey_option) integerValue];
}

-(id<YQViewSidelineDataSource>)yq_sidelineDataSource{
    return objc_getAssociatedObject(self, kRuntimeSaveKey_dataSource);
}

#pragma mark - setting
- (void)setYq_sideLineOption:(YQViewSidelineOption)yq_sideLineOption{
    objc_setAssociatedObject(self, kRuntimeSaveKey_option, @(yq_sideLineOption), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSInteger j = 0;
    for (NSInteger i = YQViewSidelineOption_min; i <= YQViewSidelineOption_max; j++, i = 1 << j) {
        [self yq_updateSedeLineWithOption:i];
    }
}

- (void)setYq_sidelineDataSource:(id<YQViewSidelineDataSource>)yq_sidelineDataSource{
    objc_setAssociatedObject(self, kRuntimeSaveKey_dataSource, yq_sidelineDataSource, OBJC_ASSOCIATION_ASSIGN);
    self.yq_sideLineOption = self.yq_sideLineOption;
}

#pragma mark - private
- (void)yq_updateSedeLineWithOption:(YQViewSidelineOption)option{
    BOOL hasLine = option & self.yq_sideLineOption;
    UIView *line = self.yq_sidelines[@(option)];
    if (hasLine) {
        line.hidden = NO;
        
        if (line == nil) {
            line = [[UIView alloc] init];
            line.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        if (line.superview != self) {
            [self addSubview:line];
        }
        
        UIColor *lineColor = YQHexColor(kLineColorDefault);
        if (self.yq_sidelineDataSource && [self.yq_sidelineDataSource respondsToSelector:@selector(sideColorForView:option:)]) {
            lineColor = [self.yq_sidelineDataSource sideColorForView:self option:option];
        }
        line.backgroundColor = lineColor;
        
        UIEdgeInsets lineInsets = kLineInsetsDefault;
        if (self.yq_sidelineDataSource && [self.yq_sidelineDataSource respondsToSelector:@selector(sidelineInsetsForView:option:)]) {
            lineInsets = [self.yq_sidelineDataSource sidelineInsetsForView:self option:option];
        }
        
        CGFloat lineWidth = kLineWidthDefault;
        if (self.yq_sidelineDataSource && [self.yq_sidelineDataSource respondsToSelector:@selector(sidelineWidthForView:option:)]) {
            lineWidth = [self.yq_sidelineDataSource sidelineWidthForView:self option:option];
        }
        
        switch (option) {
            case YQViewSidelineOption_top:
                [line mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(@0);
                    make.height.mas_equalTo(@(lineWidth));
                    make.leading.mas_equalTo(@(lineInsets.left));
                    make.trailing.mas_equalTo(@(-lineInsets.right));
                }];
                break;
            case YQViewSidelineOption_bottom:
                [line mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(@0);
                    make.height.mas_equalTo(@(lineWidth));
                    make.leading.mas_equalTo(@(lineInsets.left));
                    make.trailing.mas_equalTo(@(-lineInsets.right));
                }];
                break;
            case YQViewSidelineOption_left:
                [line mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(@0);
                    make.width.mas_equalTo(@(lineWidth));
                    make.top.mas_equalTo(@(lineInsets.top));
                    make.bottom.mas_equalTo(@(- lineInsets.bottom));
                }];
                break;
            case YQViewSidelineOption_right:
                [line mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.trailing.mas_equalTo(@0);
                    make.width.mas_equalTo(@(lineWidth));
                    make.top.mas_equalTo(@(lineInsets.top));
                    make.bottom.mas_equalTo(@(- lineInsets.bottom));
                }];
                break;
                
            default:
                break;
        }
        
    }else{
        line.hidden = YES;
    }
}

@end
