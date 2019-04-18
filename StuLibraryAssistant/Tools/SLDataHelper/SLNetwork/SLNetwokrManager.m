//
//  SLNetwokrManager.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/22.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLNetwokrManager.h"
#import <AFNetworking/AFNetworking.h>
#import "SLCacheManager.h"
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
        _manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"text/html",@"application/json",@"text/xml",@"application/xml",@"text/json", @"image/jpeg", @"image/png",@"image/bmp", nil];
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

- (void)getWithUrl:(NSString *)url param:(NSDictionary *)dict completeTaskBlock:(SLNetworkCompleteTaskBlock)block
{
    [self.manager GET:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject, nil, task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error, task);
        }
    }];
}

- (void)postWithUrl:(NSString *)url param:(NSDictionary *)dict completeTaskBlock:(SLNetworkCompleteTaskBlock)block
{
    [self.manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject, nil, task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error, task);
        }
    }];
}

- (void)downloadOpacImageWithUrl:(NSString *)imageUrl
                   completeBlock:(SLNetworkCompleteBlock)block
{
    if (imageUrl == nil) {
        if (block) {
            block(nil,nil);
        }
        NSLog(@"{BookCell} imageUrl is null");
        return;
    }
    UIImage *image = [[SLCacheManager sharedObject] objectForKey:imageUrl];
    if (image) {
        if (block) {
            block(image,nil);
        }
    } else {
        [[SLNetwokrManager sharedObject] getWithUrl:imageUrl param:nil completeBlock:^(id responseObject, NSError *error) {
            if (error == nil) {
                UIImage *image = [UIImage imageWithData:responseObject];
                [[SLCacheManager sharedObject] setObject:image forKey:imageUrl];
                if (block) {
                    block(image,nil);
                }
            } else {
                if (block) {
                    block(nil,nil);
                }
                NSLog(@"%@",error);
            }
        }];
    }
}
@end
