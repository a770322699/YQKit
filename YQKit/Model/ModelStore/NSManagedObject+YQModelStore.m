//
//  NSManagedObject+YQModelStore.m
//  CoreDataUse
//
//  Created by maygolf on 16/9/14.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "NSManagedObject+YQModelStore.h"

@implementation NSManagedObject (YQModelStore)

#pragma mark - need override
- (void)formatterWithDictionary:(NSDictionary *)item{
    
}

#pragma mark - private
+ (NSString *)entityName{
    return NSStringFromClass([self class]);
}

+ (NSFetchRequest *)makeRequest:(NSManagedObjectContext *)context
                      predicate:(NSPredicate *)predicate
                        orderby:(NSArray *)orders
                         offset:(NSInteger)offset
                          limit:(NSInteger)limit{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context]];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    if (orders.count) {
        [fetchRequest setSortDescriptors:orders];
    }
    if (offset > 0) {
        [fetchRequest setFetchOffset:offset];
    }
    if (limit > 0) {
        [fetchRequest setFetchLimit:limit];
    }
    
    return fetchRequest;
}

#pragma mark - public
// 保存(异步)
- (void)save{
    [self save:nil];
}
// completion会在主线程中执行（异步）
- (void)save:(void (^)(NSError *error))completion{
    [self.managedObjectContext saveCompletion:completion];
}

#pragma mark - 增
// 创建一个实体，必须在context所在的线程上创建
+ (id)createNewInContext:(NSManagedObjectContext *)context{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
}

// 插入单条数据(同步)
+ (id)insertObject:(NSDictionary *)objectProperty toContext:(NSManagedObjectContext *)context{
    id newObject = [self createNewInContext:context];
    [newObject formatterWithDictionary:objectProperty];
    return newObject;
}
// 插入多条数据(同步)
+ (NSArray *)insertObjects:(NSArray<NSDictionary *> *)objectPropertys
                 toContext:(NSManagedObjectContext *)context
        everyOneCompletion:(void(^)(__kindof NSManagedObject *object))completion{
    NSMutableArray *resultObjects = nil;
    for (NSDictionary *objectProperty in objectPropertys) {
        id object = [self insertObject:objectProperty toContext:context];
        if (resultObjects == nil) {
            resultObjects = [NSMutableArray array];
        }
        [resultObjects addObject:object];
        
        if (completion) {
            completion(object);
        }
    }
    return resultObjects;
}

// 插入单条数据(异步)
+ (void)insertObject:(NSDictionary *)objectProperty
        toModelStore:(YQModelStore *)modelStore
          completion:(void (^)(id object))completion{
    NSManagedObjectContext *bgContext = [modelStore createPrivateObjecteContext];
    [bgContext performBlock:^{
        __kindof NSManagedObject *object = [self insertObject:objectProperty toContext:bgContext];
        [bgContext save:NULL];
        
        if (completion) {
            NSManagedObjectID *objectID = object.objectID;
            [modelStore.mainContext performBlock:^{
                completion([modelStore.mainContext objectWithID:objectID]);
            }];
        }
        [object save];
    }];
}

// 插入多条数据(异步)
// 注意：everyOneCompletion在异步线程中执行
+ (void)insertObjects:(NSArray<NSDictionary *> *)objectPropertys
         toModelStore:(YQModelStore *)modelStore
   everyOneCompletion:(void(^)(__kindof NSManagedObject *object))everyOneCompletion
           completion:(void (^)(NSArray *objects))completion{
    NSManagedObjectContext *bgContext = [modelStore createPrivateObjecteContext];
    [bgContext performBlock:^{
        NSArray *objects = [self insertObjects:objectPropertys
                                     toContext:bgContext
                            everyOneCompletion:everyOneCompletion];
        [bgContext save:NULL];
        
        if (completion) {
            NSArray *objectIDs = [objects valueForKey:@"objectID"];
            [modelStore.mainContext performBlock:^{
                NSMutableArray *resultObjects = nil;
                for (NSManagedObjectID *objectID in objectIDs) {
                    id resultObject = [modelStore.mainContext objectWithID:objectID];
                    if (resultObjects == nil) {
                        resultObjects = [NSMutableArray array];
                    }
                    [resultObjects addObject:resultObject];
                }
                
                completion(resultObjects);
            }];
        }
        
        [bgContext saveCompletion:nil];
    }];
}

#pragma mark - 删
// 删除（同步）
+ (void)deleteObject:(NSPredicate *)predicate fromManagerObjectContext:(NSManagedObjectContext *)context{
    NSArray *objects = [self objectsFromMnagerObjectContext:context predicate:predicate error:NULL];
    for (NSManagedObject *object in objects) {
        [context deleteObject:object];
    }
}

// 删除(异步)
+ (void)deleteObject:(NSPredicate *)predicate fromModelStore:(YQModelStore *)store completion:(void (^)())completion{
    NSManagedObjectContext *bgContext = [store createPrivateObjecteContext];
    [bgContext performBlock:^{
        [self deleteObject:predicate fromManagerObjectContext:bgContext];
        [bgContext save:NULL];
        
        if (completion) {
            [store.mainContext performBlock:^{
                completion();
            }];
        }
        
        [bgContext saveCompletion:nil];
    }];
}

