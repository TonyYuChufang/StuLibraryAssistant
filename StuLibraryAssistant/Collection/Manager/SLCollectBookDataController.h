//
//  SLCollectBookDataController.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/5.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SLDataQueryCompleteBlock)(id data , NSError *error);
@interface SLCollectBookDataController : NSObject

+ (instancetype)sharedObject;

- (void)queryCollectedBooks:(SLDataQueryCompleteBlock)block;

- (void)queryCollectedBooksWithIncrement:(BOOL)shouldIncrement
                               completed:(SLDataQueryCompleteBlock)block;
@property (nonatomic, strong) NSMutableArray *collectedBooks;
@end

