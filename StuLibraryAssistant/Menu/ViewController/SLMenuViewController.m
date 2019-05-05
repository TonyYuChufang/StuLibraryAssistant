//
//  SLMenuViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/7.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLMenuViewController.h"
#import "SLMenuItemView.h"
#import "SLLoginHeaderView.h"
#import "SLStyleManager+Theme.h"
#import "SLProfileViewController.h"
#import "SLLoanBookViewController.h"
#import "SLCollectedBookViewController.h"
#import "SLLoginViewController.h"
#import "SLLoginDataController.h"
#import "SLNetwokrManager.h"
#import "SLCacheManager.h"

static CGFloat kMenuItemHeight = 120;
static CGFloat kMenuItemWidth = 130;

@interface SLMenuViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSMutableArray *itemInfoArray;
@property (nonatomic, strong) SLLoginHeaderView *headerView;
@property (strong, nonatomic) UIImageView *backView;
@property (nonatomic, strong) UIImageView *avaterView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *occupationLabel;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *horizatalLine1;
@property (nonatomic, strong) UIView *horizatalLine2;
@property (nonatomic, assign) CGPoint panBeginPoint;
@property (nonatomic, assign) CGPoint panEndPoint;

@end

@implementation SLMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReciveProfileInfo:) name:kQueryUserInfoSuccessNotification object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.popType = SLPushTypeFromRight;
}

- (void)setupItems
{
    self.itemsArray = [[NSMutableArray alloc] init];
    self.itemInfoArray = [[NSMutableArray alloc] init];
    
    [self setupItemInfos];
    int i = 0;
    for (SLMenuItemInfo *info in self.itemInfoArray) {
        SLMenuItemView *menuView = [SLMenuItemView menuItemViewWithInfo:info];
        menuView.tag = i;
        [self.view addSubview:menuView];
        [self.itemsArray addObject:menuView];
        i++;
    }
}

- (void)setupItemInfos
{
    BlockWeakSelf(weakSelf, self);
    SLMenuItemInfo *profileItem = [[SLMenuItemInfo alloc] init];
    profileItem.title = @"个人信息";
    profileItem.imageName = @"menu_icon_profile";
    profileItem.menuItemSelectedHandler = ^{
        [weakSelf showProfileViewControllerIfNeed];
    };
    [self.itemInfoArray addObject:profileItem];
    
    SLMenuItemInfo *collectionItem = [[SLMenuItemInfo alloc] init];
    collectionItem.title = @"我的收藏";
    collectionItem.imageName = @"menu_icon_collection";
    collectionItem.menuItemSelectedHandler = ^{
        [weakSelf showCollectedBookViewControllerIfNeed];
    };
    [self.itemInfoArray addObject:collectionItem];
    
    SLMenuItemInfo *bookloanItem = [[SLMenuItemInfo alloc] init];
    bookloanItem.title = @"我的借阅";
    bookloanItem.imageName = @"menu_icon_bookloan";
    bookloanItem.menuItemSelectedHandler = ^{
        [weakSelf showLoanBookViewControllerIfNeed];
    };
    [self.itemInfoArray addObject:bookloanItem];
    
    SLMenuItemInfo *searchItem = [[SLMenuItemInfo alloc] init];
    searchItem.title = @"书目检索";
    searchItem.imageName = @"menu_icon_bookSearch";
    searchItem.menuItemSelectedHandler = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.itemInfoArray addObject:searchItem];
    
    SLMenuItemInfo *discoveryItem = [[SLMenuItemInfo alloc] init];
    discoveryItem.title = @"发现广场";
    discoveryItem.imageName = @"menu_icon_discovery";
    discoveryItem.menuItemSelectedHandler = ^{
        
    };
    [self.itemInfoArray addObject:discoveryItem];
    
    SLMenuItemInfo *settingItem = [[SLMenuItemInfo alloc] init];
    settingItem.title = @"设置";
    settingItem.imageName = @"menu_icon_setting";
    settingItem.menuItemSelectedHandler = ^{
        
    };
    [self.itemInfoArray addObject:settingItem];
}

- (void)setupSubview
{
    self.headerView = [[SLLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.headerView.viewType = SLHeaderViewTypeLeftLogo;
    [self setupHeaderBarItem];
    [self.headerView updateHeaderView];
    [self.view addSubview:self.headerView];
    
    [self setupItems];
    self.avaterView = [[UIImageView alloc] init];
    self.avaterView.image = [UIImage imageNamed:@"icon_avatar_defalut"];
    if ([[SLLoginDataController sharedObject] isLogined]) {
        [self setAvatarImageWith:[SLLoginDataController sharedObject].userInfo.avatar];
    }
    self.avaterView.userInteractionEnabled = YES;
    self.avaterView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarClicked)];
    [self.avaterView addGestureRecognizer:tap];
    [self.view addSubview:self.avaterView];
    
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.textColor = [UIColor blackColor];
    self.nickNameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nickNameLabel.text = [[SLLoginDataController sharedObject] isLogined] ? [SLLoginDataController sharedObject].userInfo.nickName : @"未登录，点击头像登录";
    [self.nickNameLabel sizeToFit];
    [self.view addSubview:self.nickNameLabel];
    
    self.occupationLabel = [[UILabel alloc] init];
    self.occupationLabel.textColor = [SLStyleManager LightGrayColor];
    self.occupationLabel.font = [UIFont systemFontOfSize:14];
    NSString *role = [[SLLoginDataController sharedObject] isLogined] ? ([[SLLoginDataController sharedObject].userInfo.extensionType isEqualToString:@"student"] ? @"学生":@"老师"): @"";
    self.occupationLabel.text = role;
    [self.occupationLabel sizeToFit];
    [self.view addSubview:self.occupationLabel];
    
    self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 360)];
    self.verticalLine.backgroundColor = [SLStyleManager LightGrayColor];
    [self.view addSubview:self.verticalLine];
    
    self.horizatalLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 265, 1)];
    self.horizatalLine1.backgroundColor = [SLStyleManager LightGrayColor];
    [self.view addSubview:self.horizatalLine1];
    
    self.horizatalLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 265, 1)];
    self.horizatalLine2.backgroundColor = [SLStyleManager LightGrayColor];
    [self.view addSubview:self.horizatalLine2];
}

