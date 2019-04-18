//
//  SLMenuItemView.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/7.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLMenuItemInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) void (^menuItemSelectedHandler)(void);

@end

@interface SLMenuItemView : UIView

@property (nonatomic, copy) void (^menuItemSelectedHandler)(void);
+ (SLMenuItemView *)menuItemViewWithInfo:(SLMenuItemInfo *)info;
- (void)updateItemWithInfo:(SLMenuItemInfo *)info;

@end

@interface SLTextItemView : UIView

+ (SLTextItemView *)textItemViewWithInfo:(SLMenuItemInfo *)info;
- (void)updateItemWithInfo:(SLMenuItemInfo *)info;

@end
