//
//  SLCollectBookCellViewModel.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/5.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SLCollectedBook;
@interface SLCollectBookCellViewModel : NSObject

@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookAuthor;
@property (nonatomic, copy) NSString *bookCount;
@property (nonatomic, copy) NSString *coverImageUrl;
+ (SLCollectBookCellViewModel *)viewModelWithCollectBook:(SLCollectedBook *)book;
@end

