//
//  YQConst.h
//  Demo
//
//  Created by maygolf on 16/11/4.
//  Copyright © 2016年 yiquan. All rights reserved.
//

// 一些常用的常量

#ifndef YQConst_h
#define YQConst_h

// 常用视图尺寸
#define kYQNavigationBarHeight        64.0
#define kYQStatusBarHeight            20.0
#define kYQNavigationBarHeight_less  (kYQNavigationBarHeight - kYQStatusBarHeight)
#define kYQTabbarHeight               49.0
#define kYQToolBarHeight              44.0
#define kYQSearchBarHeight            44.0

// 屏幕尺寸
#define kYQScreenBounds   [[UIScreen mainScreen] bounds]
#define kYQScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define kYQScreenHeight   ([UIScreen mainScreen].bounds.size.height)

// 屏幕比率
#define kYQScreenScale      ([UIScreen mainScreen].scale)

// 屏幕尺寸
#define kYQIPHONE6_WIDTH           375.0
#define kYQIPHONE6_HEIGHT          667.0

#define kYQIPHONE6_PLUS_WIDTH      414.0
#define kYQIPHONE6_PLUS_HEIGHT     736.0

#define kYQIPHONE_OHTER_WIDTH      320.0
#define kYQIPHONE_OHTER_HEIGHT     568.0

#define kYQIPHONEX_WIDTH            375.0
#define kYQIPHONEX_HEIGHT           812.0

// 操作系统版本
#define kYQSystemVersion  [[[UIDevice currentDevice] systemVersion] floatValue]

// 全局队列
#define kYQDispatchGlobalQueue  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

//获取temp
#define kYQPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kYQPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kYQPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

// app名称
#define kYQAppName  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
// app版本
#define kYQAppVersionString [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kYQAppVersion   [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] doubleValue]

//判断是否为iPhone
#define kYQIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define KYQIS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define kYQIS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

// 是否真机
#if TARGET_OS_IPHONE
#define kYQIS_Device YES
#else
#define kYQIS_Device  NO
#endif
// 是否模拟器
#if TARGET_IPHONE_SIMULATOR
#define kYQIS_Simulator    YES
#else
#define kYQIS_Simulator    NO
#endif

#endif /* YQConst_h */
