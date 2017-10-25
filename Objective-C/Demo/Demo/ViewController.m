//
//  ViewController.m
//  Demo
//
//  Created by maygolf on 16/11/4.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQCategory.h"
#import "YQGlobalValue.h"
#import "Masonry.h"

#import "ViewController.h"

#import "YQLoadingView.h"
#import "YQTableView.h"
#import "TableViewCell.h"

#import "YQLoadingViewResourceManager.h"

#import "YQNetworkingManager+Create.h"

#import "YQTestModelView.h"

@interface ViewController ()<YQViewSidelineDataSource, UITableViewDelegate, UITableViewDataSource, YQCardGroupDataSource>

@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) YQLoadingView *loadingView;

@property (nonatomic, strong) YQTestModelView *modelView;


@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.view.yq_userInteractionEnabledWhenLoaing = YES;
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 100, 200, 100)];
//    view.yq_sidelineDataSource = self;
//    view.yq_sideLineOption = YQViewSidelineOption_top | YQViewSidelineOption_left | YQViewSidelineOption_bottom | YQViewSidelineOption_right;
//    [self.view addSubview:view];
//    
//    view.yq_center = self.view.center;
//    
//    [self.timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    
//    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, -80 - 200, 320, 360)];
//    view.image = [UIImage imageNamed:@"bg"];
//    
//    UILabel *label = [[UILabel alloc] init];
//    label.translatesAutoresizingMaskIntoConstraints = NO;
//    label.text = @"及福利大咖";
//    label.textColor = [UIColor redColor];
//    label.backgroundColor = [UIColor cyanColor];
//    [view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(view);
//    }];
//    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.yq_scaleHeaderView = view;
//    tableView.yq_scaleHeaderViewVisibleHeight = 200;
//    [self.view addSubview:tableView];
    
    self.modelView = [[YQTestModelView alloc] init];
    
    self.imageView1.image = [YQImage(@"image.jpg") yq_circleImageWithSize:CGSizeMake(200, 200)];
    self.imageView2.image = [YQImage(@"image.jpg") yq_circleImageWithRadius:50 size:CGSizeMake(200, 200)];
    
    [self.imageView2 yq_shakeStart];

    
//    unsigned int outCount = 0;
//    Ivar *ivars = class_copyIvarList([UITableView class], &outCount);
//    for (int i = 0; i < outCount; i++) {
//        Ivar ivar = ivars[i];
//        NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(ivar)];
//        NSLog(@"%@", name);
//    }
//    
//    free(ivars);
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 60;
    tableView.yq_cardGroupDataSource = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.tableFooterView = [UIView new];
    [tableView yq_registerClass:[UIView class] forGroupCardViewReuseIdentifier:@"id"];
    [self.view addSubview:tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (YQLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[YQLoadingView alloc] init];
        _loadingView.viewController = self;
    }
    return _loadingView;
}

#pragma mark - YQViewSidelineDataSource
// 获取线宽,默认为0.5
- (CGFloat)sidelineWidthForView:(UIView *)view option:(YQViewSidelineOption)option{
    return 1.0;
}
// 获取线边距，上、下线只有左右边距有效，左、右线只有上下边距有效，默认为（0，0，0，0）
- (UIEdgeInsets)sidelineInsetsForView:(UIView *)view option:(YQViewSidelineOption)option{
    switch (option) {
        case YQViewSidelineOption_top:
            return UIEdgeInsetsMake(0, 0, 0, 1);
        
        case YQViewSidelineOption_right:
            return UIEdgeInsetsMake(0, 0, 1, 0);
            
        case YQViewSidelineOption_bottom:
            return UIEdgeInsetsMake(0, 1, 0, 0);
        
        case YQViewSidelineOption_left:
            return UIEdgeInsetsMake(1, 0, 0, 0);
            
        default:
            break;
    }
    return UIEdgeInsetsZero;
}
// 获取线条颜色
- (UIColor *)sideColorForView:(UIView *)view option:(YQViewSidelineOption)option{
    switch (option) {
        case YQViewSidelineOption_top:
            return [UIColor cyanColor];
            
        case YQViewSidelineOption_right:
            return [UIColor blueColor];
            
        case YQViewSidelineOption_bottom:
            return [UIColor redColor];
            
        case YQViewSidelineOption_left:
            return [UIColor greenColor];
            
        default:
            break;
    }
    return nil;
}
- (IBAction)timeCtrl:(id)sender {
//    if (self.timer == NULL) {
//        self.timer = YQTimerStart(60, 1, ^(NSInteger number, NSTimeInterval remainTime) {
//            self.timeButton.titleLabel.text = [NSString stringWithFormat:@"%ld后重新获取", (long)remainTime];
//            [self.timeButton setTitle:[NSString stringWithFormat:@"%ld后重新获取", (long)remainTime] forState:UIControlStateNormal];
//        }, ^{
//            self.timer = NULL;
//            [self.timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//        });
//    }else{
//        [self.timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//        dispatch_source_cancel(self.timer);
//        self.timer = nil;
//    }
    
//    if (self.view.yq_isLoading) {
//        [self.view yq_stopLoading];
//    }else{
//        self.view.yq_loadingText = @"正在加载数据，请稍候...";
//        [self.view yq_beginLoading];
//    }
    
//    static NSInteger i = 0;
//    
//    if (i == 0) {
////        [self.loadingView showLoading:@"正在加载...."];
//        i = 1;
//    }else if (i == 1){
//        [self.loadingView showFail:@"失败"];
//        i = 2;
//    }else if (i == 2){
//        [self.loadingView showSuccess:@"成功"];
//        i = 0;
//    }
//    
//    YQNetworkingManager *manager = [YQNetworkingManager demoDataManagerWithId:0];
//    [manager startWithCompletion:^(YQNetworkingResult *result) {
//        NSLog(@"%@", result.URL);
//    }];
//    
//    manager = [YQNetworkingManager demoUploadDataManagerMole:0];
//    [manager startWithCompletion:^(YQNetworkingResult *result) {
//        NSLog(@"%@", result.URL);
//    }];
//    
//    manager = [YQNetworkingManager demoDownloadManager];
//    [manager startWithCompletion:^(YQNetworkingResult *result) {
//        NSLog(@"%@", result.URL);
//    }];
    
    if (self.modelView.isShow) {
        [self.modelView dismiss];
    }else{
        [self.modelView show];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identitiy = @"sdjfal";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identitiy];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identitiy];
        cell.backgroundColor = kYQColorClear;
        cell.contentView.backgroundColor = kYQColorClear;
    }
    
    cell.label.text = @"的官方金坷垃";
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView cardViewForSection:(NSInteger)section{
    UIView *view = [tableView yq_dequeueReusableGroupCardViewWithIdentifier:@"id" section:section];
    if (view.tag != 100) {
        view.tag = 100;
        
        YQViewBorderRadius(view, 5, 0, kYQColorClear);
    }
    
    switch (section) {
        case 0:
            view.backgroundColor = kYQColorCyan;
            break;
            
        case 1:
            view.backgroundColor = kYQColorGreen;
            break;
            
        case 2:
            view.backgroundColor = kYQColorOrange;
            break;
            
        default:
            break;
    }
    
    return view;
}
- (CGFloat)cardViewLeftMarginForTableView:(UITableView *)tableView{
    return 30;
}
- (CGFloat)cardViewRightMarginForTableView:(UITableView *)tableView{
    return 30;
}

@end
