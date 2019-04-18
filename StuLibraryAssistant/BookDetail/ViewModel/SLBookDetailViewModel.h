//
//  SLBookDetailViewModel.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLBook.h"
@interface SLBookDetailViewModel : NSObject
@property (nonatomic, copy) NSString *bookImageUrl;
@property (nonatomic, assign) CGFloat bookPoint;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookAuthor;
@property (nonatomic, copy) NSString *bookPublishInfo;

+ (SLBookDetailViewModel *)bookDetailViewModelWithBook:(SLBookListItem *)book;
@end

@interface SLBookLoactionViewModel : NSObject

@end
