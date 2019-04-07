//
//  SLMemoryCahce.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLMemoryCahce.h"
@interface SLMemoryCahce ()


@end

@implementation SLMemoryCahce

- (instancetype)init
{
    if (self = [super init]) {
        _cache = [[YYMemoryCache alloc] init];
        _cache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    }
    
    return self;
}

- (id)objectForKey:(NSString *)key
{
    return [_cache objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    [_cache setObject:object forKey:key];
}

- (void)removeObjcetForKey:(NSString *)key
{
    [_cache removeObjectForKey:key];
}

- (void)removerAllObject:(SLCacheManagerObjectBlock)block
{
    [_cache removeAllObjects];
    
    if (block) {
        block(nil,nil);
    }
}
@end


