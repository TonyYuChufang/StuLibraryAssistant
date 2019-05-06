//
//  SLSettingViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/5.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLSettingViewController.h"
#import "SLSettingCellInfo.h"
#import "SLCacheManager.h"
#import "SLStyleManager+Theme.h"
#import <SDWebImage/SDImageCache.h>
#import "SIAlertView.h"
#import "SLLoginHeaderView.h"
#import "SLLoginDataController.h"

@interface SLSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *settingData;
@property (nonatomic, strong) SLLoginHeaderView *headerView;
@end

@implementation SLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSettingData];
    [self setupSubview];
    [self setupTableView];
}

- (void)viewDidLayoutSubviews
{
    self.headerView.sc_top = kStatusHeight;
    self.headerView.sc_left = 0;
    
    self.tableView.sc_left = 0;
    self.tableView.sc_top = self.headerView.sc_bottom;
}

- (void)setupSubview
{
    self.headerView = [[SLLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.headerView.viewType = SLHeaderViewTypeNoLogo;
    self.headerView.title = @"设置";
    [self setupHeaderBarItem];
    [self.headerView updateHeaderView];
    [self.view addSubview:self.headerView];
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

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)setupSettingData
{
    BlockWeakSelf(weakSelf, self);
    self.settingData = [[NSMutableArray alloc] initWithCapacity:2];
    NSMutableArray *normalSettings = [[NSMutableArray alloc] initWithCapacity:2];
    SLSettingCellInfo *cacheSetting = [[SLSettingCellInfo alloc] init];
    cacheSetting.cellType = SLSettingCellTypeCleanCache;
    cacheSetting.title = @"清除缓存";
    cacheSetting.settingCellDidClickedHandler = ^{
        [weakSelf clearCacheIfNeed];
    };
    [normalSettings addObject:cacheSetting];
    
    SLSettingCellInfo *aboutUsSetting = [[SLSettingCellInfo alloc] init];
    aboutUsSetting.cellType = SLSettingCellTypeAboutUs;
    aboutUsSetting.title = @"关于我们";
    aboutUsSetting.settingCellDidClickedHandler = ^{
        
    };
    [normalSettings addObject:aboutUsSetting];
    
    NSMutableArray *otherSettings = [[NSMutableArray alloc] initWithCapacity:2];
    SLSettingCellInfo *logOutSetting = [[SLSettingCellInfo alloc] init];
    logOutSetting.cellType = SLSettingCellTypeLogOut;
    logOutSetting.title = @"退出登录";
    logOutSetting.settingCellDidClickedHandler = ^{
        [weakSelf logout];
    };
    [otherSettings addObject:logOutSetting];
    
    [self.settingData addObject:normalSettings];
    if ([[SLLoginDataController sharedObject] isLogined]) {
        [self.settingData addObject:otherSettings];
    }
}
#pragma mark - UITablview Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.settingData objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLSettingCellInfo *cellInfo = self.settingData[indexPath.section][indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%ld_%ld",indexPath.section,indexPath.row]];
    
    switch (cellInfo.cellType) {
        case SLSettingCellTypeCleanCache:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"cell_%ld_%ld",indexPath.section,indexPath.row]];
            cell.textLabel.text = cellInfo.title;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1lf MB",[self getCachSize]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case SLSettingCellTypeAboutUs:
            cell.textLabel.text = cellInfo.title;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case SLSettingCellTypeLogOut: {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = cellInfo.title;
            titleLabel.font = [UIFont systemFontOfSize:17];
            titleLabel.textColor = [SLStyleManager RedColor];
            [titleLabel sizeToFit];
            [cell.contentView addSubview:titleLabel];
            titleLabel.sc_centerX = self.view.sc_width / 2.0;
            titleLabel.sc_centerY = cell.contentView.sc_height / 2.0;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLSettingCellInfo *cellInfo = self.settingData[indexPath.section][indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (cellInfo.settingCellDidClickedHandler) {
        cellInfo.settingCellDidClickedHandler();
    }
}
- (CGFloat)getCachSize
{
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];

    CGFloat totalSize = ((CGFloat)imageCacheSize+[[SLCacheManager sharedObject] diskTotalCost])/1024/1024;
    return totalSize;
}
- (void)clearCacheIfNeed
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"警告" andMessage:@"确定清除缓存吗?"];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    
    [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }];
    
    [alertView addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
        }];
        [[SLCacheManager sharedObject] removeAllObjects:^(NSString *key, id object) {
            
        }];
        [self.tableView reloadData];
    }];
    
    [alertView show];
}

- (void)logout
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"警告" andMessage:@"确定退出登陆吗?"];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    
    [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
        
    }];
    
    [alertView addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
        [KVNProgress showWithStatus:@"正在加载" onView:self.view];
        [[SLLoginDataController sharedObject] logoutWithBlock:^(id data, NSError *error) {
            if (error == nil) {
                [self.navigationController popViewControllerAnimated:YES];
                [KVNProgress dismiss];
            }
        }];
    }];
    [alertView show];
}
@end
