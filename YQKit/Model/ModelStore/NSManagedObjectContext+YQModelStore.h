//
//  NSManagedObjectContext+YQModelStore.h
//  CoreDataUse
//
//  Created by maygolf on 16/9/14.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (YQModelStore)

- (void)saveCompletion:(void (^)(NSError *error))completion;

@end
