//
//  SLLoginDataController.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/14.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLUserModel.h"
N_Dec(kLoginSuccessNotification);
N_Dec(kQueryUserInfoSuccessNotification);

typedef void(^SLDataQueryCompleteBlock)(id data , NSError *error);

@interface SLLoginDataController : NSObject
+ (instancetype)sharedObject;
- (void)requestMyStuLoginParamWithBlock:(SLDataQueryCompleteBlock)block;
- (void)loginWithUserName:(NSString *)username
                 password:(NSString *)password;

- (BOOL)isLogined;
- (void)checkLoginStatusWithBlock:(SLDataQueryCompleteBlock)block;
- (void)queryLoanBookInfoWithCompleteBlock:(SLDataQueryCompleteBlock)block;
@property (nonatomic, strong) SLUserModel *userInfo;
@end


