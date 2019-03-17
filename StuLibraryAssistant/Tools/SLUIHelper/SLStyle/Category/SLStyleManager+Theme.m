//
//  SLStyleManager+Theme.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLStyleManager+Theme.h"

@implementation SLStyleManager (Theme)

+ (UIColor *)MainGreenColor
{
    return [SLStyleManager colorWithHexString:@"#98CE63"];
}

+ (UIColor *)DeepDarkGrayColor
{
    return [SLStyleManager colorWithHexString:@"#2C272D"];
}

+ (UIColor *)DarkGrayColor
{
    return [SLStyleManager colorWithHexString:@"#636363"];
}

+ (UIColor *)GrayColor
{
    return [SLStyleManager colorWithHexString:@"#969696"];
}

+ (UIColor *)LightGrayColor
{
    return [SLStyleManager colorWithHexString:@"#D9D9D9"];
}

+ (UIColor *)BlueColor
{
    return [SLStyleManager colorWithHexString:@"#348ED5"];
}

+ (UIColor *)PurpleColor
{
    return [SLStyleManager colorWithHexString:@"#828BCC"];
}

+ (UIColor *)DeepGreenColor
{
    return [SLStyleManager colorWithHexString:@"#53BBB4"];
}

+ (UIColor *)RedColor;
{
    return [SLStyleManager colorWithHexString:@"#D75B49"];
}

+ (UIColor *)WhiteColor
{
    return [SLStyleManager colorWithHexString:@"#EEEEEE"];
}

@end
