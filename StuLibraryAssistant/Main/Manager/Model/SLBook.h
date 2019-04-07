//
//  SLBook.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/20.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLBookListItem : NSObject

@property (nonatomic, copy) NSString *AUTHOR;
@property (nonatomic, copy) NSString *CALLNOS;
@property (nonatomic, copy) NSString *COVER;
@property (nonatomic, copy) NSString *CLICKCOUNT;
@property (nonatomic, copy) NSString *CLICKSORT;
@property (nonatomic, copy) NSString *COLLECTED;
@property (nonatomic, copy) NSString *COLLECTEDECOUNT;
@property (nonatomic, copy) NSString *COLLECTEDSORT;
@property (nonatomic, copy) NSString *COLLECTION;
@property (nonatomic, copy) NSString *CTRLNO;
@property (nonatomic, copy) NSString *DISK;
@property (nonatomic, copy) NSString *JOURNALFLAG;
@property (nonatomic, copy) NSString *LASTBOOK;
@property (nonatomic, copy) NSString *LEND;
@property (nonatomic, copy) NSString *LENDABLE;
@property (nonatomic, copy) NSString *LOAN;
@property (nonatomic, copy) NSString *LOANCOUNT;
@property (nonatomic, copy) NSString *LOANSORT;
@property (nonatomic, copy) NSString *ORDERED;
@property (nonatomic, copy) NSString *PUBDATE;
@property (nonatomic, copy) NSString *PUBLISHER;
@property (nonatomic, copy) NSString *SCORE;
@property (nonatomic, copy) NSString *SCOREPERSONCOUNT;
@property (nonatomic, copy) NSString *TITLE;
@property (nonatomic, copy) NSString *TYPE;
@property (nonatomic, copy) NSString *UNLENDABLE;

@end

@interface SLBookDetailItem : NSObject

@end
