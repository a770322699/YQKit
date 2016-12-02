//
//  YQDownloadNetworkingManager.m
//  Demo
//
//  Created by maygolf on 16/12/1.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "AFHTTPSessionManager+Download.h"
#import "NSString+YQURL.h"

#import "YQDownloadNetworkingManager.h"

static NSString * const kDownloadNetworkBaseURL = @"http://192.168.2.178:8092";

@interface YQDownloadNetworkingManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation YQDownloadNetworkingManager

#pragma mark - override
+ (void)configHTTPSessionManager:(AFHTTPSessionManager *)HTTPSessionManager{
    
}
+ (NSDictionary *)commonParameters{
    return nil;
}

#pragma mark - getter
- (AFHTTPSessionManager *)sessionManager{
    if (!_sessionManager) {
        if (self.networkConfig) {
            _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kDownloadNetworkBaseURL]];
            self.networkConfig(_sessionManager);
        }else{
            _sessionManager = [[self class] shareSessionManager];
        }
    }
    return _sessionManager;
}

#pragma mark - private
+ (AFHTTPSessionManager *)shareSessionManager{
    static AFHTTPSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 配置baseURL
        instance = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kDownloadNetworkBaseURL]];
        
        // 配置相关信息
        [self configHTTPSessionManager:instance];
    });
    
    return instance;
}

#pragma mark - override public
- (void)startWithProgress:(void(^)(NSProgress *progress))progress completion:(void(^)(YQNetworkingResult *result))completion{
    // 如果url为空，直接返回
    if (self.URLString.length == 0) {
        if (completion) {
            YQNetworkingResult *result = [[YQNetworkingResult alloc] init];
            NSError *error = [NSError errorWithDomain:@"请求的url为空" code:0 userInfo:nil];
            result.error = error;
            completion(result);
        }
        return;
    }
    
    // 配置公共参数
    NSDictionary *commonParameters = [[self class] commonParameters];
    if (commonParameters) {
        self.parameters = ({
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setValuesForKeysWithDictionary:commonParameters];
            [parameters setValuesForKeysWithDictionary:self.parameters];
            
            parameters;
        });
    }
    
    // 开始下载数据
    [self.sessionManager yq_downloadData:self.URLString parameters:self.parameters destination:self.path progress:progress completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        if (completion) {
            YQNetworkingResult *result = [[YQNetworkingResult alloc] init];
            result.URL = response.URL.absoluteString;
            if (response.URL.query.length == 0) {
                NSString *query = [NSString yq_parameterStringWithDictionary:self.parameters];
                if (query.length) {
                    result.URL = [result.URL stringByAppendingFormat:@"?%@", query];
                }   
            }
            
            if (error) {
                result.error = error;
                result.resultCode = YQNetworkingResultCode_timeOut;
            }else{
                result.resultCode = YQNetworkingResultCode_success;
                if (self.path.length == 0) {
                    result.data = [NSData dataWithContentsOfURL:filePath];
                }
                
                // 根据后台返回数据配置result的数据
                // ......
            }
            
            completion(result);
        }
        
        // 断开网络连接
        if (self.sessionManager != [[self class] shareSessionManager]) {
            [self.sessionManager invalidateSessionCancelingTasks:NO];
        }
        
    }];
}

@end
