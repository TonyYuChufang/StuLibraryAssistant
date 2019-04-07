//
//  SLNetwokrManager.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/22.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLNetwokrManager.h"
#import <AFNetworking/AFNetworking.h>
static NSTimeInterval kSLNetworkDefaultTimeoutInterval = 15;
@interface SLNetwokrManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation SLNetwokrManager

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
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"text/html",@"application/json",@"text/xml",@"application/xml",@"text/json", @"image/jpeg", @"image/png", nil];
        _manager.requestSerializer.timeoutInterval = kSLNetworkDefaultTimeoutInterval;
    }
    
    return self;
}

- (void)setRequestHeaderWithDict:(NSDictionary *)dict
{
    if (dict) {
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString * key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
}

- (void)postWithUrl:(NSString *)url
              param:(NSDictionary *)dict
      completeBlock:(SLNetworkCompleteBlock)block

{
    [self.manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)getWithUrl:(NSString *)url
              param:(NSDictionary *)dict
      completeBlock:(SLNetworkCompleteBlock)block

{
    [self.manager GET:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
