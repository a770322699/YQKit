//
//  UIScrollView+YQEmptyDataSet.m
//  Demo
//
//  Created by maygolf on 17/4/18.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <objc/runtime.h>

#import "YQMacro.h"

#import "UIScrollView+YQEmptyDataSet.h"

#import "UIScrollView+EmptyDataSet.h"

static const char *kRuntimeSaveKey_text         = "kRuntimeSaveKey_yq_emptyText";
static const char *kRuntimeSaveKey_image        = "kRuntimeSaveKey_yq_emptyImage";
static const char *kRuntimeSaveKey_sholdDisplay = "kRuntimeSaveKey_yq_shouldDisplayEmpty";
static const char *kRuntimeSaveKey_delegate     = "kRuntimeSaveKey_yq_emptyDelegate";

@interface YQScrollerViewEmptyDataDelegate : NSObject<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@interface UIScrollView (YQEmptyDataSetProperty)

@property (nonatomic, strong) NSString *yq_emptyText;
@property (nonatomic, strong) UIImage *yq_emptyImage;

@property (nonatomic, strong) YQScrollerViewEmptyDataDelegate *yq_emptyDelegate;

@end

@implementation UIScrollView (YQEmptyDataSetProperty)

- (NSString *)yq_emptyText{
    return objc_getAssociatedObject(self, kRuntimeSaveKey_text);
}
- (void)setYq_emptyText:(NSString *)fj_emptyText{
    objc_setAssociatedObject(self, kRuntimeSaveKey_text, fj_emptyText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)yq_emptyImage{
    return objc_getAssociatedObject(self, kRuntimeSaveKey_image);
}
- (void)setYq_emptyImage:(UIImage *)fj_emptyImage{
    objc_setAssociatedObject(self, kRuntimeSaveKey_image, fj_emptyImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL *)yq_shouldDisplayEmpty{
    return [objc_getAssociatedObject(self, kRuntimeSaveKey_sholdDisplay) pointerValue];
}
- (void)setYq_shouldDisplayEmpty:(BOOL *)yq_shouldDisplayEmpty{
    objc_setAssociatedObject(self, kRuntimeSaveKey_sholdDisplay, [NSValue valueWithPointer:yq_shouldDisplayEmpty], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YQScrollerViewEmptyDataDelegate *)yq_emptyDelegate{
    YQScrollerViewEmptyDataDelegate *delegate = objc_getAssociatedObject(self, kRuntimeSaveKey_delegate);
    if (!delegate) {
        delegate = [[YQScrollerViewEmptyDataDelegate alloc] init];
        self.yq_emptyDelegate = delegate;
    }
    
    return delegate;
}
- (void)setYq_emptyDelegate:(YQScrollerViewEmptyDataDelegate *)yq_emptyDelegate{
    objc_setAssociatedObject(self, kRuntimeSaveKey_delegate, yq_emptyDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

/*YQEmptyDataSetProperty end*/
/**********************************************************************************************************/
/*YQScrollerViewEmptyDataDelegate star*/

@implementation YQScrollerViewEmptyDataDelegate

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    BOOL *shouldDisplay = scrollView.yq_shouldDisplayEmpty;
    return shouldDisplay ? *shouldDisplay : NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return scrollView.yq_emptyImage;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[UIFont systemFontOfSize:16.0] forKey:NSFontAttributeName];
    [attributes setObject:YQHexColor(0x333333) forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:scrollView.yq_emptyText attributes:attributes];
}

@end

/*YQScrollerViewEmptyDataDelegate end*/
/**********************************************************************************************************/
/*YQEmptyDataSet star*/

@implementation UIScrollView (YQEmptyDataSet)
@dynamic yq_shouldDisplayEmpty;

// 设置空白页
- (void)yq_setDefaultEmptyData{
    [self yq_setEmptyDataWithImage:nil text:@"暂无数据"];
}
- (void)yq_setEmptyDataWithImage:(UIImage *)image text:(NSString *)text{
    self.emptyDataSetSource = self.yq_emptyDelegate;
    self.emptyDataSetDelegate = self.yq_emptyDelegate;
    
    self.yq_emptyImage = image;
    self.yq_emptyText = text;
    
    [self reloadEmptyDataSet];
}

@end
