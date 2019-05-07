//
//  SLAboutUsViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/6.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLAboutUsViewController.h"
#import "SLStyleManager+Theme.h"
#import "SLLoginHeaderView.h"

static CGFloat labelHeight = 22;

@interface SLAboutUsViewController ()

@property (nonatomic, strong) NSMutableArray *infos;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) NSMutableArray *infoLabels;
@property (nonatomic, strong) UILabel *developerLabel;
@property (nonatomic, strong) UILabel *cRightLabel;
@property (nonatomic, strong) SLLoginHeaderView *headerView;
@end

@implementation SLAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupSubview];
}

- (void)viewDidLayoutSubviews
{
    CGFloat centerX = kScreenWidth  / 2.0;
    self.headerView.sc_top = kStatusHeight;
    self.headerView.sc_left = 0;
    
    self.logoImageView.sc_top = self.headerView.sc_bottom + 20;
    self.logoImageView.sc_centerX = centerX;
    
    self.appNameLabel.sc_top = self.logoImageView.sc_bottom + 30;
    self.appNameLabel.sc_centerX = centerX;
    
    self.versionLabel.sc_top = self.appNameLabel.sc_bottom + 10;
    self.versionLabel.sc_centerX = centerX;
    
    for (int i = 0; i < self.infoLabels.count; i++) {
        UILabel *label = [self.infoLabels objectAtIndex:i];
        label.sc_top = self.versionLabel.sc_bottom + 30 + i * (labelHeight + 5);
        label.sc_centerX = centerX;
    }
    
    self.cRightLabel.sc_centerX = centerX;
    self.cRightLabel.sc_bottom = kScreenHeight - 20;
    
    self.developerLabel.sc_centerX = centerX;
    self.developerLabel.sc_bottom = self.cRightLabel.sc_top - 30;
}

- (void)setupData
{
    self.infos = [[NSMutableArray alloc] initWithArray:@[@"【功能介绍】",@"-书目检索-",@"-借阅信息-",@"-收藏信息-",@"-新书通报-",@"-预约书籍-",@"-个人信息-"]];
    self.infoLabels = [[NSMutableArray alloc] initWithCapacity:2];
}

- (void)setupSubview
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headerView = [[SLLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.headerView.viewType = SLHeaderViewTypeNoLogo;
    self.headerView.title = @"关于我们";
    [self setupHeaderBarItem];
    [self.headerView updateHeaderView];
    [self.view addSubview:self.headerView];
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 85, 100)];
    self.logoImageView.image = [UIImage imageNamed:@"login_icon_logo"];
    [self.view addSubview:self.logoImageView];
    
    self.appNameLabel = [[UILabel alloc] init];
    self.appNameLabel.text = @"汕头大学图书借还助手";
    self.appNameLabel.textColor = [UIColor blackColor];
    self.appNameLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.appNameLabel sizeToFit];
    [self.view addSubview:self.appNameLabel];
    
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@",APP_VERSION];
    self.versionLabel.textColor = [UIColor blackColor];
    self.versionLabel.font = [UIFont systemFontOfSize:20];
    [self.versionLabel sizeToFit];
    [self.view addSubview:self.versionLabel];
    
    self.cRightLabel = [[UILabel alloc] init];
    self.cRightLabel.text = @"STULA©️2019";
    self.cRightLabel.textColor = [SLStyleManager LightGrayColor];
    self.cRightLabel.font = [UIFont systemFontOfSize:12];
    [self.cRightLabel sizeToFit];
    [self.view addSubview:self.cRightLabel];
    
    self.developerLabel = [[UILabel alloc] init];
    self.developerLabel.text = @"由汕大课程表团队开发维护";
    self.developerLabel.textColor = [UIColor blackColor];
    self.developerLabel.font = [UIFont systemFontOfSize:12];
    [self.developerLabel sizeToFit];
    [self.view addSubview:self.developerLabel];
    
    for (NSString *title in self.infos) {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        [self.view addSubview:label];
        [self.infoLabels addObject:label];
    }
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
@end
