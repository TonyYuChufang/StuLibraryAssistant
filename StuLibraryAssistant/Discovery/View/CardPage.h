//
//  CardPage.h
//  CollectionCardPage
//
//  Created by ymj_work on 16/5/28.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLCardPageDelegate <NSObject>
- (void)cardPage:(UIView *)cardPage didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CardPage : UIView

@property (nonatomic, weak) id<SLCardPageDelegate> delegate;
- (void)bindViewModels:(NSArray *)viewModels;

@end
