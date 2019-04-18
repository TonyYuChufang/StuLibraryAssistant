//
//  SLUserModel.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/15.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLUserModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *cardNo;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *extensionType;
@property (nonatomic, copy) NSString *ldapId;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *memId;
@property (nonatomic, copy) NSString *memStatus;
@property (nonatomic, copy) NSString *memberNo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *orgNo;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *totalFine;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSDictionary *extension;
@property (nonatomic, strong) NSArray *status;
@property (nonatomic, strong) NSArray *bookList;
@property (nonatomic, assign) NSUInteger totalBookCount;

@end

