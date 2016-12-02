//
//  YQNetworkingManager+Create.m
//  Demo
//
//  Created by maygolf on 16/11/30.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQNetworkingManager+Create.h"

@implementation YQNetworkingManager (Create)

+ (YQNetworkingManager *)demoDataManagerWithId:(NSInteger)identifier{
    YQNetworkingManager *manager = [YQNetworkingManager dataManager];
    
    manager.parameters = nil;
    manager.method = YQNetworkingMethod_get;
    manager.URLString = @"/api/Service/GetServiceList";
    
    return manager;
}

+ (YQUploadNetworkingManager *)demoUploadDataManagerMole:(YQUploadMode)mode{
    YQUploadNetworkingManager *manager = [YQNetworkingManager uploadManager];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"ask" forKey:@"pType"];
    [dic setValue:@18 forKey:@"userId"];
    
    manager.parameters = dic;
    manager.base64UseArrayWhenSingle = YES;
    manager.method = YQNetworkingMethod_post;
    manager.URLString = @"/api/QuestionInfo/PostUploadFileName";
    manager.uploadMode = YQUploadMode_base64;
    
    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"image1.jpg"], 0.6);
    YQUploadData *uploadData = [[YQUploadData alloc] init];
    uploadData.data = data;
    uploadData.sourceType = YQUploadDataSourceType_data;
    uploadData.name = @"files";
    uploadData.mineType = @"image/jpg";
    
    manager.datas = @[uploadData];
    
    return manager;
}

+ (YQDownloadNetworkingManager *)demoDownloadManager{
    YQDownloadNetworkingManager *manager = [YQNetworkingManager downloadManager];
    manager.URLString = @"http://mm.howkuai.com/wp-content/uploads/2016a/09/01/01.jpg";
    manager.path = @"/Users/maygolf/Desktop/testImage.jpg";
    
    return manager;
}

@end
