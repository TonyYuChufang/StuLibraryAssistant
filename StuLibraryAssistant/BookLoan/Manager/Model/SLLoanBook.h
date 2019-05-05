//
//  SLLoanBook.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/4.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLLoanBook : NSObject
@property (nonatomic, copy) NSString *assetId;
@property (nonatomic, copy) NSString *bookLossFine;
@property (nonatomic, copy) NSString *callNo;
@property (nonatomic, copy) NSString *collectNo;
@property (nonatomic, copy) NSString *ctrlNo;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *dueTime;
@property (nonatomic, copy) NSString *infoAuthor;
@property (nonatomic, copy) NSString *infoCover;
@property (nonatomic, copy) NSString *infoIsbn;
@property (nonatomic, copy) NSString *infoPriceValue;
@property (nonatomic, copy) NSString *infoPubDate;
@property (nonatomic, copy) NSString *infoPublisher;
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *infoVolume;
@property (nonatomic, copy) NSString *loanNo;
@property (nonatomic, copy) NSString *loanStatus;
@property (nonatomic, copy) NSString *loanSurplusDay;
@property (nonatomic, copy) NSString *loanTime;
@property (nonatomic, copy) NSString *readerNo;
@property (nonatomic, copy) NSString *returnTime;
@property (nonatomic, assign) BOOL reserve;
@property (nonatomic, assign) BOOL reserveFlag;
@property (nonatomic, assign) BOOL reNew;
@property (nonatomic, assign) BOOL collected;
@property (nonatomic, assign) int64_t loanTimes;
@property (nonatomic, assign) int64_t periodCount;
@property (nonatomic, assign) int64_t reNewCount;
@property (nonatomic, assign) int64_t scorePersonCount;
@property (nonatomic, assign) int64_t forceReNewCount;
@property (nonatomic, assign) int64_t bookOdds;
@property (nonatomic, assign) float averageScore;
@end
