//
//  UIColor+hexColor.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/13.
//  Copyright © 2019 yu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (hexColor)

+ (UIColor *)hx_colorWithHexString:(NSString *)hexString;
+ (UIColor *)hx_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (UIColor *)hx_colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)hx_colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
