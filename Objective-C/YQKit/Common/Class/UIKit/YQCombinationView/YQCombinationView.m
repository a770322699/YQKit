//
//  YQCombinationView.m
//  Demo
//
//  Created by maygolf on 17/3/27.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "Masonry.h"

#import "YQCombinationView.h"

@interface YQCombinationView ()

@property (nonatomic, strong) UIView *leadingView;  // 前面的视图，上面的或者左边的
@property (nonatomic, strong) UIView *trailingView;  // 后面的视图, 下面的或者右边的

@property (nonatomic, strong) YQIntrinsicContentSizeView *contentView;

@property (nonatomic, strong) MASConstraint *spaceConstraint;
@property (nonatomic, strong) NSMutableArray<MASConstraint *> *constraints;  // 所有的约束

@property (nonatomic, strong) MASConstraint *contentInsetConstraint;

@end

@implementation YQCombinationView

- (void)dealloc{
    // 移除监听
    [self.leadingView removeObserver:self forKeyPath:@"hidden"];
    [self.trailingView removeObserver:self forKeyPath:@"hidden"];
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithLeadingView:nil trailingView:nil];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self initWithLeadingView:nil trailingView:nil];
}

- (instancetype)initWithLeadingView:(UIView *)leading trailingView:(UIView *)trailing{
    if (self = [super initWithFrame:CGRectZero]) {
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.contentInsetConstraint = make.edges.mas_equalTo(self.contentInset);
        }];
        
        _constraints = [NSMutableArray array];
        
        _leadingView = leading;
        [self.contentView addSubview:leading];
        
        _trailingView = trailing;
        [self.contentView addSubview:trailing];
        
        // 更新约束
        [self updateCustomConstraint];
        self.viewPriority = YQCombinationViewIntrinsicPriority_leading;
        
        // 添加监听，当有视图隐藏时需要更新约束
        [leading addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        [trailing addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

#pragma mark - getter
- (YQIntrinsicContentSizeView *)contentView{
    if (!_contentView) {
        _contentView = [[YQIntrinsicContentSizeView alloc] init];
    }
    return _contentView;
}

#pragma mark - setting
- (void)setContentInset:(UIEdgeInsets)contentInset{
    _contentInset = contentInset;
    
    [self.contentInsetConstraint setInsets:contentInset];
}

- (void)setPattern:(YQCombinationViewPattern)pattern{
    if (_pattern != pattern) {
        _pattern = pattern;
        
        // 更新约束
        [self updateCustomConstraint];
    }
}

- (void)setAlignment:(YQCombinationViewAlignment)alignment{
    if (_alignment != alignment) {
        _alignment = alignment;
        
        [self updateCustomConstraint];
    }
}

- (void)setSpace:(CGFloat)space{
    _space = space;
    [self.spaceConstraint setOffset:space];
}

- (void)setViewPriority:(YQCombinationViewIntrinsicPriority)viewPriority{
    _viewPriority = viewPriority;
    
    UIView *highView = nil;
    UIView *lowView = nil;
    if (viewPriority == YQCombinationViewIntrinsicPriority_leading) {
        highView = self.leadingView;
        lowView = self.trailingView;
    }else{
        highView = self.trailingView;
        lowView = self.leadingView;
    }
    
    if (highView && lowView) {
        UILayoutPriority lowHuggingH = [lowView contentHuggingPriorityForAxis:UILayoutConstraintAxisHorizontal];
        UILayoutPriority lowHuggingV = [lowView contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical];
        UILayoutPriority lowCompressionH = [lowView contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal];
        UILayoutPriority lowCompressionV = [lowView contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisVertical];
        
        UILayoutPriority highHuggingH = [highView contentHuggingPriorityForAxis:UILayoutConstraintAxisHorizontal];
        UILayoutPriority highHuggingV = [highView contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical];
        UILayoutPriority highCompressionH = [highView contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal];
        UILayoutPriority highCompressionV = [highView contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisVertical];
        
        NSInteger offset = 5;
        UILayoutPriority priorityMax = 1000;
        UILayoutPriority priorityMin = 0;
        if (lowHuggingH >= highHuggingH) {
            if (lowHuggingH + offset <= priorityMax) {
                [highView setContentHuggingPriority:lowHuggingH + offset forAxis:UILayoutConstraintAxisHorizontal];
            }else if (highHuggingH - offset >= priorityMin){
                [lowView setContentHuggingPriority:highHuggingH - offset forAxis:UILayoutConstraintAxisHorizontal];
            }
        }
        if (lowHuggingV >= highHuggingV) {
            if (lowHuggingV + offset <= priorityMax) {
                [highView setContentHuggingPriority:lowHuggingV + offset forAxis:UILayoutConstraintAxisVertical];
            }else if (highHuggingV - offset >= priorityMin){
                [lowView setContentHuggingPriority:highHuggingV - offset forAxis:UILayoutConstraintAxisVertical];
            }
        }
        if (lowCompressionH >= highCompressionH) {
            if (lowCompressionH + offset <= priorityMax) {
                [highView setContentCompressionResistancePriority:lowCompressionH + offset forAxis:UILayoutConstraintAxisHorizontal];
            }else if (highCompressionH - offset >= priorityMin){
                [lowView setContentCompressionResistancePriority:highCompressionH - offset forAxis:UILayoutConstraintAxisHorizontal];
            }
        }
        
        if (lowCompressionV >= highCompressionV) {
            if (lowCompressionV + offset <= priorityMax) {
                [highView setContentCompressionResistancePriority:lowCompressionV + offset forAxis:UILayoutConstraintAxisVertical];
            }else if (highCompressionV - offset >= priorityMin){
                [lowView setContentCompressionResistancePriority:highCompressionV - offset forAxis:UILayoutConstraintAxisVertical];
            }
        }
    }
}

#pragma mark - private
// 更新约束
- (void)updateCustomConstraint{
    
    // 移除原来的约束
    [self.constraints makeObjectsPerformSelector:@selector(uninstall)];
    [self.constraints removeAllObjects];
    
    // 若只有一个视图
    UIView *onlyView = nil;
    NSArray *constraints = nil;
    
    // 判断视图是否可见
    BOOL(^isVisible)(UIView *) = ^BOOL(UIView *view){
        return view && view.isHidden == NO;
    };
    
    if (self.pattern == YQCombinationViewPattern_horizontal) {  // 水平排列
        if (isVisible(self.leadingView)) {
            if (isVisible(self.trailingView)) {    // 两个视图都存在
                constraints = [self.leadingView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_lessThanOrEqualTo(self);
                    make.leading.mas_equalTo(@0);
                    switch (self.alignment) {
                        case YQCombinationViewAlignment_center:
                            make.centerY.mas_equalTo(self);
                            break;
                            
                        case YQCombinationViewAlignment_leading:
                            make.top.mas_equalTo(@0);
                            break;
                            
                        case YQCombinationViewAlignment_trailing:
                            make.bottom.mas_equalTo(@0);
                            break;
                            
                        default:
                            break;
                    }
                }];
                [self.constraints addObjectsFromArray:constraints];
                
                constraints = [self.trailingView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.mas_equalTo(@0);
                    self.spaceConstraint = make.leading.mas_equalTo(self.leadingView.mas_trailing).offset(self.space);
                    make.height.mas_lessThanOrEqualTo(self);
                    switch (self.alignment) {
                        case YQCombinationViewAlignment_center:
                            make.centerY.mas_equalTo(self);
                            break;
                            
                        case YQCombinationViewAlignment_leading:
                            make.top.mas_equalTo(@0);
                            break;
                            
                        case YQCombinationViewAlignment_trailing:
                            make.bottom.mas_equalTo(@0);
                            break;
                            
                        default:
                            break;
                    }
                }];
                [self.constraints addObjectsFromArray:constraints];
            }else{  // 只有一个前面的视图
                onlyView = self.leadingView;
            }
        }else if (isVisible(self.trailingView)){   // 只有一个后面的视图
            onlyView = self.trailingView;
        }
        
        if (onlyView) { // 只有一个视图
            constraints = [onlyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.and.trailing.mas_equalTo(@0);
                make.height.mas_lessThanOrEqualTo(self);
                switch (self.alignment) {
                    case YQCombinationViewAlignment_center:
                        make.centerY.mas_equalTo(self);
                        break;
                        
                    case YQCombinationViewAlignment_leading:
                        make.top.mas_equalTo(@0);
                        break;
                        
                    case YQCombinationViewAlignment_trailing:
                        make.bottom.mas_equalTo(@0);
                        break;
                        
                    default:
                        break;
                }
            }];
            [self.constraints addObjectsFromArray:constraints];
        }
    }else{  // 纵向排列
        if (isVisible(self.leadingView)) {
            if (isVisible(self.trailingView)) {   // 两个视图都存在
                constraints = [self.leadingView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(@0);
                    make.width.mas_lessThanOrEqualTo(self);
                    switch (self.alignment) {
                        case YQCombinationViewAlignment_center:
                            make.centerX.mas_equalTo(self);
                            break;
                            
                        case YQCombinationViewAlignment_leading:
                            make.leading.mas_equalTo(@0);
                            break;
                            
                        case YQCombinationViewAlignment_trailing:
                            make.trailing.mas_equalTo(@0);
                            break;
                            
                        default:
                            break;
                    }
                }];
                [self.constraints addObjectsFromArray:constraints];
                
                constraints = [self.trailingView mas_makeConstraints:^(MASConstraintMaker *make) {
                    self.spaceConstraint = make.top.mas_equalTo(self.leadingView.mas_bottom).offset(self.space);
                    make.bottom.mas_equalTo(@0);
                    make.width.mas_lessThanOrEqualTo(self);
                    switch (self.alignment) {
                        case YQCombinationViewAlignment_center:
                            make.centerX.mas_equalTo(self);
                            break;
                            
                        case YQCombinationViewAlignment_leading:
                            make.leading.mas_equalTo(@0);
                            break;
                            
                        case YQCombinationViewAlignment_trailing:
                            make.trailing.mas_equalTo(@0);
                            break;
                            
                        default:
                            break;
                    }
                }];
                [self.constraints addObjectsFromArray:constraints];
            }else{  // 只有一个前面的视图
                onlyView = self.leadingView;
            }
        }else if (isVisible(self.trailingView)){   // 只有一个后面的视图
            onlyView = self.trailingView;
        }
        
        if (onlyView) { // 只有一个视图
            constraints = [onlyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.mas_equalTo(@0);
                make.width.mas_lessThanOrEqualTo(self);
                switch (self.alignment) {
                    case YQCombinationViewAlignment_center:
                        make.centerX.mas_equalTo(self);
                        break;
                        
                    case YQCombinationViewAlignment_leading:
                        make.leading.mas_equalTo(@0);
                        break;
                        
                    case YQCombinationViewAlignment_trailing:
                        make.trailing.mas_equalTo(@0);
                        break;
                        
                    default:
                        break;
                }
            }];
            [self.constraints addObjectsFromArray:constraints];
        }
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    BOOL oldValue = [[change valueForKey:NSKeyValueChangeOldKey] boolValue];
    BOOL newValue = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
    
    // 更新约束
    if (oldValue != newValue) {
        [self updateCustomConstraint];
    }
}

@end
