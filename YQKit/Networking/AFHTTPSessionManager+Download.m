//
//  AFHTTPSessionManager+Download.m
//  Demo
//
//  Created by maygolf on 16/12/2.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <objc/runtime.h>

#import "YQGlobalValue.h"
#import "NSString+YQCategory.h"

#import "AFHTTPSessionManager+Download.h"

@interface YQDataDownloadTask ()<NSCopying>

@property (nonatomic, strong) NSURLSessionDownloadTask *URLSessionTask;
@property (nonatomic, copy) YQDataDownloadProgress progress;
@property (nonatomic, copy) YQDataDownloadCompletion completion;

@end

@implementation YQDataDownloadTask

- (instancetype)initWithURLString:(NSString *)URLString cachePath:(NSString *)path parameters:(NSDictionary *)parameters{
    if (self = [super init]) {
        self.URLString = URLString;
        self.cachePath = path;
        self.parameters = parameters;
    }
    return self;
}

+ (instancetype)taskWithURLString:(NSString *)URLString cachePath:(NSString *)path parameters:(NSDictionary *)parameters{
    return [[self alloc] initWithURLString:URLString cachePath:path parameters:parameters];
}

#pragma mark - override
- (BOOL)isEqual:(YQDataDownloadTask *)object{
    
    BOOL isEqualParameters = [self.parameters isEqual:object.parameters];
    if (self.parameters == nil && object.parameters == nil) {
        isEqualParameters = YES;
    }
    
    BOOL isEqualURL = [self.URLString isEqualToString:object.URLString];
    if (self.URLString == nil && object.URLString == nil) {
        isEqualURL = YES;
    }
    
    BOOL isEqualPath = [self.cachePath isEqualToString:object.cachePath];
    if (self.cachePath == nil && object.cachePath == nil) {
        isEqualPath = YES;
    }
    
    return isEqualParameters && isEqualURL && isEqualPath;
}

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone{
    YQDataDownloadTask *task = [YQDataDownloadTask taskWithURLString:self.URLString cachePath:self.cachePath parameters:self.parameters];
    task.completion = self.completion;
    task.progress = self.progress;
    
    return task;
}

@end

/***********************************************************************************************/
/***********************************************************************************************/

static const char * const kRuntimeSaveKey_downTasks = "kRuntimeSaveKey_downTasks";

@interface AFHTTPSessionManager (YQDataDownloadPrivate)

@property (nonatomic, strong) NSMutableArray<YQDataDownloadTask *> *yq_downTasks;

@end

@implementation AFHTTPSessionManager (YQDataDownloadPrivate)

- (NSMutableArray<YQDataDownloadTask *> *)yq_downTasks{
    NSMutableArray *downTasks = objc_getAssociatedObject(self, kRuntimeSaveKey_downTasks);
    if (!downTasks) {
        downTasks = [NSMutableArray array];
        self.yq_downTasks = downTasks;
    }
    
    return downTasks;
}

- (void)setYq_downTasks:(NSMutableArray<YQDataDownloadTask *> *)yq_downTasks{
    objc_setAssociatedObject(self, kRuntimeSaveKey_downTasks, yq_downTasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

/***********************************************************************************************/
/***********************************************************************************************/

@implementation AFHTTPSessionManager (Download)

#pragma mark - public
// 下载数据
- (YQDataDownloadTask *)yq_downloadData:(NSString *)URLString
                             parameters:(nullable id)parameters
                            destination:(NSString *)path
                               progress:(YQDataDownloadProgress) downloadProgressBlock
                      completionHandler:(YQDataDownloadCompletion)completionHandler{
    
    NSURL *URL = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    
    // 创建并添加一个task到task集合中
    YQDataDownloadTask *task = [YQDataDownloadTask taskWithURLString:URL.absoluteString cachePath:path parameters:parameters];
    task.completion = completionHandler;
    task.progress = downloadProgressBlock;
    
    BOOL isExist = [self.yq_downTasks containsObject:task]; // 是否已经存在任务
    [self.yq_downTasks addObject:task];                     // 添加任务到数组（无论是否存在都要添加，因为task已重载“isEquel”）
    
    // 如果已经存在该任务， 那么直接返回
    if (isExist) {
        for (YQDataDownloadTask *aTask in self.yq_downTasks) {
            if ([aTask isEqual:task]) {
                task.URLSessionTask = aTask.URLSessionTask;
            }
        }
        return task;
    }
    
    NSURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        for (YQDataDownloadTask *aTask in self.yq_downTasks) {
            if ([aTask isEqual:task] && aTask.progress) {
                aTask.progress(downloadProgress);
            }
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (task.cachePath) {
            return [NSURL fileURLWithPath:task.cachePath];
        }else{
            NSString *fileName = [task.URLString yq_md5Encrypt];
            return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        for (YQDataDownloadTask *aTask in self.yq_downTasks) {
            if ([aTask isEqual:task]) {
                aTask.completion(response, filePath, error);
            }
        }
        // 移除任务
        [self.yq_downTasks removeObject:task];
    }];
    task.URLSessionTask = downloadTask;
    [downloadTask resume];
    
    return task;
}

// 取消下载
- (void)yq_cancelWithTask:(YQDataDownloadTask *)task{
    
    NSInteger taskIndex = NSNotFound;
    for (int i = 0; i < self.yq_downTasks.count; i++) {
        YQDataDownloadTask *aTask = self.yq_downTasks[i];
        if (aTask == task) {
            taskIndex = i;
            break;
        }
    }
    
    if (taskIndex != NSNotFound) {
        [self.yq_downTasks removeObjectAtIndex:taskIndex];
    }
    
    if (![self.yq_downTasks containsObject:task]) {
        [task.URLSessionTask cancel];
    }
}

@end
