//
//  YQAuthorityManager.m
//  Demo
//
//  Created by maygolf on 16/12/21.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQAuthorityManager.h"

@implementation YQAuthorityManager
YQ_SYNTHESIZE_SINGLETON_FOR_CLASS(YQAuthorityManager)

// 检查相机是否可用
+ (BOOL)isValidForCamera{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 检查相机权限
+ (AVAuthorizationStatus)authorizationStatusForCamera{
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

// 请求相机权限
+ (void)requestAuthorizationFroCameraCompletion:(void(^)(BOOL granted))completion{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:completion];
}

// 检查相册权限
+ (PHAuthorizationStatus)authorizationStatusForPhotoLibrary{
    return [PHPhotoLibrary authorizationStatus];
}
// 请求相册权限
+ (void)requestAuthorizationForPhotoLibraryCompletion:(void(^)(PHAuthorizationStatus status))completion{
    [PHPhotoLibrary requestAuthorization:completion];
}

@end
