//
//  UIImage+YQCategory.h
//  Demo
//
//  Created by maygolf on 16/11/7.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YQCategory)

// 修复方向
- (UIImage *)yq_fixOrientation;
// 给图片添加前景色
- (UIImage *)yq_tintColorImage:(UIColor *)tintColor;
- (UIImage *)yq_gradientTinColorImage:(UIColor *)tintColor;

// 压缩图片
- (NSData *)yq_zipImageWithQuality:(float)quality;
// 裁剪图片
- (UIImage *)yq_cutFromRect:(CGRect)rect;

+ (UIImage *)yq_imageWithColor:(UIColor *)aColor;
+ (UIImage *)yq_imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
- (NSData *)yq_dataSmallerThan:(NSUInteger)dataLength;
- (UIImage *)yq_scaledToSize:(CGSize)targetSize;
- (UIImage *)yq_scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
//图片的清晰度不够.

/**
 保持图片纵横比缩放，最短边必须匹配targetSize的大小
 可能有一条边的长度会超过targetSize指定的大小 (裁剪)
 */
- (UIImage *)yq_scaledToMinSize:(CGSize)targetSize;

/**
 保持图片纵横比缩放，最长边匹配targetSize的大小即可
 可能有一条边的长度会小于targetSize指定的大小 (有留白)
 */
- (UIImage *)yq_scaledToMaxSize:(CGSize)targetSize;

/** 对图片按弧度执行旋转 */
- (UIImage *)yq_rotatedByRadians:(CGFloat)radians;

/** 对图片按角度执行旋转 */
- (UIImage *)yq_rotatedByDegress:(CGFloat)degress;

/** 对指定UI控件进行截图 */
+ (UIImage *)yq_captureView:(UIView *)targetView;

/** 取出(挖取)图片的指定区域 */
- (UIImage *)yq_imageAtRect:(CGRect)rect;

// 获取圆角图片
- (UIImage *)yq_circleImageWithRadius:(CGFloat)radius;
// 获取圆形图片
- (UIImage *)yq_circleImage;
// 获取圆角图片
- (UIImage *)yq_circleImageWithRadius:(CGFloat)radius size:(CGSize)size;
// 获取圆形图片
- (UIImage *)yq_circleImageWithSize:(CGSize)size;

//主色调;
- (UIColor *)yq_mostColor;
//颜色均值AverageColor
- (UIColor *)yq_averageColor;

// 获取icon
+ (UIImage *)yq_iconImageWithSize:(CGSize)size;

@end
