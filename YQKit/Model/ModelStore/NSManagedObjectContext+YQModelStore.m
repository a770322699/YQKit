//
//  NSManagedObjectContext+YQModelStore.m
//  CoreDataUse
//
//  Created by maygolf on 16/9/14.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSManagedObjectContext+YQModelStore.h"

@implementation NSManagedObjectContext (YQModelStore)

- (void)saveCompletion:(void (^)(NSError *error))completion{
    [self performBlock:^{
        NSError *error = nil;
        if ([self hasChanges]) {
            [self save:&error];
        }
        
        if (error) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);
                });
            }
            return;
        }
        
        if (self.parentContext) {
            [self.parentContext saveCompletion:completion];
        }else if (completion){
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
        }
    }];
}

@end
