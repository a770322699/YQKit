//
//  NSManagedObject+YQModelStore.h
//  CoreDataUse
//
//  Created by maygolf on 16/9/14.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "YQModelStore.h"

typedef void(^YQFetchListResult)(NSArray *objects, NSError *error);
typedef void(^YQFetchOneResult)(id object, NSError *error);

// 更新模式
typedef NS_ENUM(NSInteger, YQUpdateModel) {
    YQUpdateModel_nomal,                        // 有则更新，无则插入
    YQUpdateModel_delete,                       // 有则删除后插入，无则直接插入
};

@interface NSManagedObject (YQModelStore)

#pragma mark - need override
- (void)formatterWithDictionary:(NSDictionary *)item;

#pragma mark - public
// 保存(异步)
- (void)save;
// completion会在主线程中执行（异步）
- (void)save:(void (^)(NSError *error))completion;

#pragma mark - 增
// 创建一个实体，必须在context所在的线程上创建
+ (id)createNewInContext:(NSManagedObjectContext *)context;

// 插入单条数据(同步)
+ (id)insertObject:(NSDictionary *)objectProperty toContext:(NSManagedObjectContext *)context;

// 插入多条数据(同步)
+ (NSArray *)insertObjects:(NSArray<NSDictionary *> *)objectPropertys
                 toContext:(NSManagedObjectContext *)context
        everyOneCompletion:(void(^)(__kindof NSManagedObject *object))completion;

// 插入单条数据(异步)
+ (void)insertObject:(NSDictionary *)objectProperty
        toModelStore:(YQModelStore *)modelStore
          completion:(void (^)(id object))completion;

// 插入多条数据(异步)
+ (void)insertObjects:(NSArray<NSDictionary *> *)objectPropertys
         toModelStore:(YQModelStore *)modelStore
   everyOneCompletion:(void(^)(__kindof NSManagedObject *object))everyOneCompletion
           completion:(void (^)(NSArray *objects))completion;

#pragma mark - 删
// 删除（同步）
+ (void)deleteObject:(NSPredicate *)predicate fromManagerObjectContext:(NSManagedObjectContext *)context;
// 删除(异步)
+ (void)deleteObject:(NSPredicate *)predicate fromModelStore:(YQModelStore *)store completion:(void (^)())completion;

#pragma mark - 改
// 更新数据（同步）
+ (id)updateObject:(NSDictionary *)objectProperty inManagerObjectContext:(NSManagedObjectContext *)context
         predicate:(NSPredicate *)predication
             model:(YQUpdateModel)model;

// 更新数据(异步)
+ (void)updateObject:(NSDictionary *)objectProperty
        inModelStore:(YQModelStore *)modelStore
           predicate:(NSPredicate *)predication
               model:(YQUpdateModel)model
          completion:(void (^)(__kindof NSManagedObject *object))completion;

#pragma mark - 查
// 同步获取
+ (NSArray *)objectsFromMnagerObjectContext:(NSManagedObjectContext *)context
                                  predicate:(NSPredicate *)predicate
                                    orderby:(NSArray *)orders
                                     offset:(NSInteger)offset
                                      limit:(NSInteger)limit
                                      error:(NSError **)error;

+ (NSArray *)objectsFromMnagerObjectContext:(NSManagedObjectContext *)context
                                  predicate:(NSPredicate *)predicate
                                      error:(NSError **)error;

+ (id)oneObjecteFromManagerObjectContext:(NSManagedObjectContext *)context
                               predicate:(NSPredicate *)predicate
                                   error:(NSError **)error;
// 异步获取
+ (void)objectsFromModelStore:(YQModelStore *)modelStore
                    predicate:(NSPredicate *)predicate
                      orderby:(NSArray *)orders
                       offset:(NSInteger)offset
                        limit:(NSInteger)limit
                   completion:(YQFetchListResult)completion;

+ (void)objectsFromModelStore:(YQModelStore *)modelStore
                    predicate:(NSPredicate *)predicate
                   completion:(YQFetchListResult)completion;

+ (void)oneObjectFromModelStore:(YQModelStore *)modelStore predicate:(NSPredicate *)predicate completion:(YQFetchOneResult)completion;

@end
