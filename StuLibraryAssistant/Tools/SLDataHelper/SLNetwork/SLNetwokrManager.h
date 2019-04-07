//
//  SLNetwokrManager.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/22.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SLNetworkCompleteBlock)(id responseObject, NSError *error);

@interface SLNetwokrManager : NSObject

+ (instancetype)sharedObject;

- (void)setRequestHeaderWithDict:(NSDictionary *)dict;

- (void)postWithUrl:(NSString *)url
             param:(NSDictionary *)dict
     completeBlock:(SLNetworkCompleteBlock)block;

- (void)getWithUrl:(NSString *)url
             param:(NSDictionary *)dict
     completeBlock:(SLNetworkCompleteBlock)block;

@end

