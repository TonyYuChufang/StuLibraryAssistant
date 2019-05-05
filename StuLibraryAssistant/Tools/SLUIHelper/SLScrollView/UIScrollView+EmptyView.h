//
//  UIScrollView+EmptyView.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/3.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SLEmptyViewType)
{
    SLEmptyViewTypeNetWorkError = 1,
    SLEmptyViewTypeEmptyBookList,
    SLEmptyViewTypeInitialBookList,
    SLEmptyViewTypeNoScore,
    SLEmptyViewTypeNoLoanBook,
    SLEmptyViewTypeNoCollectBook
};

@interface UIScrollView (EmptyView)

@property (nonatomic, strong) UIView *sl_emptyView;
- (void)sl_removeEmptyView;
- (void)sl_showEmptyViewWithType:(SLEmptyViewType)type;
@end

