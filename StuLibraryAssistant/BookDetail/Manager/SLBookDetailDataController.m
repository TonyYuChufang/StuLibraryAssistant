//
//  SLBookDetailDataController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/18.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLBookDetailDataController.h"
#import "SLLoginDataController.h"
#import "SLBookDetailModel.h"
#import <YYModel/YYModel.h>
#import "SLNetwokrManager.h"
N_Def(kQueryBookDetailCompleteNotification);
N_Def(kQueryBookCollectedInfoCompleteNotification);
N_Def(kQueryBookScoreInfoCompleteNotification);
N_Def(kQueryBookMyScoreInfoCompleteNotification);
N_Def(kQueryBookContentInfoCompleteNotification);
N_Def(kGiveBookScoreCompleteNotification);
N_Def(kCollectBookCompleteNotification);
N_Def(kCancelCollectBookCompleteNotification);

@interface SLBookDetailDataController ()


@end

@implementation SLBookDetailDataController
+ (instancetype)sharedObject
{
    static id sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.bookLocations = [[NSMutableArray alloc] initWithCapacity:2];
        self.bookContents = [[NSMutableArray alloc] initWithCapacity:2];
        self.bookScores = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return self;
}

- (void)queryBookDetailWithCtrlNo:(NSString *)ctrlNo
                         complete:(SLDataQueryCompleteBlock)block
{
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(13),@(10),@(1100)],
                            @"ctrlNo":ctrlNo,
                            @"offset":@(0),
                            @"rows":@(1)
                            };
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            SLBookDetailModel *detailModel = [SLBookDetailModel yy_modelWithJSON:json[@"data"][@"list"][0]];
            self.detailInfo = detailModel;
            if (block) {
                block(detailModel,nil);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kQueryBookDetailCompleteNotification object:nil];
        } else {
            if (block) {
                block(nil,error);
            }
        }
    }];
}

- (void)queryBookCollectInfoWithCtrl:(NSString *)ctrlNo
                            Complete:(SLDataQueryCompleteBlock)block
{
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(13),@(10),@(1170)],
                            @"ctrlNo":ctrlNo,
                            @"offset":@(0),
                            @"rows":@(500),
                            @"function":@"opac"
                            };
    [self.bookLocations removeAllObjects];
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([json[@"success"] boolValue]) {
                for (NSDictionary *dict in json[@"data"][@"list"]) {
                    SLBookLocationModel *location = [SLBookLocationModel yy_modelWithJSON:dict];
                    [self.bookLocations addObject:location];
                    [self queryLocationDetailWithAssetId:location.assetId];
                }
                if (block) {
                    block(json,nil);
                }
            } else {
                if (block) {
                    block(nil,error);
                }
            }
        } else {
            
        }
    }];
}

- (void)queryLocationDetailWithAssetId:(NSString *)assetId
{
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(20),@(10),@(1000)],
                            @"query":assetId,
                            @"function":@"opac"
                            };
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([json[@"success"] boolValue]) {
                for (SLBookLocationModel *location in self.bookLocations) {
                    if (location.assetId == assetId) {
                        location.location = json[@"data"];
                        if ([json[@"data"] isEqualToString:@"error"]) {
                            location.location = nil;
                        }
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kQueryBookCollectedInfoCompleteNotification object:nil];
            }
        }
    }];
    
}

- (void)queryBookContentInfoComplete:(SLDataQueryCompleteBlock)block
{
    if (self.detailInfo == nil) {
        return;
    }
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(11),@(10),@(1200)],
                            @"marcId":self.detailInfo.marcId,
                            @"function":@"opac"
                            };
    [self.bookContents removeAllObjects];
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([json[@"success"] boolValue]) {
                SLBookDetailInfoModel *content = [SLBookDetailInfoModel yy_modelWithJSON:json[@"data"]];
                SLBookContentInfoModel *abstractContent = [SLBookContentInfoModel contentInfoTitle:@"摘要" content:(content.infoLccsa.length ? content.infoLccsa : @"暂无摘要")];
                SLBookContentInfoModel *summaryContent = [SLBookContentInfoModel contentInfoTitle:@"内容简介" content:(content.summary.length ? content.summary : @"暂无简介")];
                SLBookContentInfoModel *catalogContent = [SLBookContentInfoModel contentInfoTitle:@"目录" content:(content.catalog.length ? content.catalog : @"暂无目录")];
                [self.bookContents addObject:abstractContent];
                [self.bookContents addObject:summaryContent];
                [self.bookContents addObject:catalogContent];
                [[NSNotificationCenter defaultCenter] postNotificationName:kQueryBookContentInfoCompleteNotification object:nil];
            }
        }
    }];
}

