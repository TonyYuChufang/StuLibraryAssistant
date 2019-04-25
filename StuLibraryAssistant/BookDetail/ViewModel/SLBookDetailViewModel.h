//
//  SLBookDetailViewModel.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLBook.h"
#import "SLBookDetailModel.h"
@interface SLBookDetailViewModel : NSObject
@property (nonatomic, copy) NSString *bookImageUrl;
@property (nonatomic, assign) CGFloat bookPoint;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookAuthor;
@property (nonatomic, copy) NSString *bookPublishInfo;
@property (nonatomic, copy) NSString *bookCollectedTitle;
@property (nonatomic, copy) NSString *bookScoreTitle;
@property (nonatomic, assign) BOOL isCollected;

+ (SLBookDetailViewModel *)bookDetailViewModelWithBook:(SLBookListItem *)book;
+ (SLBookDetailViewModel *)bookDetailViewModelWithDetailModel:(SLBookDetailModel *)book;
@end

@interface SLBookLoactionViewModel : NSObject

@property (nonatomic, copy) NSString *bookAssetId;
@property (nonatomic, copy) NSString *bookLocation;
@property (nonatomic, copy) NSString *bookFetchId;
@property (nonatomic, copy) NSString *bookStatus;
@property (nonatomic, copy) NSString *bookLoanType;

+ (SLBookLoactionViewModel *)bookLocationViewModelWithLocation:(SLBookLocationModel *)location;
@end

@interface SLBookContentViewModel : NSObject

@end

@interface SLBookScoreViewModel : NSObject
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, assign) CGFloat score;

+ (SLBookScoreViewModel *)bookScoreViewModelWithScore:(SLBookScoreModel *)score;
@end
