//
//  YQDataNetworkingManager.m
//  Demo
//
//  Created by maygolf on 16/12/1.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSString+YQURL.h"

#import "YQDataNetworkingManager.h"

static NSString * const kDataNetworkBaseURL = @"http://192.168.2.178:8092";

@interface YQDataNetworkingManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation YQDataNetworkingManager

#pragma mark - getter
- (AFHTTPSessionManager *)sessionManager{
    if (!_sessionManager) {
        if (self.networkConfig) {
            _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kDataNetworkBaseURL]];
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
        instance = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kDataNetworkBaseURL]];
        
        // 配置相关信息
        [self configHTTPSessionManager:instance];
    });
    
    return instance;
}

#pragma mark - override public
- (void)start{
    // 如果url为空，直接返回
    if (self.URLString.length == 0) {
        if (self.completion) {
            YQNetworkingResult *result = [[YQNetworkingResult alloc] init];
            NSError *error = [NSError errorWithDomain:@"请求的url为空" code:0 userInfo:nil];
            result.error = error;
            self.completion(result);
        }
        return;
    }
    
    // 请求成功
    void(^success)(NSURLSessionDataTask * _Nonnull, id  _Nullable) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        if (self.completion) {
            YQNetworkingResult *result = [[YQNetworkingResult alloc] init];
            result.URL = task.currentRequest.URL.absoluteString;
            if (task.currentRequest.URL.query.length == 0) {
                NSString *query = [NSString yq_parameterStringWithDictionary:self.parameters];
                if (query.length) {
                    result.URL = [result.URL stringByAppendingFormat:@"?%@", query];
                }
            }
            
            // 根据后台返回数据配置result的数据
            // ......
            
            self.completion(result);
        }
        
        // 断开网络连接
        if (self.sessionManager != [[self class] shareSessionManager]) {
            [self.sessionManager invalidateSessionCancelingTasks:NO];
        }
    };
    
    // 请求失败
    void(^failure)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        if (self.completion) {
            YQNetworkingResult *result = [[YQNetworkingResult alloc] init];
            result.URL = task.currentRequest.URL.absoluteString;
            if (task.currentRequest.URL.query.length == 0) {
                NSString *query = [NSString yq_parameterStringWithDictionary:self.parameters];
                if (query.length) {
                    result.URL = [result.URL stringByAppendingFormat:@"?%@", query];
                }
            }
            result.error = error;
            result.resultCode = YQNetworkingResultCode_timeOut;
            
            self.completion(result);
        }
        
        // 断开网络连接
        if (self.sessionManager != [[self class] shareSessionManager]) {
            [self.sessionManager invalidateSessionCancelingTasks:NO];
        }
    };
    
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
    
    switch (self.method) {
        case YQNetworkingMethod_get:
            [self.sessionManager GET:self.URLString parameters:self.parameters progress:self.progress success:success failure:failure];
            break;
            
        case YQNetworkingMethod_post:
            [self.sessionManager POST:self.URLString parameters:self.parameters progress:self.progress success:success failure:failure];
            break;
            
        case YQNetworkingMethod_put:
            [self.sessionManager PUT:self.URLString parameters:self.parameters success:success failure:failure];
            break;
            
        case YQNetworkingMethod_delete:
            [self.sessionManager DELETE:self.URLString parameters:self.parameters success:success failure:failure];
            break;
            
        default:
            if (self.completion) {
                YQNetworkingResult *result = [[YQNetworkingResult alloc] init];
                NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:@"不支持的请求方法:%ld", (long)self.method] code:0 userInfo:nil];
                result.error = error;
                self.completion(result);
            }
            break;
    }

}

@end
