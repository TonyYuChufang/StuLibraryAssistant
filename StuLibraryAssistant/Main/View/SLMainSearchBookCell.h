//
//  SLMainSearchBookCell.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/20.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLSearchBookCellViewModel;
@class SLMainSearchBookCell;

@protocol SLMainSearchBookCellDelegate <NSObject>

- (void)didSelectMarkBtnBookCell:(SLMainSearchBookCell *)cell;

@end

@interface SLMainSearchBookCell : UITableViewCell

@property (nonatomic, weak) id<SLMainSearchBookCellDelegate> delegate;


- (void)bindBookCellViewModel:(SLSearchBookCellViewModel *)viewModel;
@end
