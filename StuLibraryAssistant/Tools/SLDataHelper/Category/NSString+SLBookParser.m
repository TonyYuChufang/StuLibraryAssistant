//
//  NSString+SLBookParser.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import "NSString+SLBookParser.h"

@implementation NSString (SLBookParser)
+ (NSString *)praseBookTitle:(NSString *)title
{
    NSString *titleStr = title;
    NSString *temp = nil;
    for (int i = 0; i < [titleStr length]; i++) {
        temp = [titleStr substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@"\x01"]) {
            switch ([titleStr characterAtIndex:i + 1]) {
                case 'a':
                    titleStr = [titleStr stringByReplacingCharactersInRange:NSMakeRange(i + 1, 1) withString:@""];
                    break;
                case 'd':
                    titleStr = [titleStr stringByReplacingCharactersInRange:NSMakeRange(i + 1, 1) withString:@" / "];
                    break;
                case 'e':
                    titleStr = [titleStr stringByReplacingCharactersInRange:NSMakeRange(i + 1, 1) withString:@" / "];
                    break;
                case 'i':
                    titleStr = [titleStr stringByReplacingCharactersInRange:NSMakeRange(i + 1, 1) withString:@" / "];
                    break;
                case 'h':
                    titleStr =  [titleStr stringByReplacingCharactersInRange:NSMakeRange(i + 1, 1) withString:@" / "];
                    break;
                default:
                    break;
            }
        }
    }
    
    return titleStr;
}

+ (NSString *)praseAuthor:(NSString *)author
{
    NSString *authorStr = author;
    NSRange orRange = [authorStr rangeOfString:@"||"];
    authorStr = [authorStr substringFromIndex:orRange.location];
    authorStr = [authorStr stringByReplacingOccurrencesOfString:@"||" withString:@""];
    if ([authorStr isEqualToString:@""]) {
        authorStr = [author stringByReplacingOccurrencesOfString:@"||" withString:@""];
        authorStr = [self praseBookTitle:authorStr];
    }
    return authorStr;
}

@end
