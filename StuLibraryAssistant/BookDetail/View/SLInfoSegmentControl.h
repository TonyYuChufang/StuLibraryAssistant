//
//  SLInfoSegmentControl.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SLInfoSegmentControlType) {
    SLInfoSegmentControlTypeText = 0,
    SLInfoSegmentControlTypeImageAndTex
};

@interface SLInfoSegmentControl : UIView

@property (nonatomic, assign) SLInfoSegmentControlType viewType;
@property (nonatomic, strong) NSArray *controlItems;
- (void)updateSegmentControl;
@end
