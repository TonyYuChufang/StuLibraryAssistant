//
//  NSString+SLBookParser.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SLBookParser)

+ (NSString *)praseBookTitle:(NSString *)title;
+ (NSString *)praseAuthor:(NSString *)author;
+ (NSString *)praseBookLocation:(NSString *)location;
@end

