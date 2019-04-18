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
    viewModel.bookPoint = [book.SCORE floatValue];
    viewModel.bookAuthor = [NSString praseAuthor:book.AUTHOR];
    viewModel.bookImageUrl = [NSString stringWithFormat:@"http://opac.lib.stu.edu.cn/jthq?fid=%@",book.COVER];
    viewModel.bookPublishInfo = [NSString stringWithFormat:@"%@ %@",book.PUBLISHER,book.PUBDATE];
    return viewModel;
}
@end
