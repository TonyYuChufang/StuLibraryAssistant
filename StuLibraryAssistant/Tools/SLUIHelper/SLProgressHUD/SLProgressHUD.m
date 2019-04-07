//
//  SLProgressHUD.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/18.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLProgressHUD.h"
#import "MBProgressHUD.h"
#import "SLStyleManager+Theme.h"
@implementation SLProgressHUD

+ (void)showHUDWithText:(NSString *)text inView:(UIView *)view delayTime:(NSTimeInterval)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (view) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.contentColor = [UIColor whiteColor];
            hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = text;
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:delay];
        }
    });
}
@end
