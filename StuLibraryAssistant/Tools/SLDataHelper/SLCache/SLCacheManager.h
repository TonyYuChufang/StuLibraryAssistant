//
//  SLCacheManager.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLMemoryCahce.h"

@interface SLCacheManager : NSObject

@property (nonatomic, strong) SLMemoryCahce *memoryCache;

+ (SLMemoryCahce *)createMemoryCache;

+ (instancetype)sharedObject;

- (uint64_t)diskTotalCost;

- (id)objectForKey:(NSString *)key;

- (void)objectForKey:(NSString *)key block:(SLCacheManagerObjectBlock)block;

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key block:(SLCacheManagerObjectBlock)block;

- (void)removeObejctForKey:(NSString *)key;

- (void)removeObejctForKey:(NSString *)key block:(SLCacheManagerObjectBlock)block;

- (void)removeAllObjects:(SLCacheManagerObjectBlock)block;
@end

