//
//  SLLoginViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/13.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLoginViewController.h"
#import "SLLoginHeaderView.h"
#import "SLLoginInputView.h"
#import "SLStyleManager+Theme.h"
#import "SLProgressHUD.h"

@interface SLLoginViewController ()

@property (nonatomic, strong) SLLoginHeaderView *headerView;
@property (nonatomic, strong) SLLoginInputView *loginInputView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UILabel *laCopyRightLabel;
@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation SLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self relayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    SLLoginHeaderView *headerView = [[SLLoginHeaderView alloc] init];
    [self.view addSubview:headerView];
    self.headerView = headerView;
    
    SLLoginInputView *loginInputView = [[SLLoginInputView alloc] init];
    [self.view addSubview:loginInputView];
    self.loginInputView = loginInputView;
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"SIGN IN" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = [SLStyleManager MainGreenColor];
    [loginBtn addTarget:self action:@selector(onLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UIImageView *logo = [[UIImageView alloc] init];
    [logo setImage:[UIImage imageNamed:@"login_icon_logo"]];
    [self.view addSubview:logo];
    self.logoImageView = logo;
    
    UILabel *copyright = [[UILabel alloc] init];
    copyright.text = @"STULA©️2019";
    copyright.font = [UIFont systemFontOfSize:12];
    copyright.textColor = [SLStyleManager GrayColor];
    copyright.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:copyright];
    self.laCopyRightLabel = copyright;
}

- (void)relayoutSubviews
{
    CGFloat centerX = self.view.sc_centerX;
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    
    self.headerView.sc_size = CGSizeMake(self.view.sc_width, 44);
    self.headerView.sc_top = statusRect.size.height;
    self.headerView.sc_centerX = centerX;
    
    self.logoImageView.sc_size = CGSizeMake(85, 100);
    self.logoImageView.sc_top = self.headerView.sc_bottom + 33;
    self.logoImageView.sc_centerX = centerX;
    
    self.loginInputView.sc_size = CGSizeMake(self.view.sc_width, 120);
    self.loginInputView.sc_top = self.logoImageView.sc_bottom + 70;
    self.loginInputView.sc_centerX = centerX;
    
    self.loginBtn.sc_size = CGSizeMake(260, 48);
    self.loginBtn.sc_top = self.loginInputView.sc_bottom + 50;
    self.loginBtn.sc_centerX = centerX;
    self.loginBtn.layer.cornerRadius = 24;
    
    self.laCopyRightLabel.sc_size = CGSizeMake(300, 30);
    self.laCopyRightLabel.sc_bottom = self.view.sc_bottom - 20;
    self.laCopyRightLabel.sc_centerX = centerX;
}
#pragma mark - Action
- (void)onLoginBtnClicked:(UIButton *)sender
{
    NSLog(@"login成功啦");
    [SLProgressHUD showHUDWithText:@"登录成功" inView:self.navigationController.view delayTime:3];
    NSString *originalUrl = @"/G00/27/1b/51/NY95MtAXos99NZATNC4QcGc=AAABwL1ItLA=AAAAAAAAszA=oDaXXq==.jpg";
    NSMutableCharacterSet *encodeUrlSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [encodeUrlSet addCharactersInString:@"."];
    NSString *encodeUrl = [originalUrl stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    NSLog(@"%@", encodeUrl);
}
@end

