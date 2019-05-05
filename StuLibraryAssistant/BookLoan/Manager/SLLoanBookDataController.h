//
//  SLLoanBookDataController.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/4.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SLDataQueryCompleteBlock)(id data , NSError *error);

@interface SLLoanBookDataController : NSObject

+ (instancetype)sharedObject;

@property (nonatomic, strong) NSMutableArray *currentLoanBooks;
@property (nonatomic, strong) NSMutableArray *historyLoanBooks;

- (void)queryCurrentLoanBooksWithIncrement:(BOOL)shouldIncrement
                                   completed:(SLDataQueryCompleteBlock)block;

- (void)queryHistoryLoanBooksWithIncrement:(BOOL)shouldIncrement
                                 completed:(SLDataQueryCompleteBlock)block;
@end

