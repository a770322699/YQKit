//
//  YQModelStore.m
//  CoreDataUse
//
//  Created by maygolf on 16/9/13.
//  Copyright © 2016年 yiquan. All rights reserved.
//

#import "YQModelStore.h"

static NSMutableDictionary *modelStores = nil;

@interface YQModelStore ()

@property (nonatomic, assign) NSInteger identity;

@end

@implementation YQModelStore

- (instancetype)init{
    if (self = [super init]) {
        _option = @{NSInferMappingModelAutomaticallyOption : @(YES),
                    NSMigratePersistentStoresAutomaticallyOption : @(YES)};
    }
    return self;
}

// 返回一个单例对象
+ (__kindof YQModelStore *)modelStoreWithIdentity:(NSInteger)identity{
    static NSString *lock = @"YQModelStoreAdd";
    @synchronized (lock) {
        id key = @(identity);
        YQModelStore *modelStore = modelStores[key];
        if (!modelStore) {
            modelStore = [[self alloc] init];
            modelStore.identity = identity;
            [modelStores setObject:modelStore forKey:key];
        }
        return modelStore;
    }
}

#pragma mark - getter
- (NSManagedObjectContext *)bgContext{
    @synchronized (self) {
        if (!_bgContext) {
            NSManagedObjectModel *model = nil;
            if (self.modelName) {
                NSURL *modelPath = [[NSBundle mainBundle] URLForResource:self.modelName withExtension:@"momd"];
                model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
            }
            
            NSPersistentStoreCoordinator *coordinator = nil;
            if (model && self.dataBaseName) {
                coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
                
                NSURL *dataBasePath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
                dataBasePath = [dataBasePath URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.dataBaseName]];
                
                if (![self persistenStoreCoordinator:coordinator addPersistentStore:dataBasePath]) {
                    coordinator = nil;
                }
            }
            
            if (coordinator) {
                _bgContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                _bgContext.persistentStoreCoordinator = coordinator;
            }
        }
        
        return _bgContext;
    }
}

- (NSManagedObjectContext *)mainContext{
    @synchronized (self) {
        if (!_mainContext && self.bgContext) {
            _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            _mainContext.parentContext = self.bgContext;
        }
        return _mainContext;
    }
}

- (NSString *)modelName{
    if (!_modelName) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(modelNameWithModelStoreIdentity:)]) {
            _modelName = [self.delegate modelNameWithModelStoreIdentity:self.identity];
        }
    }
    return _modelName;
}

- (NSString *)dataBaseName{
    if (!_dataBaseName) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataBaseNameWithModelStoreIdentity:)]) {
            _dataBaseName = [self.delegate dataBaseNameWithModelStoreIdentity:self.identity];
        }
    }
    return _dataBaseName;
}

#pragma mark - private
// 给NSPersistentStoreCoordinator添加PersistentStore， 若因为模型和原有数据库不对应而添加失败，自动删除数据库后重新添加
- (BOOL)persistenStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator addPersistentStore:(NSURL *)dataBasePath{
    NSString *filePath = dataBasePath.absoluteString;
    NSString *prefix = @"file://";
    if ([filePath hasPrefix:prefix]) {
        filePath = [filePath substringFromIndex:[prefix length]];
    }
    BOOL dataBaseExit = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    NSPersistentStore *success = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:dataBasePath
                                                   options:_option
                                                     error:NULL];
    if (!success && dataBaseExit) {
        BOOL removed = [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        if (removed) {
            return [self persistenStoreCoordinator:coordinator addPersistentStore:dataBasePath];
        }
    }
    
    return success != nil;
}

#pragma mark - public
- (void)saveContexts{
    [self.mainContext saveCompletion:nil];
}

- (NSManagedObjectContext *)createPrivateObjecteContext{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = self.mainContext;
    
    return context;
}

- (void)reset{
    [self saveContexts];
    
    @synchronized (self) {
        _modelName = nil;
        _dataBaseName = nil;
        _mainContext = nil;
        _bgContext = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kModelStoreConfigDidChangeName object:self];
    }
}

@end
