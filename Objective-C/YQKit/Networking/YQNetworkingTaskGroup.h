//
//  YQNetworkingTaskGroup.h
//  Demo
//
//  Created by maygolf on 2017/7/12.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YQNetworkingManager.h"

typedef void(^YQNetworkingTaskGroupCompletion)();

@interface YQNetworkingTaskGroup : NSObject

@property (nonatomic, copy) YQNetworkingTaskGroupCompletion completion; // 所有任务执行完毕

- (void)addTaskWithManager:(YQNetworkingManager *)manager;

- (void)start;
- (void)startWithCompletion:(YQNetworkingTaskGroupCompletion)completion;

@end
