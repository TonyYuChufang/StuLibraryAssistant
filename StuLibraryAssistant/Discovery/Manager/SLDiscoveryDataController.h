//
//  SLDiscoveryDataController.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/5.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SLDataQueryCompleteBlock)(id data , NSError *error);
@interface SLDiscoveryDataController : NSObject

+ (instancetype)sharedObject;
- (void)queryNewBooks:(SLDataQueryCompleteBlock)block;

@property (nonatomic, strong) NSMutableArray *books;
@end

