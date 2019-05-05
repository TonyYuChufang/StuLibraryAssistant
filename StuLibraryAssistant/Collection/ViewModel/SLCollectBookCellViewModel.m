//
//  SLCollectBookCellViewModel.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/5.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLCollectBookCellViewModel.h"
#import "SLCollectedBook.h"
@implementation SLCollectBookCellViewModel

+ (SLCollectBookCellViewModel *)viewModelWithCollectBook:(SLCollectedBook *)book
{
    SLCollectBookCellViewModel *viewModel = [[SLCollectBookCellViewModel alloc] init];
    viewModel.bookName = book.infoTitle;
    viewModel.bookAuthor = book.infoAuthor;
    viewModel.bookCount = [NSString stringWithFormat:@"馆藏 %lld / 可借 %lld",book.collectionCnt,book.canLoan];
    if (book.infoCover) {
        viewModel.coverImageUrl = [NSString stringWithFormat:@"http://opac.lib.stu.edu.cn/jthq?fid=%@",book.infoCover];
    }
    return viewModel;
}

@end
