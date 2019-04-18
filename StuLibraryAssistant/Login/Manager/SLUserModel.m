//
//  SLUserModel.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/15.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLUserModel.h"
#import <YYModel/YYModel.h>
@interface SLUserModel ()

@end

@implementation SLUserModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}


@end
