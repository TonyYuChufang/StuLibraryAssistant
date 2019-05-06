//
//  SLBook.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/20.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLBook.h"
#import "SLLoanBook.h"
#import "SLCollectedBook.h"
@implementation SLBookListItem
+ (SLBookListItem *)bookListItemWithLoanBook:(SLLoanBook *)loanBook
{
    SLBookListItem *book = [[SLBookListItem alloc] init];
    book.CTRLNO = loanBook.ctrlNo;
    book.TITLE = loanBook.infoTitle;
    book.COLLECTED = loanBook.collected;
    book.AUTHOR = loanBook.infoAuthor;
    book.SCOREPERSONCOUNT = loanBook.scorePersonCount;
    book.SCORE = loanBook.averageScore;
    book.LENDABLE = 1;
    book.COLLECTION = 1;
    book.COVER = loanBook.infoCover;
    book.PUBLISHER = loanBook.infoPublisher;
    book.PUBDATE = loanBook.infoPubDate;
    return book;
}

+ (SLBookListItem *)bookListItemWithCollectBook:(SLCollectedBook *)collectBook
{
    SLBookListItem *book = [[SLBookListItem alloc] init];
    book.CTRLNO = collectBook.ctrlNo;
    book.TITLE = collectBook.infoTitle;
    book.COLLECTED = YES;
    book.AUTHOR = collectBook.infoAuthor;
    book.SCOREPERSONCOUNT = collectBook.scorePersonCount;
    book.SCORE = collectBook.averageScore;
    book.LENDABLE = collectBook.canLoan;
    book.COLLECTION = collectBook.collectionCnt;
    book.COVER = collectBook.infoCover;
    book.PUBLISHER = collectBook.infoPublisher;
    book.PUBDATE = collectBook.infoPubdate;
    return book;
}
@end

@implementation SLBookDetailItem


@end
