//
//  SLMainSearchDataController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/21.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLMainSearchDataController.h"
#import "SLCacheManager.h"
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "SLNetwokrManager.h"
#import "SLBook.h"

static NSString * const opac_main_url = @"http://opac.lib.stu.edu.cn/opac.php";
static NSString * const opac_query_url = @"http://opac.lib.stu.edu.cn/libinterview";
static NSString * const kOpacCookieKey = @"kOpacCookieKey";
static NSString * const kOpaceGetCookieNotification = @"kOpaceGetCookieNotification";

@interface SLMainSearchDataController ()


@end

@implementation SLMainSearchDataController

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
        [self requestOpacSessionID];
        _bookItemList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)requestOpacSessionID
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"text/html",@"application/json",@"text/xml",@"application/xml", nil];
    
    [manager GET:opac_main_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        [[SLCacheManager sharedObject] setObject:allHeaders[@"Set-Cookie"] forKey:kOpacCookieKey];
        NSLog(@"%@",allHeaders[@"Set-Cookie"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:kOpaceGetCookieNotification object:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)queryBookWithText:(NSString *)text
                          page:(int64_t)page
                          rows:(int64_t)rows
               shouldIncrement:(BOOL)shouldIncrement
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *cookies = [NSString stringWithFormat:@"%@; org_group_id=STULIB",[[SLCacheManager sharedObject] objectForKey:kOpacCookieKey]];
    [[SLNetwokrManager sharedObject] setRequestHeaderWithDict:@{@"Cookie":cookies}];
    
    NSDictionary *dict = @{
                           @"SERVICE_ID":@[@(13),@(11),@(1000)],
                           @"function":@"opac",
                           @"query":@{
                                   @"type":@"b1",
                                   @"condition":@{@"ANY":text},
                                   @"pagination":@{@"page":@(1),@"pageSize":@(20),@"pageCount":@(10)},@"offset":@(0),@"rows":@(rows)
                                   }
                           };
    
    [[SLNetwokrManager sharedObject] postWithUrl:opac_query_url param:dict completeBlock:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            [self.bookItemList removeAllObjects];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            for (NSDictionary *book in jsonData[@"data"][@"content"]) {
                SLBookListItem *item = [SLBookListItem yy_modelWithJSON:book];
                
                NSLog(@"%@",item.TITLE);
                [result addObject:item];
            }
            [self.bookItemList addObjectsFromArray:result];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QueryBookListComplete" object:nil];
        }
    }];
}

@end
