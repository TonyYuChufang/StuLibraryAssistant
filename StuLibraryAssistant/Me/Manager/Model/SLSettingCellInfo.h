//
//  SLSettingCellIInfo.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/5.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger,SLSettingCellType) {
    SLSettingCellTypeCleanCache = 0,
    SLSettingCellTypeLogOut,
    SLSettingCellTypeAboutUs
};
@interface SLSettingCellInfo : NSObject

@property (nonatomic, assign) SLSettingCellType cellType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^settingCellDidClickedHandler)(void);

@end

