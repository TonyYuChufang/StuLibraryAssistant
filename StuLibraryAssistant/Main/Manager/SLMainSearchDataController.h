//
//  SLMainSearchDataController.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/21.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SLDataQueryCompleteBlock)(id data , NSError *error);
@interface SLMainSearchDataController : NSObject

+ (instancetype)sharedObject;

- (void)requestOpacSessionIDWithBlock:(SLDataQueryCompleteBlock)block;

- (void)queryBookWithText:(NSString *)text
                     page:(int64_t)page
                     rows:(int64_t)rows
          shouldIncrement:(BOOL)shouldIncrement;

- (void)loadMoreBookLists;
- (void)queryVirtualLibraryInfo:(SLDataQueryCompleteBlock)block;
@property (nonatomic, strong) NSMutableArray *bookItemList;
@end
