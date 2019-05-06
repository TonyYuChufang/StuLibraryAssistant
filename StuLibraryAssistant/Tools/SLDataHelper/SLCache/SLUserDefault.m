//
//  SLUserDefault.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/6.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLUserDefault.h"
@interface SLUserDefault ()

@property (nonatomic, strong) NSUserDefaults *userDefault;

@end

@implementation SLUserDefault

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
        self.userDefault = [[NSUserDefaults standardUserDefaults] init];
    }
    
    return self;
}

- (id)objectForKey:(NSString *)key
{
    return [self.userDefault objectForKey:key];
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    [self.userDefault setObject:object forKey:key];
    [self.userDefault synchronize];
}

- (void)removeObejctForKey:(NSString *)key
{
    [self.userDefault removeObjectForKey:key];
    [self.userDefault synchronize];
}

@end
