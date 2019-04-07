//
//  SLProgressHUD.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/18.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLProgressHUD : NSObject

@property (nonatomic, assign) NSTimeInterval delayTime;

+ (void)showHUDWithText:(NSString *)text inView:(UIView *)view delayTime:(NSTimeInterval)delay;

@end
