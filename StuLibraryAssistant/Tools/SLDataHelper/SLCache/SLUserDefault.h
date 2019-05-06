//
//  SLUserDefault.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/6.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLCacheKey.h"
@interface SLUserDefault : NSObject

+ (instancetype)sharedObject;

- (id)objectForKey:(NSString *)key;

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;

- (void)removeObejctForKey:(NSString *)key;

@end

