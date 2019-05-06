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
    viewModel.publishDate = book.PUBDATE;
    viewModel.bookCount = [NSString stringWithFormat:@"馆藏 %lld / 可借 %lld",book.COLLECTION,book.LENDABLE];
    if (book.COVER) {
        viewModel.coverImageUrl = [NSString stringWithFormat:@"http://opac.lib.stu.edu.cn/jthq?fid=%@",book.COVER];
    }
    return viewModel;
}

+ (NSArray *)viewModelsWithBooks:(NSArray *)books
{
    NSMutableArray *viewModels = [[NSMutableArray alloc] initWithCapacity:2];
    for (SLBookListItem *book in books) {
        SLSearchBookCellViewModel *viewModel = [SLSearchBookCellViewModel bookCellViewModelWithBook:book];
        [viewModels addObject:viewModel];
    }
    
    return viewModels;
}
@end
