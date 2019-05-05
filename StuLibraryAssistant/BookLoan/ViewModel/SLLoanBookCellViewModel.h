//
//  SLLoanBookCellViewModel.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/4.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SLLoanBook;

@interface SLLoanBookCellViewModel : NSObject
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *loanDate;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *coverImageUrl;
@property (nonatomic, copy) NSString *loanStatus;
@property (nonatomic, assign) CGSize loanStatusSize;
+ (SLLoanBookCellViewModel *)bookCellViewModelWithBook:(SLLoanBook *)book;
@end
