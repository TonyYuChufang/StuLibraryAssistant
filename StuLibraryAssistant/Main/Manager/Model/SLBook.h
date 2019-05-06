//
//  SLBook.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/20.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SLLoanBook;
@class SLCollectedBook;
@interface SLBookListItem : NSObject

+ (SLBookListItem *)bookListItemWithLoanBook:(SLLoanBook *)loanBook;
+ (SLBookListItem *)bookListItemWithCollectBook:(SLCollectedBook *)collectBook;

@property (nonatomic, copy) NSString *AUTHOR;
@property (nonatomic, assign) int64_t BOOKLISTCOUNT;
@property (nonatomic, copy) NSString *CALLNOS;
@property (nonatomic, copy) NSString *COVER;
@property (nonatomic, assign) int64_t CLICKCOUNT;
@property (nonatomic, copy) NSString *CLICKSORT;
@property (nonatomic, assign) BOOL COLLECTED;
@property (nonatomic, assign) int64_t COLLECTEDECOUNT;
@property (nonatomic, copy) NSString *COLLECTEDSORT;
@property (nonatomic, assign) int64_t COLLECTION;
@property (nonatomic, copy) NSString *CTRLNO;
@property (nonatomic, copy) NSString *DISK;
@property (nonatomic, copy) NSString *JOURNALFLAG;
@property (nonatomic, copy) NSString *LASTBOOK;
@property (nonatomic, assign) int64_t LEND;
@property (nonatomic, assign) int64_t LENDABLE;
@property (nonatomic, assign) BOOL LOAN;
@property (nonatomic, assign) int64_t LOANCOUNT;
@property (nonatomic, copy) NSString *LOANSORT;
@property (nonatomic, copy) NSString *OBJID;
@property (nonatomic, assign) BOOL ORDERED;
@property (nonatomic, copy) NSString *PUBDATE;
@property (nonatomic, copy) NSString *PUBLISHER;
@property (nonatomic, assign) int64_t SCOREPERSONCOUNT;
@property (nonatomic, assign) float SCORE;
@property (nonatomic, assign) int64_t UNLENDABLE;
@property (nonatomic, copy) NSString *TITLE;
@property (nonatomic, copy) NSString *UPDATE_DATE;

@end

@interface SLBookDetailItem : NSObject

@end
