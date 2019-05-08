//
//  SLLoginDataController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/14.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLoginDataController.h"
#import "SLMainSearchDataController.h"
#import "SLNetwokrManager.h"
#import <IGHTMLQuery/IGHTMLQuery.h>
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "SLCacheManager.h"
#import "SLUserDefault.h"

static NSString *kOpacTarget = @"aHR0cDovL29wYWMubGliLnN0dS5lZHUuY24vc3NvTG9naW4ucGhw";
static NSString *kOpacService = @"aHR0cDovL29wYWMubGliLnN0dS5lZHUuY24vc3NvUmVkaXJlY3QucGhwP3VybD1vcGFjLnBocA==";
N_Def(kLoginCompleteNotification);
N_Def(kLogoutCompleteNotification);
N_Def(kQueryUserInfoSuccessNotification);

@interface SLLoginDataController ()

@property (nonatomic, copy) NSDictionary *loginParam;
@property (nonatomic, copy) NSString *ticketUrl;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *ticketCookie;
@property (nonatomic, copy) NSString *opacKey;
@property (nonatomic, copy) NSString *opacToken;


@end

@implementation SLLoginDataController

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
        self.userInfo = [SLUserModel yy_modelWithJSON:[[SLUserDefault sharedObject] objectForKey:kUserInfoKey]];
    }
    
    return self;
}

- (void)requestMyStuLoginParamWithBlock:(SLDataQueryCompleteBlock)block
{
    BlockWeakSelf(weakSelf, self);
    [[SLNetwokrManager sharedObject] getWithUrl:@"https://sso.stu.edu.cn/login?service=http%3a%2f%2fopac.lib.stu.edu.cn%2fssoRedirect.php%3furl%3dopac.php" param:nil completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            [weakSelf updateLoginParamWithHtmlStr:htmlStr];
        }
        if (block) {
            block(responseObject, error);
        }
    }];
}

- (void)updateLoginParamWithHtmlStr:(NSString *)htmlStr
{
    NSError *htmlError = nil;
    IGHTMLDocument *document = [[IGHTMLDocument alloc] initWithHTMLString:htmlStr error:&htmlError];
    IGXMLNodeSet *nodeSet = [document queryWithXPath:@"//*[@id='fm1']/input"];
    NSString *ltStr = [(IGXMLNode *)[nodeSet objectAtIndexedSubscript:0] attribute:@"value"];
    NSString *executionStr = [(IGXMLNode *)[nodeSet objectAtIndexedSubscript:1] attribute:@"value"];
    NSString *eventId = [(IGXMLNode *)[nodeSet objectAtIndexedSubscript:2] attribute:@"value"];
    self.loginParam = @{
                        @"lt":ltStr,
                        @"execution":executionStr,
                        @"_eventId":eventId
                        };
}

- (void)loginWithUserName:(NSString *)username
                 password:(NSString *)password
                completed:(SLDataQueryCompleteBlock)block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"text/html",@"application/json",@"text/xml",@"application/xml", nil];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:self.loginParam];
    [param setObject:username forKey:@"username"];
    [param setObject:password forKey:@"password"];
    [manager POST:@"https://sso.stu.edu.cn/login?service=http%3a%2f%2fopac.lib.stu.edu.cn%2fssoRedirect.php%3furl%3dopac.php" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([result containsString:@"The credentials you provided cannot be determined to be authentic"]) {
            if (block) {
                NSError *error = [NSError errorWithDomain:@"用户名或密码错误" code:401 userInfo:nil];
                block(@"用户名或密码错误",error);
            }
        }
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        self.sessionId = [allHeaders objectForKey:@"Set-Cookie"];
        
        if (self.sessionId == nil) {
            return ;
        }
        [[SLUserDefault sharedObject] setObject:self.sessionId forKey:kOpacCookieKey];
        [self queryOpacKeyWithBlock:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (block) {
            block(@"请求失败",error);
        }
    }];
    
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        NSDictionary *dict = [(NSHTTPURLResponse *)response allHeaderFields];
        self.ticketCookie = dict[@"Set-Cookie"];
        self.ticketUrl = request.URL.absoluteString;
        NSMutableURLRequest *newReq = [[NSMutableURLRequest alloc] initWithURL:request.URL];
        [newReq setValue:dict[@"Set-Cookie"] forHTTPHeaderField:@"Cookie"];
        return newReq;
    }];
}

