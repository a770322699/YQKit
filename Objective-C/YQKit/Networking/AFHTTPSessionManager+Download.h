//
//  AFHTTPSessionManager+Download.h
//  Demo
//
//  Created by maygolf on 16/12/2.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@class YQDataDownloader;
@interface YQDataDownloadTask : NSObject

@property (nonatomic, strong) NSString *URLString;
@property (nonatomic, strong) NSString *cachePath;
@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, weak) YQDataDownloader *downloader;

@end

/***********************************************************************************************/
/***********************************************************************************************/

typedef void(^YQDataDownloadProgress)(NSProgress *progress);
typedef void(^YQDataDownloadCompletion)(NSURLResponse *response, NSURL *filePath, NSError *error);

@interface AFHTTPSessionManager (Download)

// 下载数据
- (YQDataDownloadTask *)yq_downloadData:(NSString *)URLString
                             parameters:(nullable id)parameters
                            destination:(NSString *)path
                               progress:(YQDataDownloadProgress) downloadProgressBlock
                      completionHandler:(YQDataDownloadCompletion)completionHandler;

// 取消下载
- (void)yq_cancelWithTask:(YQDataDownloadTask *)task;

@end

NS_ASSUME_NONNULL_END
