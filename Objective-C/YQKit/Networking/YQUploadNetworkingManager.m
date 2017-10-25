//
//  YQUploadNetworkingManager.m
//  Demo
//
//  Created by maygolf on 16/12/1.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSDictionary+YQCategory.h"
#import "NSString+YQURL.h"

#import "YQUploadNetworkingManager.h"
#import "YQDataNetworkingManager.h"

static NSString * const kUploadNetworkBaseURL = @"http://192.168.2.178:8092";

@implementation YQUploadData


@end

/***********************************************************************************************/
/***********************************************************************************************/

@interface YQUploadNetworkingManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation YQUploadNetworkingManager

#pragma mark - getter
- (AFHTTPSessionManager *)sessionManager{
    if (!_sessionManager) {
        if (self.networkConfig) {
            _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUploadNetworkBaseURL]];
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
        instance = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUploadNetworkBaseURL]];
        
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
    
    // 如果上传的数据为空，直接返回
    BOOL existData = NO;
    for (YQUploadData *data in self.datas) {
        if (data.sourceType == YQUploadDataSourceType_data && data.data) {
            existData = YES;
            break;
        }
        
        if (data.sourceType == YQUploadDataSourceType_path && data.dataPath && [[NSFileManager defaultManager] fileExistsAtPath:data.dataPath]) {
            existData = YES;
            break;
        }
    }
    if (!existData) {
        if (self.completion) {
            YQNetworkingResult *result = [[YQNetworkingResult alloc] init];
            NSError *error = [NSError errorWithDomain:@"上传的数据为不能为空" code:0 userInfo:nil];
            result.error = error;
            self.completion(result);
        }
        return;
    }
    
    // 按base64方式上传
    if (self.uploadMode == YQUploadMode_base64) {
        
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        for (YQUploadData *uploadData in self.datas) {
            // 获取需要上传的数据
            NSData *data = nil;
            if (uploadData.sourceType == YQUploadDataSourceType_data) {
                data = uploadData.data;
            }else if (uploadData.sourceType == YQUploadDataSourceType_path){
                data = [[NSData alloc] initWithContentsOfFile:uploadData.dataPath];
            }
            
            // 将数据转换成base64的字符串
            NSString *base64String = nil;
            if (data) {
                base64String = [data base64EncodedStringWithOptions:0];
            }
            
            // 如果base64String为nil，跳过
            if (base64String == nil) {
                continue;
            }
            
            // 将base64字符串添加到数据字典中
            id value = [dataDic objectForKey:uploadData.name];
            if (value) {
                if ([value isKindOfClass:[NSMutableArray class]]) {
                    [((NSMutableArray *)value) addObject:base64String];
                }else if ([value isKindOfClass:[NSString class]]){
                    NSMutableArray *array = [NSMutableArray arrayWithObjects:value, base64String, nil];
                    [dataDic setObject:array forKey:uploadData.name];
                }
            }else{
                if (self.base64UseArrayWhenSingle) {
                    [dataDic setObject:[NSMutableArray arrayWithObject:base64String] forKey:uploadData.name];
                }else{
                    [dataDic setObject:base64String forKey:uploadData.name];
                }
            }
        }
        
        // 如果数据为空，直接返回
        if ([dataDic.allKeys count] == 0) {
            if (self.completion) {
                YQNetworkingResult *result = [[YQNetworkingResult alloc] init];
                NSError *error = [NSError errorWithDomain:@"获取到的数据为空，请检查数据参数" code:0 userInfo:nil];
                result.error = error;
                self.completion(result);
            }
            return;
        }
        
        // 通过数据请求上传
        YQDataNetworkingManager *dataManager = [YQNetworkingManager dataManager];
        dataManager.URLString = self.URLString;
        dataManager.method = self.method;
        if (self.parameters) {
            dataManager.parameters = [NSDictionary yq_dictionaryWithDictionarys:@[self.parameters, dataDic]];
        }else{
            dataManager.parameters = dataDic;
        }
        dataManager.networkConfig = self.networkConfig;
        [dataManager startWithProgress:self.progress completion:self.completion];
        
        return;
    }
    
    // 通过multipar/form-data方式上传
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
    
    [self.sessionManager POST:self.URLString parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (YQUploadData *uploadData in self.datas) {
            
            if (uploadData.fileName == nil) {
                uploadData.fileName =@"file";
            }
            if (uploadData.sourceType == YQUploadDataSourceType_data) {
                if (uploadData.data) {
                    [formData appendPartWithFileData:uploadData.data name:uploadData.name fileName:uploadData.fileName mimeType:uploadData.mineType];
                }
            }else if (uploadData.sourceType == YQUploadDataSourceType_path){
                if (uploadData.dataPath) {
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:uploadData.dataPath] name:uploadData.name fileName:uploadData.fileName mimeType:uploadData.mineType error:nil];
                }
            }
        }
    } progress:self.progress success:success failure:failure];
}

@end
