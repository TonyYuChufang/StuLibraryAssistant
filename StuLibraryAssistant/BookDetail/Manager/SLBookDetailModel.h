//
//  SLBookDetailModel.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/18.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLBookDetailModel : NSObject

@property (nonatomic, strong) NSArray *aList;
@property (nonatomic, strong) NSArray *authors;
@property (nonatomic, copy) NSString *averageScore;
@property (nonatomic, copy) NSString *c;
@property (nonatomic, copy) NSString *calcCode;
@property (nonatomic, assign) int64_t changeIndex;
@property (nonatomic, assign) int64_t clickCount;
@property (nonatomic, assign) BOOL collected;
@property (nonatomic, assign) int64_t collectedCount;
@property (nonatomic, assign) int64_t collectionCnt;
@property (nonatomic, copy) NSString *ctrlNo;
@property (nonatomic, assign) int64_t downCount;
@property (nonatomic, copy) NSString *infoAuthor;
@property (nonatomic, copy) NSString *infoClc;
@property (nonatomic, copy) NSString *infoCover;
@property (nonatomic, copy) NSString *infoEditionInfo;
@property (nonatomic, copy) NSString *infoIsbn;
@property (nonatomic, copy) NSString *infoIsbnValue;
@property (nonatomic, copy) NSString *infoLanguage;
@property (nonatomic, copy) NSString *infoMediumInfo;
@property (nonatomic, copy) NSString *infoPubdate;
@property (nonatomic, copy) NSString *infoPubdateValue;
@property (nonatomic, copy) NSString *infoPublisher;
@property (nonatomic, copy) NSString *infoPublocale;
@property (nonatomic, copy) NSString *infoSeriesInfo;
@property (nonatomic, copy) NSString *infoSubjectInfo;
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *infoTitleAuthorInfo;
@property (nonatomic, assign) int64_t lendAble;
@property (nonatomic, assign) int64_t loanCount;
@property (nonatomic, assign) int64_t lendCnt;
@property (nonatomic, copy) NSString *marcId;
@property (nonatomic, copy) NSString *marcSource;
@property (nonatomic, copy) NSString *objId;
@property (nonatomic, assign) int64_t scorePersonCount;
@property (nonatomic, strong) NSDictionary *statistics;
@property (nonatomic, assign) int64_t unlendableCnt;

@end

@interface SLBookLocationModel : NSObject
@property (nonatomic, copy) NSString *assetId;
@property (nonatomic, copy) NSString *averageScore;
@property (nonatomic, copy) NSString *bookStatus;
@property (nonatomic, copy) NSString *bookTypeName;
@property (nonatomic, copy) NSString *callNo;
@property (nonatomic, copy) NSString *collectNo;
@property (nonatomic, copy) NSString *collectType;
@property (nonatomic, assign) BOOL collected;
@property (nonatomic, copy) NSString *ctrlNo;
@property (nonatomic, copy) NSString *dueTime;
@property (nonatomic, copy) NSString *loanTime;
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *infoPubDate;
@property (nonatomic, copy) NSString *infoAuthor;
@property (nonatomic, copy) NSString *infoBindery;
@property (nonatomic, copy) NSString *infoClc;
@property (nonatomic, copy) NSString *infoCover;
@property (nonatomic, copy) NSString *infoPriceValue;
@property (nonatomic, copy) NSString *infoIsbn;
@property (nonatomic, copy) NSString *infoEdition;
@property (nonatomic, copy) NSString *infoVolume;
@property (nonatomic, copy) NSString *loanNo;
@property (nonatomic, copy) NSString *loanSurplusDay;
@property (nonatomic, assign) int64_t loanTimes;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, copy) NSString *periodCount;
@property (nonatomic, copy) NSString *periodNum;
@property (nonatomic, copy) NSString *reNewCount;
@property (nonatomic, copy) NSString *readerNo;
@property (nonatomic, copy) NSString *reserve;
@property (nonatomic, copy) NSString *reserveFlag;
@property (nonatomic, copy) NSString *scorePersonCount;
@property (nonatomic, copy) NSString *volNum;
@property (nonatomic, copy) NSString *location;
@end

@interface SLBookScoreModel : NSObject
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *createUser;
@property (nonatomic, copy) NSString *ctrlNo;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *readerName;
@property (nonatomic, copy) NSString *readerNo;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *updateUser;
@end

@interface SLBookDetailInfoModel : NSObject

@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *calcCode;
@property (nonatomic, copy) NSString *catalog;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *dicNo;
@property (nonatomic, copy) NSString *infoAuthor;
@property (nonatomic, copy) NSString *infoClc;
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
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *infoTitleAuthorInfo;
@property (nonatomic, copy) NSString *marcId;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *orgNo;
@property (nonatomic, copy) NSString *preview;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *summary;

@end

@interface SLBookContentInfoModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

+ (SLBookContentInfoModel *)contentInfoTitle:(NSString *)title content:(NSString *)content;
@end
