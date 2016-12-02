//
//  YQDownloadNetworkingManager.h
//  Demo
//
//  Created by maygolf on 16/12/1.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQNetworkingManager.h"

@interface YQDownloadNetworkingManager : YQNetworkingManager

@property (nonatomic, strong) NSString *path;                       // 文件存储地址，若为nil，结果已NSData的形式返回在结果中

@end
