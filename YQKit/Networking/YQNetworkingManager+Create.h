//
//  YQNetworkingManager+Create.h
//  Demo
//
//  Created by maygolf on 16/11/30.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQDataNetworkingManager.h"
#import "YQUploadNetworkingManager.h"
#import "YQDownloadNetworkingManager.h"

@interface YQNetworkingManager (Create)

+ (YQNetworkingManager *)demoDataManagerWithId:(NSInteger)identifier;

+ (YQUploadNetworkingManager *)demoUploadDataManagerMole:(YQUploadMode)mode;

+ (YQDownloadNetworkingManager *)demoDownloadManager;

@end
