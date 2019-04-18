//
//  SLLoginHeaderView.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/13.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, SLHeaderViewType) {
    SLHeaderViewTypeLeftLogo = 0,
    SLHeaderViewTypeRightLogo,
    SLHeaderViewTypeMiddleLogo,
    SLHeaderViewTypeNoLogo
};

@interface SLHeaderBarItemInfo : NSObject

@property (nonatomic, copy) void (^barItemClickedHandler)(void);
@property (nonatomic, copy) NSString *itemImageName;

@end


@interface SLHeaderBarItem : UIView

@end

@interface SLLoginHeaderView : UIView

@property (nonatomic, strong) NSMutableArray *rightBarItems;
@property (nonatomic, strong) NSMutableArray *leftBarItems;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) SLHeaderViewType viewType;
- (void)updateHeaderView;
@end