- (void)queryProfieInfo
{
    [[SLNetwokrManager sharedObject] setRequestHeaderWithDict:@{@"Cookie":self.sessionId}];
    
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:@{@"SERVICE_ID":@[@(0),@(1),@(0)],@"tid":@"0"} completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if (!jsonData[@"success"]) {
                return ;
            }
            self.userInfo = [SLUserModel yy_modelWithJSON:jsonData[@"data"]];
            [[SLUserDefault sharedObject] setObject:jsonData[@"data"] forKey:kUserInfoKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kQueryUserInfoSuccessNotification object:nil];
        } else {
            NSLog(@"%@",error);
        }
    }];
}

- (void)queryOpacKeyWithBlock:(SLDataQueryCompleteBlock)block
{
    [[SLNetwokrManager sharedObject] setRequestHeaderWithDict:@{@"Cookie":self.sessionId}];
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:@{@"SERVICE_ID":@[@(0),@(0),@(10)],@"tid":@"0"} completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",jsonData);
            if (!jsonData[@"success"]) {
                error = [NSError errorWithDomain:@"服务器出了点问题" code:500 userInfo:nil];
            } else {
                self.opacKey = jsonData[@"data"];
                [self queryOpacTokenWithBlock:block];
            }
            if (block) {
                if (error) {
                    block(error.domain,error);
                }
            }
        } else {
            if (block) {
                block(@"请求失败",error);
            }
            NSLog(@"%@",error);
        }
    }];
}

- (void)queryOpacTokenWithBlock:(SLDataQueryCompleteBlock)block
{
    [[SLNetwokrManager sharedObject] setRequestHeaderWithDict:@{@"Cookie":self.sessionId}];
    NSRange range = [self.ticketUrl rangeOfString:@"ticket="];
    NSString *tokenUrl = [self.ticketUrl substringFromIndex:range.location];

    [[SLNetwokrManager sharedObject] getWithUrl:[NSString stringWithFormat:@"http://opac.lib.stu.edu.cn/libsso?url=opac.php&%@",tokenUrl] param:@{@"key":self.opacKey,@"target":kOpacTarget,@"service":kOpacService} completeTaskBlock:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        if (error == nil) {
            NSRange tokenRange = [task.currentRequest.URL.absoluteString rangeOfString:@"token="];
            NSString *token = [task.currentRequest.URL.absoluteString substringFromIndex:tokenRange.location + tokenRange.length];
            NSRange urlrange = [token rangeOfString:@"&url="];
            token = [token substringToIndex:urlrange.location];
            self.opacToken = [token stringByRemovingPercentEncoding];
            [self queryMemberCodeWithBlock:block];
        } else {
            if (block) {
                block(@"请求失败",error);
            }
            NSLog(@"%@",error);
        }
    }];
}

- (void)queryMemberCodeWithBlock:(SLDataQueryCompleteBlock)block
{
    [[SLNetwokrManager sharedObject] setRequestHeaderWithDict:@{@"Cookie":self.sessionId}];
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(0),@(0),@(0)],
                            @"encType":@"rsa",
                            @"token":self.opacToken
                            };
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeTaskBlock:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if (!jsonData[@"success"]) {
                error = [NSError errorWithDomain:@"服务器出了点问题" code:500 userInfo:nil];
            } else {
                [self queryProfieInfo];
            }
            if (block) {
                block(error.domain,error);
            }
        } else {
            if (block) {
                block(@"请求失败",error);
            }
            NSLog(@"%@",error);
        }
    }];
}

