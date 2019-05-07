//
//  SLBookDetailDataController.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/18.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
N_Dec(kQueryBookDetailCompleteNotification);
N_Dec(kQueryBookCollectedInfoCompleteNotification);
N_Dec(kQueryBookScoreInfoCompleteNotification);
N_Dec(kQueryBookMyScoreInfoCompleteNotification);
N_Dec(kQueryBookContentInfoCompleteNotification);
N_Dec(kGiveBookScoreCompleteNotification);
N_Dec(kCollectBookCompleteNotification);
N_Dec(kCancelCollectBookCompleteNotification);

typedef void(^SLDataQueryCompleteBlock)(id data , NSError *error);
@class SLBookDetailInfoModel;
@class SLBookScoreModel;
@class SLBookDetailModel;
@class SLBookingInfo;
@interface SLBookDetailDataController : NSObject

@property (nonatomic, strong) NSMutableArray *bookLocations;
@property (nonatomic, strong) NSMutableArray *bookContents;
@property (nonatomic, strong) NSMutableArray *bookScores;
@property (nonatomic, strong) SLBookScoreModel *myScore;
@property (nonatomic, strong) SLBookDetailModel *detailInfo;
@property (nonatomic, strong) SLBookingInfo *bookingInfo;

+ (instancetype)sharedObject;
- (void)queryBookDetailWithCtrlNo:(NSString *)ctrlNo
                         complete:(SLDataQueryCompleteBlock)block;
- (void)queryBookCollectInfoWithCtrl:(NSString *)ctrlNo
                            Complete:(SLDataQueryCompleteBlock)block;
- (void)queryBookContentInfoComplete:(SLDataQueryCompleteBlock)block;
- (void)queryBookScoreInfoCtrlNo:(NSString *)ctrlNo
                        complete:(SLDataQueryCompleteBlock)block;
- (void)queryMyScoreInfo:(NSString *)ctrlNo
                complete:(SLDataQueryCompleteBlock)block;
- (void)giveTheScore:(CGFloat)score
                Book:(NSString *)ctrlNo
            complete:(SLDataQueryCompleteBlock)block;
- (void)collectBook:(NSString *)ctrlNo
           complete:(SLDataQueryCompleteBlock)block;
- (void)cancelCollectBook:(NSString *)ctrlNo
                 complete:(SLDataQueryCompleteBlock)block;
- (void)queryBookingInfo:(NSString *)ctrlNo
               completed:(SLDataQueryCompleteBlock)block;
- (void)bookingBook:(NSString *)ctrlNo
          completed:(SLDataQueryCompleteBlock)block;
- (void)cancelBooking:(NSString *)reserveNo
            completed:(SLDataQueryCompleteBlock)block;
@end

