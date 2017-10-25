//
//  YQModelStore.h
//  CoreDataUse
//
//  Created by maygolf on 16/9/13.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+YQModelStore.h"

static NSString * const kModelStoreConfigDidChangeName = @"kModelStoreConfigDidChangeName";

@protocol YQModelStoreDelegate <NSObject>

- (NSString *)dataBaseNameWithModelStoreIdentity:(NSInteger)identity;
- (NSString *)modelNameWithModelStoreIdentity:(NSInteger)identity;

@end

@interface YQModelStore : NSObject
{
    NSDictionary *_option;
    NSString *_dataBaseName;
    NSString *_modelName;
    NSManagedObjectContext *_bgContext;
    NSManagedObjectContext *_mainContext;
}

@property (nonatomic, readonly) NSString *modelName;                        // 模型文件名称
@property (nonatomic, readonly) NSString *dataBaseName;                     // 数据库名称
@property (nonatomic, readonly) NSManagedObjectContext *bgContext;
@property (nonatomic, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic, weak) id<YQModelStoreDelegate> delegate;

// 返回一个单例对象（每个identity对应同一个对象）
+ (__kindof YQModelStore *)modelStoreWithIdentity:(NSInteger)identity;

- (void)saveContexts;
- (NSManagedObjectContext *)createPrivateObjecteContext;
- (void)reset;  // 重新设置modelName和DataBaseName

@end
