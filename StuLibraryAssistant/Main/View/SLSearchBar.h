//
//  SLSearchBar.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/28.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLSearchBarDelegate <NSObject>

- (void)slSearchBarDidSelectReturnWithText:(NSString *)text;

@end

@interface SLSearchBar : UIView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, weak) id<SLSearchBarDelegate> delegate;

@end


