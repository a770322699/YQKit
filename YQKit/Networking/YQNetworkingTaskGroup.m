//
//  YQNetworkingTaskGroup.m
//  Demo
//
//  Created by maygolf on 2017/7/12.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQNetworkingTaskGroup.h"

@interface YQNetworkingTaskGroup ()

@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation YQNetworkingTaskGroup

- (instancetype)init{
    if (self = [super init]) {
        _group = dispatch_group_create();
        _queue = dispatch_queue_create("YQNetworkingTaskGroupQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - public
- (void)addTaskWithManager:(YQNetworkingManager *)manager{
    
    YQNetworkingCompletion oldCompletion = manager.completion;
    YQNetworkingCompletion newCompletion = ^(YQNetworkingResult *result){
        if (oldCompletion) {
            oldCompletion(result);
        }
        
        dispatch_group_leave(self.group);
    };
    manager.completion = newCompletion;
    
    dispatch_group_enter(self.group);
    dispatch_async(self.queue, ^{
        [manager start];
    });
}

- (void)start{
    if (self.completion) {
        dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
            self.completion();
        });
    }
}
- (void)startWithCompletion:(YQNetworkingTaskGroupCompletion)completion{
    self.completion = completion;
    [self start];
}

@end
