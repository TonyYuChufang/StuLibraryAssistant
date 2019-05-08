//
//  SLDiscoveryDataController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/5.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLDiscoveryDataController.h"
#import "SLBook.h"
#import "SLNetwokrManager.h"
#import <YYModel/YYModel.h>

@implementation SLDiscoveryDataController
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
        self.books = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return self;
}

- (void)queryNewBooks:(SLDataQueryCompleteBlock)block
{
    [self.books removeAllObjects];
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(13),@(12),@(1021)],
                            @"days":@(7),
                            @"offset":@(0),
                            @"rows":@(100)
                            };
    BlockWeakSelf(weakSelf, self);
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([json[@"success"] boolValue]) {
                for (NSDictionary *dict in json[@"data"][@"list"]) {
                    SLBookListItem *newbook = [SLBookListItem yy_modelWithJSON:dict];
                    [weakSelf.books addObject:newbook];
                }
            }
            if (block) {
                block(weakSelf.books,nil);
            }
        } else {
            if (block) {
                block(nil,error);
            }
        }
    }];
}
@end
