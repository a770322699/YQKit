//
//  YQAuthorityManager.h
//  Demo
//
//  Created by maygolf on 16/12/21.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import "YQSynthesizeSingleton.h"

@interface YQAuthorityManager : NSObject
YQ_DECLARE_SINGLETON_FOR_CLASS(YQAuthorityManager)

// 检查相机是否可用
+ (BOOL)isValidForCamera;
// 检查相机权限
+ (AVAuthorizationStatus)authorizationStatusForCamera;
// 请求相机权限
+ (void)requestAuthorizationFroCameraCompletion:(void(^)(BOOL granted))completion;

// 检查相册权限
+ (PHAuthorizationStatus)authorizationStatusForPhotoLibrary;
// 请求相册权限
+ (void)requestAuthorizationForPhotoLibraryCompletion:(void(^)(PHAuthorizationStatus status))completion;

@end
