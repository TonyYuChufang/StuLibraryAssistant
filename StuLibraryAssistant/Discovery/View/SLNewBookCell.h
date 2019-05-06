//
//  CollectionViewCell.h
//  CollectionCardPage
//
//  Created by ymj_work on 16/5/28.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLSearchBookCellViewModel;
@interface SLNewBookCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView* imageV;

- (void)bindViewModel:(SLSearchBookCellViewModel *)viewModel;
@end
