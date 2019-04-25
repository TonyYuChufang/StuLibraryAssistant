//
//  SLBookDetailInfoView.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLBookDetailViewModel;
@interface SLBookDetailInfoView : UIView

@property (nonatomic, assign) CGFloat score;
- (void)updateDetailViewWithViewModel:(SLBookDetailViewModel *)viewModel;
@end

