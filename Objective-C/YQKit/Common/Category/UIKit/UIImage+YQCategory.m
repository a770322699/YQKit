//
//  UIImage+YQCategory.m
//  Demo
//
//  Created by maygolf on 16/11/7.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "UIImage+YQCategory.h"

@implementation UIImage (YQCategory)

// 修复方向
- (UIImage *)yq_fixOrientation{
    // 方向向上直接返回
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    UIImage *aImage = self;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
// 给图片添加前景色
- (UIImage *)yq_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    if (blendMode != kCGBlendModeDestinationIn)
    {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

- (UIImage *)yq_tintColorImage:(UIColor *)tintColor{
    return tintColor ? [self yq_imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn] : self;
}
- (UIImage *)yq_gradientTinColorImage:(UIColor *)tintColor{
    return tintColor ? [self yq_imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay] : self;
}

// 压缩图片
- (NSData *)yq_zipImageWithQuality:(float)quality{
    CGFloat resizeWidth = 0.0f;
    CGFloat resizeHeight = 0.0f;
    
    CGFloat sizeWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat sizeHeight = [UIScreen mainScreen].bounds.size.height;
    if (self.size.width < sizeWidth && self.size.height < sizeHeight) {
        resizeHeight = self.size.height;
        resizeWidth = self.size.width;
    }
    else
    {
        if (self.size.height > sizeHeight) {
            resizeWidth  = ceil((self.size.width * sizeHeight) / self.size.height);
            resizeHeight = sizeHeight;
        } else {
            resizeWidth  = sizeWidth;
            resizeHeight = ceil((self.size.height * sizeWidth) / self.size.width);
        }
    }
    
    resizeWidth = resizeWidth * [UIScreen mainScreen].scale;
    resizeHeight = resizeHeight * [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContext(CGSizeMake(resizeWidth, resizeHeight));
    [self drawInRect:CGRectMake(0, 0, resizeWidth, resizeHeight)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImageJPEGRepresentation(resizeImage, quality);
}
// 裁剪图片
- (UIImage *)yq_cutFromRect:(CGRect)rect{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(rect.size);
    context = UIGraphicsGetCurrentContext();
    [newImage drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, self.size.width, self.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)yq_imageWithColor:(UIColor *)aColor{
    return [UIImage yq_imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}
+ (UIImage *)yq_imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame{
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (NSData *)yq_dataSmallerThan:(NSUInteger)dataLength{
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    while (data.length > dataLength) {
        UIImage *image = [UIImage imageWithData:data];
        data = UIImageJPEGRepresentation(image, 0.7);
    }
    return data;
}
- (UIImage *)yq_scaledToSize:(CGSize)targetSize{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat scaleFactor = 0.0;
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetSize.width / imageSize.width;
        CGFloat heightFactor = targetSize.height / imageSize.height;
        if (widthFactor < heightFactor)
            scaleFactor = heightFactor; // scale to fit height
        else
            scaleFactor = widthFactor; // scale to fit width
    }
    scaleFactor = MIN(scaleFactor, 1.0);
    CGFloat targetWidth = imageSize.width* scaleFactor;
    CGFloat targetHeight = imageSize.height* scaleFactor;
    
    targetSize = CGSizeMake(floorf(targetWidth), floorf(targetHeight));
    UIGraphicsBeginImageContext(targetSize); // this will crop
    [sourceImage drawInRect:CGRectMake(0, 0, ceilf(targetWidth), ceilf(targetHeight))];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        newImage = sourceImage;
    }
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)yq_scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality{
    if (highQuality) {
        targetSize = CGSizeMake(2*targetSize.width, 2*targetSize.height);
    }
    return [self yq_scaledToSize:targetSize];
}
//图片的清晰度不够.

/**
 保持图片纵横比缩放，最短边必须匹配targetSize的大小
 可能有一条边的长度会超过targetSize指定的大小 (裁剪)
 */
- (UIImage *)yq_scaledToMinSize:(CGSize)targetSize{
    // 获取源图片的宽和高
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    // 获取图片缩放目标大小的宽和高
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    // 定义图片缩放后的宽度
    CGFloat scaledWidth = targetWidth;
    // 定义图片缩放后的高度
    CGFloat scaledHeight = targetHeight;
    CGPoint anchorPoint = CGPointZero;
    // 如果源图片的大小与缩放的目标大小不相等
    if (!CGSizeEqualToSize(imageSize, targetSize))
    {
        // 计算水平方向上的缩放因子
        CGFloat xFactor = targetWidth / width;
        // 计算垂直方向上的缩放因子
        CGFloat yFactor = targetHeight / height;
        // 定义缩放因子scaleFactor，为两个缩放因子中较大的一个
        CGFloat scaleFactor = xFactor > yFactor? xFactor : yFactor;
        // 根据缩放因子计算图片缩放后的宽度和高度
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // 如果横向上的缩放因子大于纵向上的缩放因子，那么图片在纵向上需要裁切
        if (xFactor > yFactor)
        {
            anchorPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        // 如果横向上的缩放因子小于纵向上的缩放因子，那么图片在横向上需要裁切
        else if (xFactor < yFactor)
        {
            anchorPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // 开始绘图
    UIGraphicsBeginImageContext(targetSize);
    // 定义图片缩放后的区域
    CGRect anchorRect = CGRectZero;
    anchorRect.origin = anchorPoint;
    anchorRect.size.width  = scaledWidth;
    anchorRect.size.height = scaledHeight;
    // 将图片本身绘制到auchorRect区域中
    [self drawInRect:anchorRect];
    // 获取绘制后生成的新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 返回新图片
    return newImage ;
}

/**
 保持图片纵横比缩放，最长边匹配targetSize的大小即可
 可能有一条边的长度会小于targetSize指定的大小 (有留白)
 */
- (UIImage *)yq_scaledToMaxSize:(CGSize)targetSize{
    // 获取源图片的宽和高
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    // 获取图片缩放目标大小的宽和高
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    // 定义图片缩放后的实际的宽和高度
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint anchorPoint = CGPointZero;
    // 如果源图片的大小与缩放的目标大小不相等
    if (!CGSizeEqualToSize(imageSize, targetSize))
    {
        CGFloat xFactor = targetWidth / width;
        CGFloat yFactor = targetHeight / height;
        // 定义缩放因子scaleFactor，为两个缩放因子中较小的一个
        CGFloat scaleFactor = xFactor < yFactor ? xFactor:yFactor;
        // 根据缩放因子计算图片缩放后的宽度和高度
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // 如果横向的缩放因子小于纵向的缩放因子，图片在上面、下面有空白
        // 那么图片在纵向上需要下移一段距离，保持图片在中间
        if (xFactor < yFactor)
        {
            anchorPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        // 如果横向的缩放因子小于纵向的缩放因子，图片在左边、右边有空白
        // 那么图片在横向上需要右移一段距离，保持图片在中间
        else if (xFactor > yFactor)
        {
            anchorPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // 开始绘图
    UIGraphicsBeginImageContext(targetSize);
    // 定义图片缩放后的区域
    CGRect anchorRect = CGRectZero;
    anchorRect.origin = anchorPoint;
    anchorRect.size.width  = scaledWidth;
    anchorRect.size.height = scaledHeight;
    // 将图片本身绘制到auchorRect区域中
    [self drawInRect:anchorRect];
    // 获取绘制后生成的新图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 返回新图片
    return newImage ;
}

/** 对图片按弧度执行旋转 */
- (UIImage *)yq_rotatedByRadians:(CGFloat)radians{
    // 定义一个执行旋转的CGAffineTransform结构体
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    // 对图片的原始区域执行旋转，获取旋转后的区域
    CGRect rotatedRect = CGRectApplyAffineTransform(
                                                    CGRectMake(0.0 , 0.0, self.size.width, self.size.height) , t);
    // 获取图片旋转后的大小
    CGSize rotatedSize = rotatedRect.size;
    // 创建绘制位图的上下文
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 指定坐标变换，将坐标中心平移到图片的中心
    CGContextTranslateCTM(ctx, rotatedSize.width/2, rotatedSize.height/2);
    // 执行坐标变换，旋转过radians弧度
    CGContextRotateCTM(ctx , radians);
    // 执行坐标变换，执行缩放
    CGContextScaleCTM(ctx, 1.0, -1.0);
    // 绘制图片
    CGContextDrawImage(ctx, CGRectMake(-self.size.width / 2
                                       , -self.size.height / 2,
                                       self.size.width,
                                       self.size.height), self.CGImage);
    // 获取绘制后生成的新图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 返回新图片
    return newImage;
}

/** 对图片按角度执行旋转 */
- (UIImage *)yq_rotatedByDegress:(CGFloat)degress{
    return [self yq_rotatedByRadians:degress * M_PI / 180];
}

/** 对指定UI控件进行截图 */
+ (UIImage *)yq_captureView:(UIView *)targetView{
    // 获取目标UIView的所在的区域
    CGRect rect = targetView.frame;
    // 开始绘图
    UIGraphicsBeginImageContext(rect.size);
    // 获取当前的绘图Context
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 调用CALayer的方法将当前控件绘制到绘图Context中
    [targetView.layer renderInContext:context];
    // 获取该绘图Context中的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/** 取出(挖取)图片的指定区域 */
- (UIImage *)yq_imageAtRect:(CGRect)rect{
    // 获取该UIImage图片对应的CGImageRef对象
    CGImageRef srcImage = [self CGImage];
    // 从srcImage中“挖取”rect区域
    CGImageRef imageRef = CGImageCreateWithImageInRect(srcImage, rect);
    // 将“挖取”出来的CGImageRef转换为UIImage对象
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(srcImage);
    CGImageRelease(imageRef);
    return subImage;
}

// 获取圆角图片
- (UIImage *)yq_circleImageWithRadius:(CGFloat)radius{
    return [self yq_circleImageWithRadius:radius size:self.size];
}

// 获取圆角图片
- (UIImage *)yq_circleImageWithRadius:(CGFloat)radius size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    CGContextRef contenxt = UIGraphicsGetCurrentContext();

    CGContextAddArc(contenxt, size.width - radius, radius, radius, - M_PI_2, 0, NO);
    CGContextAddArc(contenxt, size.width - radius, size.height - radius, radius, 0, M_PI_2, NO);
    CGContextAddArc(contenxt, radius, size.height - radius, radius, M_PI_2, M_PI, NO);
    CGContextAddArc(contenxt, radius, radius, radius, M_PI, - M_PI_2, NO);

    CGContextClip(contenxt);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 获取圆形图片
- (UIImage *)yq_circleImage{
    return [self yq_circleImageWithSize:self.size];
}

// 获取圆形图片
- (UIImage *)yq_circleImageWithSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    CGContextRef contenxt = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(contenxt, rect);
    CGContextClip(contenxt);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//主色调;
- (UIColor *)yq_mostColor{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(50, 50);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, self.CGImage);
    CGColorSpaceRelease(colorSpace);
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    if (data == NULL) return nil;
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    for (int x=0; x < thumbSize.width; x++) {
        for (int y = 0; y < thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];
        }
    }
    
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) continue;
        MaxCount = tmpCount;
        MaxColor = curColor;
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}
//颜色均值AverageColor
- (UIColor *)yq_averageColor{
    UIImage *image = self;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char rgba[4];
    
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.CGImage);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextRelease(context);
    
    if(rgba[3] > 0) {
        
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        
        CGFloat multiplier = alpha/255.0;
        
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                
                               green:((CGFloat)rgba[1])*multiplier
                
                                blue:((CGFloat)rgba[2])*multiplier
                
                               alpha:alpha];
        
    }
    
    else {
        
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                
                               green:((CGFloat)rgba[1])/255.0
                
                                blue:((CGFloat)rgba[2])/255.0
                
                               alpha:((CGFloat)rgba[3])/255.0];
        
    }
}

// 获取icon
+ (UIImage *)yq_iconImageWithSize:(CGSize)size{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSArray *iconNames = infoDic[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    
    NSString *sizeString = [NSString stringWithFormat:@"%dx%d", (int)size.width, (int)size.height];
    for (NSString *iconName in iconNames) {
        if ([iconName hasSuffix:sizeString]) {
            return [UIImage imageNamed:iconName];
        }
    }
    return nil;
}


@end
