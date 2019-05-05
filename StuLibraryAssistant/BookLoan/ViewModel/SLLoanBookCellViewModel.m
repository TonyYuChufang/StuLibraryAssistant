//
//  SLLoanBookCellViewModel.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/4.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLoanBookCellViewModel.h"
#import "SLLoanBook.h"

@implementation SLLoanBookCellViewModel
+ (SLLoanBookCellViewModel *)bookCellViewModelWithBook:(SLLoanBook *)book
{
    SLLoanBookCellViewModel *viewModel = [[SLLoanBookCellViewModel alloc] init];
    viewModel.bookName = book.infoTitle;
    viewModel.loanDate = [NSString stringWithFormat:@"%@ ~ %@",book.loanTime,book.dueTime];
    viewModel.authorName = book.infoAuthor;
    if (book.infoCover) {
        viewModel.coverImageUrl = [NSString stringWithFormat:@"http://opac.lib.stu.edu.cn/jthq?fid=%@",book.infoCover];
    }
    
    viewModel.loanStatusSize = CGSizeMake(60, 18);
    if ([book.loanStatus isEqualToString:@"expire_retu"]) {
        viewModel.loanStatus = @"icon_loanbook_status_overdue";
    } else if ([book.loanStatus isEqualToString:@"normal_retu"]) {
        viewModel.loanStatus = @"icon_loanbook_status_normal";
    } else if ([book.loanStatus isEqualToString:@"damage_retu"]) {
        viewModel.loanStatus = @"icon_loanbook_status_damage";
    } else if ([book.loanStatus isEqualToString:@"exp_dam_retu"]) {
        viewModel.loanStatus = @"icon_loanbook_status_expDam";
        viewModel.loanStatusSize = CGSizeMake(85, 18);
    } else if ([book.loanStatus isEqualToString:@"lost_retu"]) {
        viewModel.loanStatus = @"icon_loanbook_status_lost";
    } else if ([book.loanStatus isEqualToString:@"lent"]) {
        viewModel.loanStatus = @"icon_profile_status_normal";
        viewModel.loanStatusSize = CGSizeMake(35, 18);
    }
    
    return viewModel;
}
@end
