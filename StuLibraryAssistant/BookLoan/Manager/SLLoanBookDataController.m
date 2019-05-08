//
//  SLLoanBookDataController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/4.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLoanBookDataController.h"
#import "SLLoginDataController.h"
#import "SLLoanBook.h"
#import <YYModel/YYModel.h>
#import "SLNetwokrManager.h"

@implementation SLLoanBookDataController

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
        self.currentLoanBooks = [[NSMutableArray alloc] initWithCapacity:2];
        self.historyLoanBooks = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return self;
}
- (void)queryCurrentLoanBooksWithIncrement:(BOOL)shouldIncrement
                                 completed:(SLDataQueryCompleteBlock)block
{
    if (!shouldIncrement) {
        [self.currentLoanBooks removeAllObjects];
    }
    [self queryCurrentLoanBooks:block];
}

- (void)queryCurrentLoanBooks:(SLDataQueryCompleteBlock)block
{
    [self checkLoginStatusWithBlock:^(id data, NSError *error) {
        if (error == nil) {
            NSDictionary *param = @{
                                    @"SERVICE_ID":@[@(13),@(10),@(1000)],
                                    @"function":@"readercenter",
                                    @"loanStatus":@[@"lent"],
                                    @"orderSort":@"ASC",
                                    @"orderType":@"due_time",
                                    @"offset":@(0),
                                    @"rows":@(655342)
                                    };
            BlockWeakSelf(weakSelf, self);
            [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
                if (error == nil) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    for (NSDictionary *dict in json[@"data"][@"list"]) {
                        SLLoanBook *loanBook = [SLLoanBook yy_modelWithJSON:dict];
                        [weakSelf.currentLoanBooks addObject:loanBook];
                    }
                    if (block) {
                        block(weakSelf.currentLoanBooks,nil);
                    }
                } else {
                    if (block) {
                        block(nil,error);
                    }
                }
            }];
        } else {
            if (block) {
                block(nil,error);
            }
        }
    }];
   
}

- (void)queryHistoryLoanBooksWithIncrement:(BOOL)shouldIncrement
                                 completed:(SLDataQueryCompleteBlock)block
{
    if (!shouldIncrement) {
        [self.historyLoanBooks removeAllObjects];
    }
    [self queryHistoryLoanBooks:block];
}

- (void)queryHistoryLoanBooks:(SLDataQueryCompleteBlock)block
{
    [self checkLoginStatusWithBlock:^(id data, NSError *error) {
        if (error == nil) {
            NSDictionary *param = @{
                                    @"SERVICE_ID":@[@(13),@(10),@(1000)],
                                    @"function":@"readercenter",
                                    @"loanStatus":@[@"normal_retu",@"expire_retu",@"damage_retu",@"exp_dam_retu",@"lost_retu"],
                                    @"orderSort":@"desc",
                                    @"orderType":@"due_time",
                                    @"offset":@(0),
                                    @"rows":@(655342)
                                    };
            BlockWeakSelf(weakSelf, self);
            [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
                if (error == nil) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    for (NSDictionary *dict in json[@"data"][@"list"]) {
                        SLLoanBook *loanBook = [SLLoanBook yy_modelWithJSON:dict];
                        [weakSelf.historyLoanBooks addObject:loanBook];
                    }
                    if (block) {
                        block(weakSelf.historyLoanBooks,nil);
                    }
                } else {
                    if (block) {
                        block(nil,error);
                    }
                }
            }];
        } else {
            if (block) {
                block(nil,error);
            }
        }
    }];
   

}

- (void)checkLoginStatusWithBlock:(SLDataQueryCompleteBlock)blcok
{
    if (![[SLLoginDataController sharedObject] isLogined]) {
        if (blcok) {
            blcok(@YES,nil);
        }
        return;
    }
    [[SLLoginDataController sharedObject] checkLoginStatusWithBlock:^(id data, NSError *error) {
        if ([data boolValue]) {
            if (blcok) {
                blcok(data,error);
            }
        } else {
            [[SLLoginDataController sharedObject] requestMyStuLoginParamWithBlock:^(id data, NSError *error) {
                if (error == nil) {
                    [[SLLoginDataController sharedObject] loginWithLocalUserComplete:^(id data, NSError *error) {
                        if (blcok) {
                            blcok(data,error);
                        }
                    }];
                } else {
                    if (blcok) {
                        blcok(data,error);
                    }
                }
            }];
        }
    }];
}
@end
