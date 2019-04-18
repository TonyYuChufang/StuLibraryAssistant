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
#import "SLLoginDataController.h"
#import <KVNProgress/KVNProgress.h>

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReciveLoginSuccess:) name:kLoginSuccessNotification object:nil];
}

- (void)viewDidLayoutSubviews
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setDefaultNavType];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    SLLoginHeaderView *headerView = [[SLLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    headerView.viewType = SLHeaderViewTypeNoLogo;
    headerView.title = @"SIGN IN";
    self.headerView = headerView;
    [self setupBarItem];
    [self.headerView updateHeaderView];
    [self.view addSubview:headerView];
    
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

- (void)setupBarItem
{
    BlockWeakSelf(weakSelf, self);
    SLHeaderBarItemInfo *backBarItem = [[SLHeaderBarItemInfo alloc] init];
    backBarItem.itemImageName = @"icon_navigationBar_back";
    backBarItem.barItemClickedHandler = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.headerView.leftBarItems addObject:backBarItem];
}

- (void)relayoutSubviews
{
    CGFloat centerX = self.view.sc_centerX;
    
    self.headerView.sc_top = kStatusHeight;
    self.headerView.sc_left = 0;
    
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
    NSLog(@"logining");
    
    [[SLLoginDataController sharedObject] requestMyStuLoginParamWithBlock:^(id  _Nonnull data, NSError * _Nonnull error) {
        [[SLLoginDataController sharedObject] loginWithUserName:self.loginInputView.username password:self.loginInputView.password];
    }];
}
#pragma mark - Notification

- (void)onReciveLoginSuccess:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

