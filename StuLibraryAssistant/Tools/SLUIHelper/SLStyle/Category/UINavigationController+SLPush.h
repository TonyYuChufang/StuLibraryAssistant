//
//  UINavigationController+SLPush.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/12.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, SLPushType) {
    SLPushTypeFromTop = 0,
    SLPushTypeFromBottom,
    SLPushTypeFromRight,
    SLPushTypeFromLeft
};

@interface UINavigationController (SLPush)

@property (nonatomic, assign) SLPushType pushType;
@property (nonatomic, assign) SLPushType popType;
- (void)setDefaultNavType;
@end
