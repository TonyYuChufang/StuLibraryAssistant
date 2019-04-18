//
//  SLLoginDataController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/14.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLoginDataController.h"
#import "SLNetwokrManager.h"
#import <IGHTMLQuery/IGHTMLQuery.h>
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "SLCacheManager.h"

static NSString *kOpacTarget = @"aHR0cDovL29wYWMubGliLnN0dS5lZHUuY24vc3NvTG9naW4ucGhw";
static NSString *kOpacService = @"aHR0cDovL29wYWMubGliLnN0dS5lZHUuY24vc3NvUmVkaXJlY3QucGhwP3VybD1vcGFjLnBocA==";
static NSString *kOpacTokenKey = @"kOpacTokenKey";
static NSString *kUserInfoKey = @"kUserInfoKey";
N_Def(kLoginSuccessNotification);
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
        self.userInfo = [[SLCacheManager sharedObject] objectForKey:kUserInfoKey];
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
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"text/html",@"application/json",@"text/xml",@"application/xml", nil];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:self.loginParam];
    [param setObject:username forKey:@"username"];
    [param setObject:password forKey:@"password"];
    [manager POST:@"https://sso.stu.edu.cn/login?service=http%3a%2f%2fopac.lib.stu.edu.cn%2fssoRedirect.php%3furl%3dopac.php" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        self.sessionId = [allHeaders objectForKey:@"Set-Cookie"];
        if (self.sessionId == nil) {
            return ;
        }
        [self queryOpacKey];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
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
//    NSString *sessionID = [self.sessionId stringByReplacingOccurrencesOfString:@"path=/," withString:@"path=/;"];
    [[SLNetwokrManager sharedObject] setRequestHeaderWithDict:@{@"Cookie":self.sessionId}];
    
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:@{@"SERVICE_ID":@[@(0),@(1),@(0)],@"tid":@"0"} completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if (!jsonData[@"success"]) {
                return ;
            }
            self.userInfo = [SLUserModel yy_modelWithJSON:jsonData[@"data"]];
            [[SLCacheManager sharedObject] setObject:self.userInfo forKey:kUserInfoKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kQueryUserInfoSuccessNotification object:nil];
        } else {
            NSLog(@"%@",error);
        }
    }];
}

- (void)queryOpacKey
{
    [[SLNetwokrManager sharedObject] setRequestHeaderWithDict:@{@"Cookie":self.sessionId}];
    [[SLNetwokrManager sharedObject] postWithUrl:@"http://opac.lib.stu.edu.cn/libinterview" param:@{@"SERVICE_ID":@[@(0),@(0),@(10)],@"tid":@"0"} completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if (!jsonData[@"success"]) {
                return ;
            }
            NSLog(@"%@",jsonData);
            self.opacKey = jsonData[@"data"];
            [self queryOpacToken];
        } else {
            NSLog(@"%@",error);
        }
    }];
}

- (void)queryOpacToken
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
            [self queryMemberCode];
            NSLog(@"%@",token);
        } else {
            NSLog(@"%@",error);
        }
    }];
}

- (void)queryMemberCode
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
            NSLog(@"%@",jsonData);
            [self queryProfieInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
        } else {
            NSLog(@"%@",error);
        }
    }];
}

- (void)checkLoginStatusWithBlock:(SLDataQueryCompleteBlock)block
{
    [[SLNetwokrManager sharedObject] setRequestHeaderWithDict:@{@"Cookie":self.sessionId}];
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
            [[SLCacheManager sharedObject] setObject:self.userInfo forKey:kUserInfoKey];
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
}
@end