#pragma mark - 改
// 更新数据（同步）
+ (id)updateObject:(NSDictionary *)objectProperty inManagerObjectContext:(NSManagedObjectContext *)context
         predicate:(NSPredicate *)predication
             model:(YQUpdateModel)model{
    NSManagedObject *object = [self oneObjecteFromManagerObjectContext:context predicate:predication  error:NULL];
    if (object && model == YQUpdateModel_delete) {
        [object.managedObjectContext deleteObject:object];
        object = nil;
    }
    
    if (!object) {
        object = [self createNewInContext:context];
    }
    [object formatterWithDictionary:objectProperty];
    
    return object;
}

// 更新数据(异步)
+ (void)updateObject:(NSDictionary *)objectProperty
        inModelStore:(YQModelStore *)modelStore
           predicate:(NSPredicate *)predication
               model:(YQUpdateModel)model
          completion:(void (^)(__kindof NSManagedObject *object))completion{
    NSManagedObjectContext *bgContext = [modelStore createPrivateObjecteContext];
    [bgContext performBlock:^{
        __kindof NSManagedObject *object = [self updateObject:objectProperty
                                       inManagerObjectContext:bgContext
                                                    predicate:predication
                                                        model:model];
        [bgContext save:NULL];
        
        if (completion) {
            NSManagedObjectID *objectID = object.objectID;
            [modelStore.mainContext performBlock:^{
                completion([modelStore.mainContext objectWithID:objectID]);
            }];
        }
        
        [bgContext saveCompletion:nil];
    }];
}

#pragma mark - 查
// 同步获取
+ (NSArray *)objectsFromMnagerObjectContext:(NSManagedObjectContext *)context
                                  predicate:(NSPredicate *)predicate
                                    orderby:(NSArray *)orders
                                     offset:(NSInteger)offset
                                      limit:(NSInteger)limit
                                      error:(NSError **)error{
    NSFetchRequest *fetchRequest = [self makeRequest:context
                                           predicate:predicate
                                             orderby:orders
                                              offset:offset
                                               limit:limit];
    NSArray *results = [context executeFetchRequest:fetchRequest error:error];
    if (error && *error) {
        NSLog(@"%@", *error);
    }
    
    return results;
}

+ (NSArray *)objectsFromMnagerObjectContext:(NSManagedObjectContext *)context
                                  predicate:(NSPredicate *)predicate
                                      error:(NSError **)error{
    return [self objectsFromMnagerObjectContext:context
                                      predicate:predicate
                                        orderby:nil
                                         offset:0
                                          limit:0
                                          error:error];
}

+ (id)oneObjecteFromManagerObjectContext:(NSManagedObjectContext *)context
                               predicate:(NSPredicate *)predicate
                                   error:(NSError **)error{
    NSArray *resultObjects = [self objectsFromMnagerObjectContext:context predicate:predicate error:error];
    if (resultObjects.count > 1) {
        NSLog(@"%@<获取到多条数据>", predicate);
        NSArray *shouldDeleteObjects = [resultObjects subarrayWithRange:NSMakeRange(0, resultObjects.count - 1)];
        [shouldDeleteObjects enumerateObjectsUsingBlock:^(NSManagedObject *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.managedObjectContext deleteObject:obj];
        }];
    }
    return [resultObjects lastObject];
}

// 异步获取
+ (void)objectsFromModelStore:(YQModelStore *)modelStore
                    predicate:(NSPredicate *)predicate
                      orderby:(NSArray *)orders
                       offset:(NSInteger)offset
                        limit:(NSInteger)limit
                   completion:(YQFetchListResult)completion{
    
    NSFetchRequest *fetchRequest = [self makeRequest:modelStore.mainContext
                                           predicate:predicate
                                             orderby:orders
                                              offset:offset
                                               limit:limit];
    __block NSError *error = nil;
    NSAsynchronousFetchRequest *asycFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult * _Nonnull result) {
        if (completion) {
            completion(result.finalResult, error);
        }
    }];
    [modelStore.mainContext executeRequest:asycFetchRequest error:&error];
    
    //NSManagedObjectContext *bgContext = [modelStore createPrivateObjecteContext];
    //[bgContext performBlock:^{
    
    //NSError *error = nil;
    //NSArray *objects = [self objectsFromMnagerObjectContext:bgContext
    //predicate:predicate
    //orderby:orders
    //offset:offset
    //limit:limit
    //error:&error];
    //NSArray *objectIDs = [objects valueForKey:@"objectID"];
    //if (completion) {
    //[modelStore.mainContext performBlock:^{
    //NSMutableArray *resultObjects = nil;
    //for (NSManagedObjectID *objectID in objectIDs) {
    //id resultObject = [modelStore.mainContext objectWithID:objectID];
    //if (resultObjects == nil) {
    //resultObjects = [NSMutableArray array];
    //}
    //[resultObjects addObject:resultObject];
    //}
    //completion(resultObjects, error);
    //}];
    //}
    //}];
}

+ (void)objectsFromModelStore:(YQModelStore *)modelStore
                    predicate:(NSPredicate *)predicate
                   completion:(YQFetchListResult)completion{
    [self objectsFromModelStore:modelStore
                      predicate:predicate
                        orderby:nil offset:0
                          limit:0
                     completion:completion];
}

+ (void)oneObjectFromModelStore:(YQModelStore *)modelStore predicate:(NSPredicate *)predicate completion:(YQFetchOneResult)completion{
    
    [self objectsFromModelStore:modelStore
                      predicate:predicate
                     completion:^(NSArray *objects, NSError *error) {
                         if (objects.count > 1) {
                             NSLog(@"%@<获取到多条数据>", predicate);
                         }
                         if (completion) {
                             completion([objects lastObject], error);
                         }
                     }];
}

@end
