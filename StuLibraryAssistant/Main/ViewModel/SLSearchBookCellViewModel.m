//
//  SLSearchBookViewModel.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/20.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLSearchBookCellViewModel.h"
#import "SLBook.h"
@implementation SLSearchBookCellViewModel


+ (SLSearchBookCellViewModel *)bookCellViewModelWithBook:(SLBookListItem *)book
{
    SLSearchBookCellViewModel *viewModel = [[SLSearchBookCellViewModel alloc] init];
    
    viewModel.bookName = [self praseBookTitle:book.TITLE];
    viewModel.authorName = [self praseAuthor:book.AUTHOR];
    viewModel.bookCount = [NSString stringWithFormat:@"馆藏 %@ / 可借 %@",book.COLLECTION,book.LENDABLE];
//  原始model数据整理，转化成可直接装配View的Viewmodel
    if (book.COVER) {
        viewModel.coverImageUrl = [NSString stringWithFormat:@"http://opac.lib.stu.edu.cn/jthq?fid=%@",book.COVER];
    }
    return viewModel;
}

+ (NSString *)praseBookTitle:(NSString *)title
{
    NSString *titleStr = title;
    NSString *temp = nil;
    for (int i = 0; i < [titleStr length]; i++) {
        temp = [titleStr substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@"\x01"]) {
            switch ([titleStr characterAtIndex:i + 1]) {
                case 'a':
                    titleStr = [titleStr stringByReplacingCharactersInRange:NSMakeRange(i + 1, 1) withString:@""];
                    break;
                case 'd':
                    titleStr = [titleStr stringByReplacingCharactersInRange:NSMakeRange(i + 1, 1) withString:@" / "];
                    break;
                case 'e':
                    titleStr = [titleStr stringByReplacingCharactersInRange:NSMakeRange(i + 1, 1) withString:@" / "];
                    break;
                case 'i':
                    titleStr = [titleStr stringByReplacingCharactersInRange:NSMakeRange(i + 1, 1) withString:@" / "];
                    break;
                case 'h':
                   titleStr =  [titleStr stringByReplacingCharactersInRange:NSMakeRange(i + 1, 1) withString:@" / "];
                    break;
                default:
                    break;
            }
        }
    }
    
    return titleStr;
}

+ (NSString *)praseAuthor:(NSString *)author
{
    NSString *authorStr = author;
    NSRange orRange = [authorStr rangeOfString:@"||"];
    authorStr = [authorStr substringFromIndex:orRange.location];
    authorStr = [authorStr stringByReplacingOccurrencesOfString:@"||" withString:@""];
    if ([authorStr isEqualToString:@""]) {
        authorStr = [author stringByReplacingOccurrencesOfString:@"||" withString:@""];
        authorStr = [self praseBookTitle:authorStr];
    }
    return authorStr;
}
@end
