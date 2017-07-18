//
//  UITableView+YQCardGroup.m
//  Demo
//
//  Created by maygolf on 2017/7/13.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+YQFrame.h"
#import "YQFunction.h"
#import "UITableView+YQCardGroup.h"

static const char *kRuntimeSaveKey_property = "kRuntimeSaveKey_yq_tableViewGroupCard_property";
static const char *kRuntimeSaveKey_viewCard = "kRuntimeSaveKey_yq_tableViewGroupCard";

static const NSInteger kYQTableViewGroupCardUndisplaySection = -1;

@class YQTableViewGroupCard;
@interface UIView (YQTableViewGroupCard)

@property (nonatomic, weak) YQTableViewGroupCard *yq_tableViewGroupCard;

@end

@implementation UIView (YQTableViewGroupCard)

- (void)setYq_tableViewGroupCard:(YQTableViewGroupCard *)yq_tableViewGroupCard{
    objc_setAssociatedObject(self, kRuntimeSaveKey_viewCard, yq_tableViewGroupCard, OBJC_ASSOCIATION_ASSIGN);
}

- (YQTableViewGroupCard *)yq_tableViewGroupCard{
    return objc_getAssociatedObject(self, kRuntimeSaveKey_viewCard);
}

@end

@interface YQTableViewGroupCard : NSObject

// 所属section，显示着的才有效， 否则为kYQTableViewGroupCardUndisplaySection
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, strong) UIView *cardView;

@end

@implementation YQTableViewGroupCard

- (instancetype)init{
    if (self = [super init]) {
        self.section = kYQTableViewGroupCardUndisplaySection;
    }
    return self;
}

- (void)setCardView:(UIView *)cardView{
    _cardView = cardView;
    cardView.yq_tableViewGroupCard = self;
}

@end

typedef NSMutableDictionary<NSNumber *, YQTableViewGroupCard *> *YQTableViewDisplayingCards;
typedef NSMutableDictionary<NSString *, NSMutableArray<YQTableViewGroupCard *> *> * YQTableViewUndisplayCards;

@interface YQTableViewPropertyForCardGroup : NSObject

@property (nonatomic, weak) id<YQCardGroupDataSource> dataSource;

@property (nonatomic, assign) NSInteger visibleSectionMin; // 显示着的最小的section
@property (nonatomic, assign) NSInteger visibleSectionMax; // 显示着的最大的ssection

// 显示着的卡片
@property (nonatomic, strong) YQTableViewDisplayingCards displayings;
// 队列中未显示的卡片
@property (nonatomic, strong) YQTableViewUndisplayCards undisplayCards;
// 注册过的类
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *registedClassDic;

@end

@implementation YQTableViewPropertyForCardGroup

