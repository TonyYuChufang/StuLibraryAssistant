//
//  SLMemoryCahce.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCache.h"

typedef void (^SLCacheManagerBlock)();
typedef void (^SLCacheManagerObjectBlock)(NSString *key, id object);


@interface SLMemoryCahce : NSObject

@property (nonatomic, strong) YYMemoryCache *cache;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjcetForKey:(NSString *)key;
- (void)removerAllObject:(SLCacheManagerObjectBlock)block;

@end