- (void)queryBookScoreInfoCtrlNo:(NSString *)ctrlNo
                        complete:(SLDataQueryCompleteBlock)block
{
    if (ctrlNo == nil) {
        return;
    }
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(13),@(20),@(2000)],
                            @"ctrlNo":ctrlNo,
                            @"function":@"opac",
                            @"page":@(1),
                            @"pageSize":@(30)
                            };
    [self.bookContents removeAllObjects];
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([json[@"success"] boolValue]) {
                for (NSDictionary *dict in json[@"data"][@"list"]) {
                    SLBookScoreModel *scoreModel = [SLBookScoreModel yy_modelWithJSON:dict];
                    [self.bookScores addObject:scoreModel];
                }
                if (block) {
                    block(json,nil);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kQueryBookScoreInfoCompleteNotification object:nil];
            }
        }
    }];
}

- (void)queryMyScoreInfo:(NSString *)ctrlNo
                complete:(SLDataQueryCompleteBlock)block
{
    if (ctrlNo == nil) {
        return;
    }
    if ([SLLoginDataController sharedObject].userInfo.memberNo == nil) {
        return;
    }
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(13),@(20),@(2000)],
                            @"ctrlNo":ctrlNo,
                            @"function":@"opac",
                            @"page":@(1),
                            @"readerNo":[SLLoginDataController sharedObject].userInfo.memberNo,
                            @"pageSize":@(1)
                            };
    [self.bookContents removeAllObjects];
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([json[@"success"] boolValue]) {
                for (NSDictionary *dict in json[@"data"][@"list"]) {
                    SLBookScoreModel *scoreModel = [SLBookScoreModel yy_modelWithJSON:dict];
                    self.myScore = scoreModel;
                }
                if (block) {
                    block(json,nil);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kQueryBookMyScoreInfoCompleteNotification object:nil];
            }
        }
    }];
}

- (void)giveTheScore:(CGFloat)score
                Book:(NSString *)ctrlNo
                  complete:(SLDataQueryCompleteBlock)block
{
    if (ctrlNo == nil) {
        return;
    }
 
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(13),@(20),@(1900)],
                            @"ctrlNo":ctrlNo,
                            @"function":@"opac",
                            @"score":[NSString stringWithFormat:@"%ld",(long)score],
                            @"infoTitle":self.detailInfo.infoTitle
                            };
    
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([json[@"success"] boolValue]) {
                if (block) {
                    block(json,nil);
                }
                NSDictionary *scoreInfo = json[@"data"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kGiveBookScoreCompleteNotification object:nil userInfo:scoreInfo];
            }
        } else {
            NSLog(@"%@",error);
        }
    }];
    
}

- (void)collectBook:(NSString *)ctrlNo
            complete:(SLDataQueryCompleteBlock)block
{
    if (ctrlNo == nil) {
        return;
    }
    
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(13),@(20),@(1000)],
                            @"ctrlNo":ctrlNo,
                            @"function":@"opac",
                            };
    
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([json[@"success"] boolValue]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kCollectBookCompleteNotification object:nil userInfo:nil];
            }
            if (block) {
                block(json[@"success"],nil);
            }
        } else {
            NSLog(@"%@",error);
        }
    }];
}

- (void)cancelCollectBook:(NSString *)ctrlNo
           complete:(SLDataQueryCompleteBlock)block
{
    if (ctrlNo == nil) {
        return;
    }
    
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(13),@(20),@(1020)],
                            @"ctrlNo":ctrlNo,
                            @"function":@"opac",
                            };
    
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([json[@"success"] boolValue]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kCancelCollectBookCompleteNotification object:nil userInfo:nil];
            }
            if (block) {
                block(json[@"success"],nil);
            }
        } else {
            NSLog(@"%@",error);
        }
    }];
    
}
@end
