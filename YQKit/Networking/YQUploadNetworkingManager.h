//
//  YQUploadNetworkingManager.h
//  Demo
//
//  Created by maygolf on 16/12/1.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQNetworkingManager.h"

typedef NS_ENUM(NSInteger, YQUploadDataSourceType) {
    YQUploadDataSourceType_data,
    YQUploadDataSourceType_path,
};

@interface YQUploadData : NSObject

@property (nonatomic, assign) YQUploadDataSourceType sourceType;        // 数据源类型
@property (nonatomic, strong) NSString *mineType;                       // 内容类型
@property (nonatomic, strong) NSString *dataPath;                       // 数据地址
@property (nonatomic, strong) NSData *data;                             // 数据
@property (nonatomic, strong) NSString *name;                           // 和后台约定的name
@property (nonatomic, strong) NSString *fileName;                       // 文件名称

@end

/***********************************************************************************************/
/***********************************************************************************************/

typedef NS_ENUM(NSInteger, YQUploadMode) {
    YQUploadMode_multipartFormData,
    YQUploadMode_base64,
};

@interface YQUploadNetworkingManager : YQNetworkingManager

@property (nonatomic, assign) YQUploadMode uploadMode;          // 上传方式
@property (nonatomic, strong) NSArray<YQUploadData *> *datas;   // 需要上传的数据

@property (nonatomic, assign) BOOL base64UseArrayWhenSingle;   // 当只有单一数据的时候，用base64上传是否使用数组形式，默认为no

@end
