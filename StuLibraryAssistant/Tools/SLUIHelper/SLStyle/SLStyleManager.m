//
//  SLStyleManager.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/13.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLStyleManager.h"
#import "UIColor+hexColor.h"
#import "SLCacheManager.h"
@interface SLStyleManager ()

@property (nonatomic, strong) SLMemoryCahce *memoryCache;

@end

@implementation SLStyleManager

+ (instancetype)sharedObject
{
    static id sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init
{
    if (self = [super init]) {
        _memoryCache = [SLCacheManager createMemoryCache];
    }
    
    return self;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    return [[self sharedObject] colorWithHexString:hexString];
}

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [[self sharedObject] colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)colorWithHexString:(NSString *)hexString
{
    if ([hexString length] < 6) {
        NSAssert(0, @"hextString %@ illegal",hexString);
        return [UIColor clearColor];
    }
    
    NSString *key = hexString ? [hexString lowercaseString] : @"";
    UIColor *color = [_memoryCache objectForKey:key];
    if (!color) {
        color = [UIColor hx_colorWithHexString:hexString];
        
        if (color) {
            [_memoryCache setObject:color forKey:key];
        }
    }
    
    return color;
}

- (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    NSString* colorIdendifier = [NSString stringWithFormat:@"color:%0.2f_%0.2f_%0.2f_%0.2f",red,green,blue,alpha];
    UIColor* color = [_memoryCache objectForKey:colorIdendifier];
    if (!color) {
        color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        if (color) {
            [_memoryCache setObject:color forKey:colorIdendifier];
        }
    }
    return color;
}
@end
