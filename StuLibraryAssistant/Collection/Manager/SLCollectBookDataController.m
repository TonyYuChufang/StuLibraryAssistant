//
//  SLCollectBookDataController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/5.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLCollectBookDataController.h"
#import "SLCollectedBook.h"
#import "SLNetwokrManager.h"
#import <YYModel/YYModel.h>

@implementation SLCollectBookDataController

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
        self.collectedBooks = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return self;
}

- (void)queryCollectedBooksWithIncrement:(BOOL)shouldIncrement
                               completed:(SLDataQueryCompleteBlock)block
{
    if (!shouldIncrement) {
        [self.collectedBooks removeAllObjects];
    }
    [self queryCollectedBooks:block];
}

- (void)queryCollectedBooks:(SLDataQueryCompleteBlock)block
{
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(13),@(20),@(1010)],
                            @"offset":@(0),
                            @"pageSize":@(10),
                            @"page":@(1),
                            @"rows":@(10)
                            };
    BlockWeakSelf(weakSelf, self);
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            for (NSDictionary *dict in json[@"data"][@"list"]) {
                SLCollectedBook *collectBook = [SLCollectedBook yy_modelWithJSON:dict];
                [weakSelf.collectedBooks addObject:collectBook];
            }
            if (block) {
                block(weakSelf.collectedBooks,nil);
            }
        } else {
            if (block) {
                block(nil,error);
            }
        }
    }];
}
@end
