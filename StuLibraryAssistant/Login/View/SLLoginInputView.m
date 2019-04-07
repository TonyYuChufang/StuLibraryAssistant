//
//  SLLoginInputView.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/13.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLoginInputView.h"
#import "SLStyleManager+Theme.h"
@interface SLLoginInputView ()

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIView *sperateLine;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation SLLoginInputView

- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.usernameTextField.sc_size = CGSizeMake(self.sc_width - 40, 32);
    self.usernameTextField.sc_top = 14;
    self.usernameTextField.sc_centerX = self.sc_centerX;
    
    self.sperateLine.sc_size = CGSizeMake(self.sc_width, 1);
    self.sperateLine.sc_top = self.usernameTextField.sc_bottom + 14;
    self.sperateLine.sc_centerX = self.sc_centerX;
    
    self.passwordTextField.sc_size = CGSizeMake(self.sc_width - 40, 32);
    self.passwordTextField.sc_top = self.sperateLine.sc_bottom + 14;
    self.passwordTextField.sc_centerX = self.sc_centerX;
    
    self.tipsLabel.sc_size = CGSizeMake(self.sc_width-20, 28);
    self.tipsLabel.sc_top = self.passwordTextField.sc_bottom + 10;
    self.tipsLabel.sc_left = 10;
}

- (void)setupUI
{
    UITextField *username = [[UITextField alloc] init];
    username.backgroundColor = [UIColor clearColor];
    username.textColor = [SLStyleManager DarkGrayColor];
    username.placeholder = @"校园网账号";
    username.textAlignment = NSTextAlignmentCenter;
    username.font = [UIFont systemFontOfSize:16];
    [self addSubview:username];
    self.usernameTextField = username;
    [self.usernameTextField addTarget:self action:@selector(onInputFieldChange:) forControlEvents:UIControlEventEditingChanged];

    
    UITextField *password = [[UITextField alloc] init];
    password.backgroundColor = [UIColor clearColor];
    password.textColor = [SLStyleManager DarkGrayColor];
    password.placeholder = @"校园网密码";
    password.textAlignment = NSTextAlignmentCenter;
    password.font = [UIFont systemFontOfSize:16];
    password.secureTextEntry = YES;
    [self addSubview:password];
    self.passwordTextField = password;
    [self.passwordTextField addTarget:self action:@selector(onInputFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [SLStyleManager LightGrayColor];
    [self addSubview:line];
    self.sperateLine = line;
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.hidden = YES;
    tipsLabel.textColor = [SLStyleManager RedColor];
    tipsLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:tipsLabel];
    self.tipsLabel = tipsLabel;
}

- (void)showTipsWithType:(SLLoginTipsType)tipsType
{
    switch (tipsType) {
        case SLLoginTipsTypeUsername: {
            self.tipsLabel.hidden = NO;
            self.tipsLabel.text = @"请输入校园网账号";
        }
            break;
        case SLLoginTipsTypePassword: {
            self.tipsLabel.hidden = NO;
            self.tipsLabel.text = @"请输入校园网密码";
        }
        default:
            break;
    }
}

- (void)onInputFieldChange:(UITextField *)textfield
{
    if (textfield == self.usernameTextField) {
        self.username = self.usernameTextField.text;
    } else if (textfield == self.passwordTextField) {
        self.password = self.passwordTextField.text;
    }
}
@end