- (void)checkLoginStatusWithBlock:(SLDataQueryCompleteBlock)block
{
    NSDictionary *param = @{
                            @"SERVICE_ID":@[@(0),@(0),@(8)],
                            };
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeTaskBlock:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([jsonData[@"data"] boolValue]) {
                if (block) {
                    block(@(YES),nil);
                }
            } else {
                if (block) {
                    block(@(NO),nil);
                }
            }
        } else {
            if (block) {
                block(@(NO),nil);
            }
            NSLog(@"%@",error);
        }
    }];
}

- (BOOL)isLogined
{
    if (self.userInfo.loginName) {
        return YES;
    }
    
    return NO;
}

- (void)queryLoanBookInfoWithCompleteBlock:(SLDataQueryCompleteBlock)block
{
    [self checkIfNeedLogin:^(id data, NSError *error) {
        if (error == nil) {
            NSDictionary *param = @{
                                    @"SERVICE_ID":@[@(13),@(10),@(1000)],
                                    @"function":@"readercenter",
                                    @"loanStatus":@[@"lent"],
                                    @"offset":@(0),
                                    @"rows":@(20)
                                    };
            [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:param completeBlock:^(id responseObject, NSError *error) {
                if (error == nil) {
                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    NSLog(@"%@",jsonData);
                    self.userInfo.bookList = jsonData[@"data"][@"list"];
                    self.userInfo.totalBookCount = [jsonData[@"data"][@"totalCount"] integerValue];
                    [[SLUserDefault sharedObject] setObject:[self.userInfo yy_modelToJSONObject] forKey:kUserInfoKey];
                    if (block) {
                        block(self.userInfo,nil);
                    }
                } else {
                    NSLog(@"%@",error);
                    if (block) {
                        block(nil,error);
                    }
                }
            }];
        } else {
            if (block) {
                block(nil,error);
            }
            NSLog(@"%@",error);
        }
    }];
   
}

- (void)logoutWithBlock:(SLDataQueryCompleteBlock)block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"text/html",@"application/json",@"text/xml",@"application/xml", nil];

    [manager GET:@"https://sso.stu.edu.cn/login?service=http%3a%2f%2fopac.lib.stu.edu.cn%2fssoRedirect.php%3furl%3dopac.php" parameters:@{@"service":@"http://opac.lib.stu.edu.cn/opac.php"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:@{@"SERVICE_ID":@[@0,@0,@(-1)],@"function":@"common",@"org_group_id":@"STULIB"} completeBlock:^(id responseObject, NSError *error) {
            [[SLUserDefault sharedObject] removeObejctForKey:kUsernameKey];
            [[SLUserDefault sharedObject] removeObejctForKey:kPasswordKey];
            [[SLUserDefault sharedObject] removeObejctForKey:kUserInfoKey];
            [[SLUserDefault sharedObject] removeObejctForKey:kOpacCookieKey];
            self.userInfo = nil;
            [[SLMainSearchDataController sharedObject] requestOpacSessionIDWithBlock:^(id data, NSError *error) {
                if (block) {
                    block(data,error);
                }
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutCompleteNotification object:nil];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
    
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        NSDictionary *dict = [(NSHTTPURLResponse *)response allHeaderFields];
        NSMutableURLRequest *newReq = [[NSMutableURLRequest alloc] initWithURL:request.URL];
        [newReq setValue:dict[@"Set-Cookie"] forHTTPHeaderField:@"Cookie"];
        return newReq;
    }];

}

- (void)loginWithLocalUserComplete:(SLDataQueryCompleteBlock)block
{
    NSString *username = [[SLUserDefault sharedObject] objectForKey:kUsernameKey];
    NSString *password = [[SLUserDefault sharedObject] objectForKey:kPasswordKey];
    if (username && password) {
        [self loginWithUserName:username password:password completed:block];
    }
}

- (void)checkIfNeedLogin:(SLDataQueryCompleteBlock)blcok
{
    [self checkLoginStatusWithBlock:^(id data, NSError *error) {
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