- (void)setupHeaderBarItem
{
    SLHeaderBarItemInfo *backBarItem = [[SLHeaderBarItemInfo alloc] init];
    backBarItem.itemImageName = @"icon_navigationBar_back";
    backBarItem.barItemClickedHandler = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.headerView.rightBarItems addObject:backBarItem];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat centerX = self.view.sc_centerX;
    
    self.headerView.sc_top = kStatusHeight;
    self.headerView.sc_left = 0;
    
    self.avaterView.sc_top = 90;
    self.avaterView.sc_size = CGSizeMake(96, 96);
    self.avaterView.layer.cornerRadius = 48;
    self.avaterView.sc_centerX = centerX;
    
    self.nickNameLabel.sc_centerX = centerX;
    self.nickNameLabel.sc_top = self.avaterView.sc_bottom + 17;
    
    self.occupationLabel.sc_centerX = centerX;
    self.occupationLabel.sc_top = self.nickNameLabel.sc_bottom + 5;
    
    self.verticalLine.sc_top = self.occupationLabel.sc_bottom + 45;
    self.verticalLine.sc_centerX = centerX;
    
    self.horizatalLine1.sc_top = self.verticalLine.sc_top + 120;
    self.horizatalLine1.sc_centerX = centerX;
    
    self.horizatalLine2.sc_top = self.horizatalLine1.sc_bottom + 120;
    self.horizatalLine2.sc_centerX = centerX;
    
    int i = 0;
    for (SLMenuItemView *itemView in self.itemsArray) {
        itemView.sc_size = CGSizeMake(kMenuItemWidth, kMenuItemHeight);
        if (itemView.tag % 2 == 0) {
            i++;
            itemView.sc_right = self.verticalLine.sc_left;
        } else {
            itemView.sc_left = self.verticalLine.sc_right;
        }
        
        switch (i) {
            case 1:
                itemView.sc_bottom = self.horizatalLine1.sc_top;
                break;
            case 2:
                itemView.sc_bottom = self.horizatalLine2.sc_top;
                break;
            case 3:
                itemView.sc_top = self.horizatalLine2.sc_bottom;
            default:
                break;
        }
    }
}

#pragma mark - Action

- (void)onAvatarClicked
{
    [self showProfileViewControllerIfNeed];
}

- (void)showProfileViewControllerIfNeed
{
    [self.navigationController setDefaultNavType];
    if ([[SLLoginDataController sharedObject] isLogined]) {
        SLProfileViewController *profileVC = [[SLProfileViewController alloc] init];
        [self.navigationController pushViewController:profileVC animated:YES];
        
    } else {
        SLLoginViewController *loginVC = [[SLLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)showLoanBookViewControllerIfNeed
{
    [self.navigationController setDefaultNavType];
    if ([[SLLoginDataController sharedObject] isLogined]) {
        SLLoanBookViewController *loanBookVC = [[SLLoanBookViewController alloc] init];
        [self.navigationController pushViewController:loanBookVC animated:YES];
        
    } else {
        SLLoginViewController *loginVC = [[SLLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)showCollectedBookViewControllerIfNeed
{
    [self.navigationController setDefaultNavType];
    if ([[SLLoginDataController sharedObject] isLogined]) {
        SLCollectedBookViewController *collectedBookVC = [[SLCollectedBookViewController alloc] init];
        [self.navigationController pushViewController:collectedBookVC animated:YES];
        
    } else {
        SLLoginViewController *loginVC = [[SLLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma mark - Query Data

- (void)setAvatarImageWith:(NSString *)fileStr
{
    [[SLNetwokrManager sharedObject] downloadOpacImageWithUrl:[NSString stringWithFormat:@"http://opac.lib.stu.edu.cn/jthq?fid=%@",fileStr] completeBlock:^(id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (responseObject) {
                self.avaterView.image = responseObject;
            } else {
                self.avaterView.image = [UIImage imageNamed:@"icon_avatar_defalut"];
            }
        });
    }];
}

#pragma mark - Notification
- (void)onReciveProfileInfo:(NSNotification *)notification
{
    [self setAvatarImageWith:[SLLoginDataController sharedObject].userInfo.avatar];
    self.nickNameLabel.text = [SLLoginDataController sharedObject].userInfo.nickName;
    NSString *role = [[SLLoginDataController sharedObject].userInfo.extensionType isEqualToString:@"student"] ? @"学生":@"老师";
    self.occupationLabel.text = role;
    [self.nickNameLabel sizeToFit];
    [self.occupationLabel sizeToFit];
}
@end
