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

+ (UIColor *)menuItemDarkColor
{
    return [SLStyleManager colorWithHexString:@"#2C272D"];
}
#pragma mark 实现搜索条背景透明化

+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
@end
