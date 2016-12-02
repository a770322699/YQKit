//
//  YQNetworkingManager.m
//  Demo
//
//  Created by maygolf on 16/12/1.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSString+YQCategory.h"

#import "YQDataNetworkingManager.h"
#import "YQUploadNetworkingManager.h"
#import "YQDownloadNetworkingManager.h"

@implementation YQNetworkingManager

- (instancetype)init{
    if (self = [super init]) {
        self.method = YQNetworkingMethod_get;
    }
    return self;
}

+ (YQDataNetworkingManager *)dataManager{
    return [[YQDataNetworkingManager alloc] init];
}
+ (YQUploadNetworkingManager *)uploadManager{
    return [[YQUploadNetworkingManager alloc] init];
}
+ (YQDownloadNetworkingManager *)downloadManager{
    return [[YQDownloadNetworkingManager alloc] init];
}

#pragma mark - public
- (void)startWithCompletion:(void(^)(YQNetworkingResult *result))completion{
    [self startWithProgress:nil completion:completion];
}
- (void)startWithProgress:(void(^)(NSProgress *progress))progress completion:(void(^)(YQNetworkingResult *result))completion{
    
    YQNetworkingResult *result = [[YQNetworkingResult alloc] init];
    result.error = [NSError errorWithDomain:@"不能直接使用YQNetworkingManager类型的对象发送请求消息，请创建YQNetworkingManager的子类（YQDataNetworkingManager、YQUploadNetworkingManager或者YQDownloadNetworkingManager）类型的对象发送请求！" code:0 userInfo:nil];
    if (completion) {
        completion(result);
    }else{
        NSLog(@"%@", result.error.domain);
    }
}

#pragma mark - protected
// 供子类调用父类的公共配置
+ (void)configHTTPSessionManager:(AFHTTPSessionManager *)HTTPSessionManager{
    // 配置自动解析的contentType
    NSMutableSet *contentTypes = [NSMutableSet setWithSet:HTTPSessionManager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"text/plain"];
    HTTPSessionManager.responseSerializer.acceptableContentTypes = contentTypes;
    
    // 配置contentType
    [HTTPSessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // 其他在具体项目中需要的配置
    // ......
}

// 配置公共参数
+ (NSDictionary *)commonParameters{
    NSMutableDictionary *commonDic = [NSMutableDictionary dictionary];
    
    // 设置公共参数
    NSString *token = [NSString stringWithFormat:@"HYAPP*%ld", (long)arc4random()];
    token = [token yq_DESEncryptForKey:@"aledowfv"];
    [commonDic setObject:token forKey:@"token"];
    
    return commonDic;
}

@end
