//
//  YQNetworkingResult.h
//  Demo
//
//  Created by maygolf on 16/11/30.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YQNetworkingResultCode) {
    YQNetworkingResultCode_timeOut,                     // 超时(服务器无响应)
    YQNetworkingResultCode_success,                     // 成功
    YQNetworkingResultCode_fail_1,                      // 自定义错误类型（和后台约定）
    YQNetworkingResultCode_fail_2,                      // 自定义错误类型（和后台约定）
};

@interface YQNetworkingResult : NSObject

@property (nonatomic, assign) YQNetworkingResultCode resultCode;
@property (nonatomic, strong) NSString *errMsg;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString *URL;

@end
