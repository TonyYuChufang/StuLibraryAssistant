//
//  SLCollectedBook.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/5.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLCollectedBook : NSObject

@property (nonatomic, copy) NSString *calcCode;
@property (nonatomic, copy) NSString *collectionDate;
@property (nonatomic, copy) NSString *ctrlNo;
@property (nonatomic, copy) NSString *infoAuthor;
@property (nonatomic, copy) NSString *infoClc;
@property (nonatomic, copy) NSString *infoCover;
@property (nonatomic, copy) NSString *infoEditionInfo;
@property (nonatomic, copy) NSString *infoIsbn;
@property (nonatomic, copy) NSString *infoLanguage;
@property (nonatomic, copy) NSString *infoLccsa;
@property (nonatomic, copy) NSString *infoMediumInfo;
@property (nonatomic, copy) NSString *infoPubdate;
@property (nonatomic, copy) NSString *infoPubdateValue;
@property (nonatomic, copy) NSString *infoPublisher;
@property (nonatomic, copy) NSString *infoPublocale;
@property (nonatomic, copy) NSString *infoSeriesInfo;
@property (nonatomic, copy) NSString *infoSubjectInfo;
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *infoTitleAuthorInfo;
@property (nonatomic, copy) NSString *marcId;
@property (nonatomic, copy) NSString *marcSource;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) float averageScore;
@property (nonatomic, assign) int64_t canLoan;
@property (nonatomic, assign) int64_t collectedCount;
@property (nonatomic, assign) int64_t collectionCnt;
@property (nonatomic, assign) int64_t journalFlag;
@property (nonatomic, assign) int64_t lendCnt;
@property (nonatomic, assign) int64_t loanCount;
@property (nonatomic, assign) int64_t scorePersonCount;
@property (nonatomic, assign) int64_t unlendableCnt;
@property (nonatomic, assign) BOOL status;

@end