- (instancetype)init{
    if (self = [super init]) {
        self.visibleSectionMax = -1;
        self.visibleSectionMin = -1;
        
        _displayings = [NSMutableDictionary dictionary];
        _undisplayCards = [NSMutableDictionary dictionary];
        _registedClassDic = [NSMutableDictionary dictionary];
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

+ (void)load{
    YQSwizzle([UITableView class], @selector(layoutSubviews), @selector(yq_layoutSubViews));
    YQSwizzle([UITableView class], @selector(reloadData), @selector(yq_groupCardReloadData));
    YQSwizzle([UITableView class], @selector(endUpdates), @selector(yq_groupCardEndUpdates));
}

- (void)yq_groupCardReloadData{
    [self yq_groupCardReloadData];
    
    if (self.yq_cardGroupDataSource) {
        [self yq_reloadGroupCard];
    }
}

- (void)yq_groupCardEndUpdates{
    [self yq_groupCardEndUpdates];
    
    if (self.yq_cardGroupDataSource) {
        [self yq_reloadGroupCard];
    }
}

- (void)yq_layoutSubViews{
    [self yq_layoutSubViews];
    
    if (self.yq_cardGroupDataSource) {
        [self yq_updateGroupCardFrame];
    }
}

#pragma mark - getter
- (id<YQCardGroupDataSource>)yq_cardGroupDataSource{
    return self.property.dataSource;
}

- (UIView *)yq_wrapperView{
    return [self valueForKey:@"_wrapperView"];
}

#pragma mark - setting
- (void)setYq_cardGroupDataSource:(id<YQCardGroupDataSource>)yq_cardGroupDataSource{
    
    if (!yq_cardGroupDataSource) {
        [self yq_removeAllCardView];
    }
    
    self.property.dataSource = yq_cardGroupDataSource;
}

#pragma mark - private
- (void)yq_removeCardViewForSection:(NSInteger)section{
    NSNumber *key = @(section);
    YQTableViewGroupCard *card = [self.property.displayings objectForKey:key];
    if (!card) {
        return;
    }
    
    [card.cardView removeFromSuperview];
    [self.property.displayings removeObjectForKey:key];
    card.section = kYQTableViewGroupCardUndisplaySection;
    
    if (!card.reuseIdentifier) {
        return;
    }
    
    NSMutableArray *undisplayings = [self.property.undisplayCards objectForKey:card.reuseIdentifier];
    if (!undisplayings) {
        undisplayings = [NSMutableArray array];
        [self.property.undisplayCards setObject:undisplayings forKey:card.reuseIdentifier];
    }
    [undisplayings addObject:card];
}

- (void)yq_removeCardViewForRange:(NSRange)range{
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {
        [self yq_removeCardViewForSection:i];
    }
}

- (void)yq_removeAllCardView{
    NSArray *displaySections = [self.property.displayings allKeys];
    for (NSNumber *section in displaySections) {
        [self yq_removeCardViewForSection:[section integerValue]];
    }
    
    self.property.visibleSectionMin = -1;
    self.property.visibleSectionMax = -1;
}

- (void)yq_addCardViewForSection:(NSInteger)section{
    
    [self yq_removeCardViewForSection:section];
    
    UIView *cardView = nil;
    if (self.yq_cardGroupDataSource && [self.yq_cardGroupDataSource respondsToSelector:@selector(tableView:cardViewForSection:)]) {
        cardView = [self.yq_cardGroupDataSource tableView:self cardViewForSection:section];
    }
    
    if (!cardView) {
        return;
    }
    
    if (!cardView.yq_tableViewGroupCard) {
        YQTableViewGroupCard *card = [[YQTableViewGroupCard alloc] init];
        card.cardView = cardView;
    }
    
    [self insertSubview:cardView atIndex:0];
    
    YQTableViewGroupCard *card = cardView.yq_tableViewGroupCard;
    card.section = section;
    [self.property.displayings setObject:card forKey:@(section)];
    
    NSMutableArray *undisplayCads = nil;
    if (card.reuseIdentifier) {
        undisplayCads = [self.property.undisplayCards objectForKey:card.reuseIdentifier];
    }
    if (undisplayCads && [undisplayCads containsObject:card]) {
        [undisplayCads removeObject:card];
    }
}

- (void)yq_addCardViewForRange:(NSRange)range{
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {
        [self yq_addCardViewForSection:i];
    }
}

- (void)yq_updateGroupCardFrame{
    
    CGFloat leftMargin = 0;
    CGFloat rightMargin = 0;
    if (self.yq_cardGroupDataSource && [self.yq_cardGroupDataSource respondsToSelector:@selector(cardViewLeftMarginForTableView:)]) {
        leftMargin = [self.yq_cardGroupDataSource cardViewLeftMarginForTableView:self];
    }
    if (self.yq_cardGroupDataSource && [self.yq_cardGroupDataSource respondsToSelector:@selector(cardViewRightMarginForTableView:)]) {
        rightMargin = [self.yq_cardGroupDataSource cardViewRightMarginForTableView:self];
    }
    
    [self yq_wrapperView].yq_x = leftMargin;
    [self yq_wrapperView].yq_width = self.yq_width - leftMargin - rightMargin;
    
    if (self.property.visibleSectionMax == -1 || self.property.visibleSectionMin == -1) {
        return;
    }
    for (NSInteger i = self.property.visibleSectionMin; i <= self.property.visibleSectionMax; i++) {
        UIView *cardView = [self.property.displayings objectForKey:@(i)].cardView;
        CGRect sectionRect = [self rectForSection:i];
        CGRect headerRect = [self rectForHeaderInSection:i];
        CGRect footerRect = [self rectForFooterInSection:i];
        cardView.frame = CGRectMake(leftMargin, sectionRect.origin.y + headerRect.size.height, self.yq_width - leftMargin - rightMargin, sectionRect.size.height - headerRect.size.height - footerRect.size.height);
    }
    
    for (UITableViewCell *cell in [self visibleCells]) {
        cell.yq_width = self.yq_width - leftMargin - rightMargin;
    }
}

- (void)yq_reloadGroupCard{
    NSArray<NSIndexPath *> *visibleIndexPaths = [self indexPathsForVisibleRows];
    
    if (!visibleIndexPaths.count) {
        [self yq_removeAllCardView];
        
        return;
    }
    
    NSInteger minSection = [visibleIndexPaths firstObject].section;
    NSInteger maxSection = [visibleIndexPaths lastObject].section;
    
    if (self.property.visibleSectionMin == -1 && self.property.visibleSectionMax == -1) {   // 第一次
        [self yq_addCardViewForRange:NSMakeRange(minSection, maxSection - minSection + 1)];
    }else{
        if (minSection < self.property.visibleSectionMin) {
            [self yq_addCardViewForRange:NSMakeRange(minSection, self.property.visibleSectionMin - minSection)];
        }else if (minSection > self.property.visibleSectionMin){
            [self yq_removeCardViewForRange:NSMakeRange(self.property.visibleSectionMin, minSection - self.property.visibleSectionMin)];
        }
        
        if (maxSection < self.property.visibleSectionMax) {
            [self yq_removeCardViewForRange:NSMakeRange(maxSection + 1, self.property.visibleSectionMax - maxSection)];
        }else if (maxSection > self.property.visibleSectionMax){
            [self yq_addCardViewForRange:NSMakeRange(self.property.visibleSectionMax + 1, maxSection - self.property.visibleSectionMax)];
        }
    }
    
    self.property.visibleSectionMin = minSection;
    self.property.visibleSectionMax = maxSection;
    
    // 更新坐标
    [self yq_updateGroupCardFrame];
}

#pragma mark - public
- (UIView *)yq_dequeueReusableGroupCardViewWithIdentifier:(NSString *)reuseIdentifier section:(NSInteger)section{
    NSMutableArray *cards = [self.property.undisplayCards objectForKey:reuseIdentifier];
    if (!cards) {
        cards = [NSMutableArray array];
        [self.property.undisplayCards setObject:cards forKey:reuseIdentifier];
    }
    
    YQTableViewGroupCard *card = [cards firstObject];
    if (!card) {
        card = [[YQTableViewGroupCard alloc] init];
        card.reuseIdentifier = reuseIdentifier;
        
        Class viewClass = NULL;
        NSString *viewClassString = [self.property.registedClassDic objectForKey:reuseIdentifier];
        if (viewClassString) {
            viewClass = NSClassFromString(viewClassString);
        }
        
        if (!viewClass) {
            NSLog(@"waring: no regist class, default use UIView");
            viewClass = [UIView class];
        }
        
        UIView *view = [[viewClass alloc] init];
        if (![view isKindOfClass:[UIView class]]) {
            NSLog(@"waring: no regist class, default use UIView");
            view = [[UIView alloc] init];
        }
        
        card.cardView = view;
        
        [cards addObject:card];
    }
    
    return card.cardView;
}

- (void)yq_registerClass:(Class)viewClass forGroupCardViewReuseIdentifier:(NSString *)reuseIdentifier{
    
    NSString *classString = viewClass ? NSStringFromClass(viewClass) : nil;
    [self.property.registedClassDic setValue:classString forKey:reuseIdentifier];
}

@end
