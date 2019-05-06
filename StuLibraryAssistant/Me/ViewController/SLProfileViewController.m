//
//  SLProfileViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/13.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLProfileViewController.h"
#import "SLLoginHeaderView.h"
#import "SLMenuItemView.h"
#import "SLStyleManager+Theme.h"
#import "SLLoginDataController.h"
#import "SLNetwokrManager.h"
#import "SLCacheManager.h"
#import "SLProfileToolView.h"
@interface SLProfileViewController ()

@property (nonatomic, strong) UIImageView *avaterView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *occupationLabel;
@property (nonatomic, strong) SLLoginHeaderView *headerView;
@property (nonatomic, strong) SLProfileToolView *toolView;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *studentIdLabel;
@property (nonatomic, strong) UILabel *cardNoLabel;
@property (nonatomic, strong) UILabel *collegeLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) NSMutableArray *statusTagViews;
@end

@implementation SLProfileViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setDefaultNavType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.statusTagViews = [[NSMutableArray alloc] initWithCapacity:2];
    [self setupSubview];
    [self updateAvatarView];
    [self queryLoanStatus];
}

- (void)setupSubview
{
    self.headerView = [[SLLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.headerView.viewType = SLHeaderViewTypeNoLogo;
    [self setupHeaderBarItem];
    [self.headerView updateHeaderView];
    [self.view addSubview:self.headerView];
    
    self.avaterView = [[UIImageView alloc] init];
    self.avaterView.image = [UIImage imageNamed:@"icon_avatar_defalut"];
    self.avaterView.layer.cornerRadius = 48;
    self.avaterView.layer.masksToBounds = YES;
    [self.view addSubview:self.avaterView];
    
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.textColor = [UIColor blackColor];
    self.nickNameLabel.font = [UIFont boldSystemFontOfSize:24];
    self.nickNameLabel.text = @"余楚放";
    [self.nickNameLabel sizeToFit];
    [self.view addSubview:self.nickNameLabel];
    
    self.occupationLabel = [[UILabel alloc] init];
    self.occupationLabel.textColor = [UIColor blackColor];
    self.occupationLabel.font = [UIFont systemFontOfSize:16];
    self.occupationLabel.text = @"学生";
    [self.occupationLabel sizeToFit];
    [self.view addSubview:self.occupationLabel];
    
    self.sexLabel = [[UILabel alloc] init];
    self.sexLabel.textColor = [SLStyleManager colorWithHexString:@"#3B3B3B"];
    self.sexLabel.font = [UIFont systemFontOfSize:16];
    self.sexLabel.text = [[SLLoginDataController sharedObject].userInfo.sex isEqualToString:@"male"] ? @"性别: 男" : @"性别: 女";
    [self.sexLabel sizeToFit];
    [self.view addSubview:self.sexLabel];
    
    self.studentIdLabel = [[UILabel alloc] init];
    self.studentIdLabel.textColor = [SLStyleManager colorWithHexString:@"#3B3B3B"];
    self.studentIdLabel.font = [UIFont systemFontOfSize:16];
    self.studentIdLabel.text = [NSString stringWithFormat:@"学号: %@",[SLLoginDataController sharedObject].userInfo.memberNo];
    [self.studentIdLabel sizeToFit];
    [self.view addSubview:self.studentIdLabel];
    
    self.cardNoLabel = [[UILabel alloc] init];
    self.cardNoLabel.textColor = [SLStyleManager colorWithHexString:@"#3B3B3B"];
    self.cardNoLabel.font = [UIFont systemFontOfSize:16];
    self.cardNoLabel.text = [NSString stringWithFormat:@"证号: %@",[SLLoginDataController sharedObject].userInfo.cardNo];
    [self.cardNoLabel sizeToFit];
    [self.view addSubview:self.cardNoLabel];
    
    self.collegeLabel = [[UILabel alloc] init];
    self.collegeLabel.textColor = [SLStyleManager colorWithHexString:@"#3B3B3B"];
    self.collegeLabel.font = [UIFont systemFontOfSize:16];
    self.collegeLabel.text = [NSString stringWithFormat:@"学院: %@",[SLLoginDataController sharedObject].userInfo.extension[@"college"]];
    [self.collegeLabel sizeToFit];
    [self.view addSubview:self.collegeLabel];
    
    self.emailLabel = [[UILabel alloc] init];
    self.emailLabel.textColor = [SLStyleManager colorWithHexString:@"#3B3B3B"];
    self.emailLabel.font = [UIFont systemFontOfSize:16];
    self.emailLabel.text = [NSString stringWithFormat:@"Email: %@",[SLLoginDataController sharedObject].userInfo.email];
    [self.emailLabel sizeToFit];
    [self.view addSubview:self.emailLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = [SLStyleManager colorWithHexString:@"#3B3B3B"];
    self.statusLabel.font = [UIFont systemFontOfSize:16];
    self.statusLabel.text = @"状态: ";
    [self.statusLabel sizeToFit];
    [self.view addSubview:self.statusLabel];
    
    for (NSArray *array in [SLLoginDataController sharedObject].userInfo.status) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        if ([array[0] isEqualToString:@"overdue"]) {
            imageView.image = [UIImage imageNamed:@"icon_profile_status_overdue"];
        } else if ([array[0] isEqualToString:@"debt"]) {
            imageView.image = [UIImage imageNamed:@"icon_profile_status_debt"];
        } else {
            imageView.image = [UIImage imageNamed:@"icon_profile_status_normal"];
        }
        [self.view addSubview:imageView];
        [self.statusTagViews addObject:imageView];
    }
    
    self.toolView = [[SLProfileToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 108)];
    self.toolView.debt = [self praseDebtStr:[SLLoginDataController sharedObject].userInfo.totalFine];
    [self.view addSubview:self.toolView];
}

- (void)setupHeaderBarItem
{
    SLHeaderBarItemInfo *backBarItem = [[SLHeaderBarItemInfo alloc] init];
    backBarItem.itemImageName = @"icon_navigationBar_back";
    backBarItem.barItemClickedHandler = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.headerView.leftBarItems addObject:backBarItem];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat centerX = self.view.sc_centerX;
    
    self.headerView.sc_top = kStatusHeight;
    self.headerView.sc_left = 0;
    
    self.avaterView.sc_top = 90;
    self.avaterView.sc_size = CGSizeMake(96, 96);
    self.avaterView.sc_centerX = centerX;
    
    self.nickNameLabel.sc_centerX = centerX;
    self.nickNameLabel.sc_top = self.avaterView.sc_bottom + 17;
    
    self.occupationLabel.sc_centerX = centerX;
    self.occupationLabel.sc_top = self.nickNameLabel.sc_bottom + 5;
    
    self.toolView.sc_height = 108;
    self.toolView.sc_width = kScreenWidth;
    self.toolView.sc_bottom = self.view.sc_bottom - 26;
    self.toolView.sc_left = 0;
    
    self.sexLabel.sc_top = self.occupationLabel.sc_bottom + 60;
    self.sexLabel.sc_left = 20;
    
    self.studentIdLabel.sc_top = self.sexLabel.sc_bottom + 10;
    self.studentIdLabel.sc_left = 20;
    
    self.cardNoLabel.sc_top = self.studentIdLabel.sc_bottom + 10;
    self.cardNoLabel.sc_left = 20;
    
    self.collegeLabel.sc_top = self.cardNoLabel.sc_bottom + 10;
    self.collegeLabel.sc_left = 20;
    
    self.emailLabel.sc_top = self.collegeLabel.sc_bottom + 10;
    self.emailLabel.sc_left = 20;
    
    self.statusLabel.sc_top = self.emailLabel.sc_bottom + 10;
    self.statusLabel.sc_left = 20;
    
    for (int i = 0; i < self.statusTagViews.count; i++) {
        UIView *view = [self.statusTagViews objectAtIndex:i];
        view.sc_left = self.statusLabel.sc_right + i * 10 + i * view.sc_width;
        view.sc_centerY = self.statusLabel.sc_centerY;
    }
}

- (void)updateAvatarView
{
    if ([[SLLoginDataController sharedObject] isLogined]) {
        [self setAvatarImageWith:[SLLoginDataController sharedObject].userInfo.avatar];
        self.nickNameLabel.text = [SLLoginDataController sharedObject].userInfo.nickName;
        NSString *role = [[SLLoginDataController sharedObject].userInfo.extensionType isEqualToString:@"student"] ? @"学生":@"老师";
        self.occupationLabel.text = role;
        [self.nickNameLabel sizeToFit];
        [self.occupationLabel sizeToFit];
    }
}

- (void)setAvatarImageWith:(NSString *)fileStr
{
    
    [[SLNetwokrManager sharedObject] getWithUrl:[NSString stringWithFormat:@"http://opac.lib.stu.edu.cn/jthq?fid=%@",fileStr] param:nil completeBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            UIImage *image = [UIImage imageWithData:responseObject];
            [[SLCacheManager sharedObject] setObject:image forKey:fileStr];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.avaterView.image = image;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.avaterView.image = [UIImage imageNamed:@"icon_avatar_defalut"];
            });
            NSLog(@"%@",error);
        }
    }];
}

- (NSString *)praseDebtStr:(NSString *)debt
{
    NSString *correntDebt = [NSString stringWithFormat:@"%.2lf",[debt floatValue] / 100.0];
    if ([debt floatValue] < 0) {
        correntDebt = [correntDebt stringByAppendingString:@" 欠款"];
    } else {
        correntDebt = [correntDebt stringByAppendingString:@" 正常"];
    }
    
    return correntDebt;
}
#pragma mark - Query Data
- (void)queryLoanStatus
{
    [[SLLoginDataController sharedObject] queryLoanBookInfoWithCompleteBlock:^(id data, NSError *error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.toolView.loanBookCount = [NSString stringWithFormat:@"%lu/20 可借阅",[SLLoginDataController sharedObject].userInfo.totalBookCount];
            });
        }
    }];
}

@end
