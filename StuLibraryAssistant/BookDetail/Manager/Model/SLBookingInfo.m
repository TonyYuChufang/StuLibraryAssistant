//
//  SLBookingInfo.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/8.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLBookingInfo.h"

@implementation SLBookingInfo

- (void)updateLibIdWithDict:(NSDictionary *)dict
{
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        self.libIds = key;
    }];
}

@end
