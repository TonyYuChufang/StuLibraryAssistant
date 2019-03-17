//
//  SLCacheManager.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLCacheManager.h"

@interface SLCacheManager ()

@property (nonatomic, strong) YYCache *cache;

@end
@implementation SLCacheManager
+ (instancetype)sharedObject
{
    static id sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init
{
    if (self = [super init]) {
        _cache = [[YYCache alloc] initWithName:NSStringFromClass([self class])];
        _cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        _memoryCache = [[SLMemoryCahce alloc] init];
        _memoryCache.cache = _cache.memoryCache;
    }
    
    return self;
}

+ (SLMemoryCahce *)createMemoryCache;
{
    SLMemoryCahce *memoryCache = [[SLMemoryCahce alloc] init];
    return memoryCache;
}


#pragma mark - Public
- (uint64_t)diskTotalCost
{
    return [self.cache.diskCache totalCost];
}

- (id)objectForKey:(NSString *)key
{
    return [self.cache objectForKey:key];
}

- (void)objectForKey:(NSString *)key block:(SLCacheManagerObjectBlock)block
{
    [self.cache objectForKey:key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        if (block) {
            block(key, object);
        }
    }];
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    [self.cache setObject:object forKey:key withBlock:nil];
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key block:(SLCacheManagerObjectBlock)block
{
    [self.cache setObject:object forKey:key withBlock:^{
        if (block) {
            block(key, object);
        }
    }];
}

- (void)removeObejctForKey:(NSString *)key
{
    [self.cache removeObjectForKey:key];
}

-(void)removeObejctForKey:(NSString *)key block:(SLCacheManagerObjectBlock)block
{
    [self.cache removeObjectForKey:key withBlock:^(NSString * _Nonnull key) {
        if (block) {
            block(nil,nil);
        }
    }];
}

- (void)removeAllObjects:(SLCacheManagerObjectBlock)block
{
    [self.cache removeAllObjectsWithBlock:^{
        if (block) {
            block(nil,nil);
        }
    }];
}

@end
