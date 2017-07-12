//
//  YQMacro.h
//  Demo
//
//  Created by maygolf on 16/11/4.
//  Copyright © 2016年 yiquan. All rights reserved.
//

// 一些常用的宏

#ifndef YQMacro_h
#define YQMacro_h

// 按屏幕尺寸等比缩放
#define YQScaleSize(size, baseSize, scaleBaseSize) (size * scaleBaseSize / baseSize)
// 按iPhone6的宽度适配
#define YQScaleSizeBaseIphone6(size) YQScaleSize(size, kYQIPHONE6_WIDTH, kYQScreenWidth)

// 颜色
#define YQRGBA(R,G,B,A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define YQRGB(R,G,B)     YQRGBA(R, G, B, 1.0)
#define YQHexColor(hexColor)  [UIColor colorWithRed:((hexColor & 0xFF0000)>>16)/255.0 green:((hexColor & 0x00FF00)>>8)/255.0 blue:(hexColor & 0x0000FF)/255.0 alpha:1.0]
#define YQRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

// 图片
#define YQImage(imageName)    [UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]]
#define YQRenderingOriginalImage(imageName) [YQImage(imageName) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

// 角度转弧度
#define YQRadian(degrees)       (((degrees) * M_PI) / 180.0)

//字体
#define YQFont(font) [UIFont systemFontOfSize:font]

// 设置视图圆角
#define YQViewBorderRadius(View, Radius, Width, Color)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]];

// 复制到粘贴板
#define YQCopyText(text)    [UIPasteboard generalPasteboard].string = text;

// 强、弱引用对象
#define YQWeak(var, weakVar) __weak __typeof(&*var) weakVar = var;
#define YQStrong(var, strongVar) __strong __typeof(&*var) strongVar = var;
#define YQWeakSelf      YQWeak(self, weakSelf)
#define YQStrongSelf    YQStrong(weakSelf, strongSelf)

// 日志
#ifdef DEBUG
#   define YQLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define YQLog(...)
#endif

#endif /* YQMacro_h */
