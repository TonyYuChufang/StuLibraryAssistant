//
//  SLUIConstant.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/7.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

//System UI
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define kStatusHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kNavigationBarHeight (kStatusHeight + 44)
