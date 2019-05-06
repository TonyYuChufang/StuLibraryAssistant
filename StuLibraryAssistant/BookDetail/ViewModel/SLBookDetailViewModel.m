//
//  SLBookDetailViewModel.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLBookDetailViewModel.h"
#import "NSString+SLBookParser.h"
@implementation SLBookDetailViewModel
+ (SLBookDetailViewModel *)bookDetailViewModelWithBook:(SLBookListItem *)book
{
    SLBookDetailViewModel *viewModel = [[SLBookDetailViewModel alloc] init];
    viewModel.bookName = [NSString praseBookTitle:book.TITLE];
    viewModel.bookPoint = book.SCORE;
    viewModel.bookAuthor = [NSString praseAuthor:book.AUTHOR];
    viewModel.bookImageUrl = [NSString stringWithFormat:@"http://opac.lib.stu.edu.cn/jthq?fid=%@",book.COVER];
    viewModel.bookPublishInfo = [NSString stringWithFormat:@"%@ %@",book.PUBLISHER,book.PUBDATE];
    viewModel.bookScoreTitle = [NSString stringWithFormat:@"评分(%lld)",book.SCOREPERSONCOUNT];
    viewModel.bookCollectedTitle = [NSString stringWithFormat:@"藏书情况(%lld/%lld)",book.LENDABLE,book.COLLECTION];
    return viewModel;
}

+ (SLBookDetailViewModel *)bookDetailViewModelWithDetailModel:(SLBookDetailModel *)book
{
    SLBookDetailViewModel *viewModel = [[SLBookDetailViewModel alloc] init];
    viewModel.bookName = [NSString praseBookTitle:book.infoTitle];
    viewModel.bookPoint = [book.averageScore floatValue];
    viewModel.bookAuthor = book.infoAuthor;
    viewModel.bookImageUrl = [NSString stringWithFormat:@"http://opac.lib.stu.edu.cn/jthq?fid=%@",book.infoCover];
    viewModel.bookPublishInfo = [NSString stringWithFormat:@"%@ %@",book.infoPublisher,book.infoPubdate];
    viewModel.bookScoreTitle = [NSString stringWithFormat:@"评分(%lld)",book.scorePersonCount];
    viewModel.bookCollectedTitle = [NSString stringWithFormat:@"藏书情况(%lld/%lld)",book.lendAble,book.collectionCnt];
    viewModel.isCollected = book.collected;
    return viewModel;
}

@end

@implementation SLBookContentViewModel



@end

@implementation SLBookLoactionViewModel

+ (SLBookLoactionViewModel *)bookLocationViewModelWithLocation:(SLBookLocationModel *)location
{
    SLBookLoactionViewModel *viewModel = [[SLBookLoactionViewModel alloc] init];
    
    NSString *locationStr = nil;
    NSString *statusStr = @"状态：可借阅";
    if (location.location) {
        locationStr = [NSString praseBookLocation:location.location];
    } else {
        locationStr = location.orgName;
    }
    if ([location.bookStatus isEqualToString:@"readonly"]) {
        statusStr = @"状态：仅供阅览";
    } else if ([location.bookStatus isEqualToString:@"lent"]) {
        statusStr = [NSString stringWithFormat:@"状态：已借出/应还时间：%@",location.dueTime];
    }
    viewModel.bookStatus = statusStr;
    viewModel.bookAssetId = [NSString stringWithFormat:@"登录号：%@",location.assetId];
    viewModel.bookLocation = [NSString stringWithFormat:@"馆藏地点：%@",locationStr];
    viewModel.bookFetchId = [NSString stringWithFormat:@"索取号：%@",location.callNo];
    viewModel.bookLoanType = [NSString stringWithFormat:@"借阅类型：%@",location.bookTypeName];
    
    return viewModel;
}

@end

@implementation SLBookScoreViewModel

+ (SLBookScoreViewModel *)bookScoreViewModelWithScore:(SLBookScoreModel *)score
{
    if (score == nil) {
        return nil;
    }
    SLBookScoreViewModel *viewModel = [[SLBookScoreViewModel alloc] init];
    viewModel.score = score.score;
    viewModel.nickName = score.readerName;
    viewModel.createDate = score.createDate;
    
    return viewModel;
}

@end
