//
//  SLBookingInfo.h
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/8.
//  Copyright © 2019 yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLBookingInfo : NSObject

@property (nonatomic, copy) NSString *bookType;
@property (nonatomic, copy) NSString *bookTypeName;
@property (nonatomic, assign) BOOL canReserve;
@property (nonatomic, copy) NSString *infoVolume;
@property (nonatomic, copy) NSString *libIds;
@property (nonatomic, copy) NSString *resvNo;
@property (nonatomic, assign) BOOL reserve;
@property (nonatomic, assign) int64_t resvSequence;
@property (nonatomic, assign) int64_t totalCount;

- (void)updateLibIdWithDict:(NSDictionary *)dict;
@end

