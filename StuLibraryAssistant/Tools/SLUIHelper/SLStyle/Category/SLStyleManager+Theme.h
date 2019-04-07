//
//  SLStyleManager+Theme.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLStyleManager.h"

@interface SLStyleManager (Theme)

+ (UIColor *)MainGreenColor;

+ (UIColor *)DeepDarkGrayColor;

+ (UIColor *)DarkGrayColor;

+ (UIColor *)GrayColor;

+ (UIColor *)LightGrayColor;

+ (UIColor *)BlueColor;

+ (UIColor *)PurpleColor;

+ (UIColor *)DeepGreenColor;

+ (UIColor *)RedColor;

+ (UIColor *)WhiteColor;

+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;
@end
