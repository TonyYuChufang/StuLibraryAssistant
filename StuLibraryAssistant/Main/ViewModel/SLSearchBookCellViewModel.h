//
//  SLSearchBookViewModel.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/20.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SLBookListItem;
NS_ASSUME_NONNULL_BEGIN

@interface SLSearchBookCellViewModel : NSObject

@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookCount;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *coverImageUrl;

+ (SLSearchBookCellViewModel *)bookCellViewModelWithBook:(SLBookListItem *)book;

@end

NS_ASSUME_NONNULL_END
