//
//  SLMainSearchDataController.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/21.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLMainSearchDataController : NSObject

+ (instancetype)sharedObject;

- (void)requestOpacSessionID;

- (void)queryBookWithText:(NSString *)text
                     page:(int64_t)page
                     rows:(int64_t)rows
          shouldIncrement:(BOOL)shouldIncrement;

- (void)loadMoreBookLists;
@property (nonatomic, strong) NSMutableArray *bookItemList;
@end
