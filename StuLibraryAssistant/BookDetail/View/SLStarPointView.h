//
//  SLStarPointView.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLStarPointView;
@protocol SLStarPointViewDelegate <NSObject>

- (void)slstarPointView:(SLStarPointView *)starPointView DidSelectWithScore:(CGFloat)score;

@end

@interface SLStarPointView : UIView
@property (nonatomic, weak) id<SLStarPointViewDelegate> delegate;
@property (nonatomic, assign) BOOL canScore;
@property (nonatomic, assign) BOOL shouldShowScore;
- (void)updateStarPoint:(CGFloat)point;

@end
