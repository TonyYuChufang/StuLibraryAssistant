//
//  UINavigationController+SLPush.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/12.
//  Copyright © 2019 yu. All rights reserved.
//

#import "UINavigationController+SLPush.h"
#import <objc/runtime.h>
static NSString * kPushKey = @"kPushKey";
static NSString * kPopKey = @"kPopKey";
@implementation UINavigationController (SLPush)

- (void)setPushType:(SLPushType)pushType
{
    objc_setAssociatedObject(self, &kPushKey, @(pushType), OBJC_ASSOCIATION_ASSIGN);
}

- (SLPushType)pushType
{
    return [objc_getAssociatedObject(self, &kPushKey) integerValue];
}

- (void)setPopType:(SLPushType)popType
{
    objc_setAssociatedObject(self, &kPopKey, @(popType), OBJC_ASSOCIATION_ASSIGN);
}

- (SLPushType)popType
{
   return [objc_getAssociatedObject(self, &kPopKey) integerValue];
}

- (void)setDefaultNavType
{
    self.popType = SLPushTypeFromLeft;
    self.pushType = SLPushTypeFromRight;
}
@end
