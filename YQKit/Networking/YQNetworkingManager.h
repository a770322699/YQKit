//
//  YQNetworkingManager.h
//  Demo
//
//  Created by maygolf on 16/12/1.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import "YQNetworkingResult.h"

@class YQDataNetworkingManager;
@class YQDownloadNetworkingManager;
@class YQUploadNetworkingManager;

typedef NS_ENUM(NSInteger, YQNetworkingMethod) {
    YQNetworkingMethod_post,
    YQNetworkingMethod_get,
    YQNetworkingMethod_put,
    YQNetworkingMethod_delete,
};

@interface YQNetworkingManager : NSObject

@property (nonatomic, assign) YQNetworkingMethod method;    // 方法
@property (nonatomic, strong) NSString *URLString;          // 相对URL或绝对URL
@property (nonatomic, strong) NSDictionary *parameters;     // 参数
@property (nonatomic, copy) void(^networkConfig)(AFHTTPSessionManager *HTTPSessionManager);     // 自定义配置，若为nil，使用公共配置

+ (YQDataNetworkingManager *)dataManager;
+ (YQUploadNetworkingManager *)uploadManager;
+ (YQDownloadNetworkingManager *)downloadManager;

- (void)startWithCompletion:(void(^)(YQNetworkingResult *result))completion;
- (void)startWithProgress:(void(^)(NSProgress *progress))progress completion:(void(^)(YQNetworkingResult *result))completion;

// 供子类调用父类的公共配置
+ (void)configHTTPSessionManager:(AFHTTPSessionManager *)HTTPSessionManager;
+ (NSDictionary *)commonParameters;

@end
