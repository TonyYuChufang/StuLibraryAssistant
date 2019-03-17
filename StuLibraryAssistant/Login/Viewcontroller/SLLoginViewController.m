//
//  SLLoginViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/13.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLoginViewController.h"
#import "SLStyleManager.h"
@interface SLLoginViewController ()
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UILabel *laCopyRightLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@end

@implementation SLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"SIGN IN" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = [SLStyleManager colorWithHexString:@"#99ce66"];
    [loginBtn addTarget:self action:@selector(onLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UIImageView *logo = [[UIImageView alloc] init];
    [logo setImage:[UIImage imageNamed:@"login_icon_logo"]];
    [self.view addSubview:logo];
    self.logoImageView = logo;
    
    UILabel *copyright = [[UILabel alloc] init];
    copyright.text = @"STULA©️2019";
    copyright.font = [UIFont boldSystemFontOfSize:16];
    copyright.textColor = [UIColor blackColor];
    
}

#pragma mark - Action
- (void)onLoginBtnClicked:(UIButton *)sender
{
    
}
@end
