//
//  SLLoginInputView.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/13.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SLLoginTipsType)
{
    SLLoginTipsTypeUsername = 1,
    SLLoginTipsTypePassword
};

@protocol SLLoginInputViewDelegate <NSObject>

@end

@interface SLLoginInputView : UIView

@property (nonatomic, weak) id<SLLoginInputViewDelegate> delegate;
- (void)showTipsWithType:(SLLoginTipsType)tipsType;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@end

