//
//  SLSearchBookViewModel.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/20.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLSearchBookCellViewModel.h"
#import "SLBook.h"
#import "NSString+SLBookParser.h"
@implementation SLSearchBookCellViewModel


+ (SLSearchBookCellViewModel *)bookCellViewModelWithBook:(SLBookListItem *)book
{
    SLSearchBookCellViewModel *viewModel = [[SLSearchBookCellViewModel alloc] init];
    
    viewModel.isCollected = book.COLLECTED ;
    viewModel.bookName = [NSString praseBookTitle:book.TITLE];
    viewModel.authorName = [NSString praseAuthor:book.AUTHOR];
    viewModel.bookCount = [NSString stringWithFormat:@"馆藏 %@ / 可借 %@",book.COLLECTION,book.LENDABLE];
    if (book.COVER) {
        viewModel.coverImageUrl = [NSString stringWithFormat:@"http://opac.lib.stu.edu.cn/jthq?fid=%@",book.COVER];
    }
    return viewModel;
}
@end
