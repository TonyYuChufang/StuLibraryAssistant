//
//  SLMainSearchViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/19.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLMainSearchViewController.h"
#import "SLMenuViewController.h"
#import "SLBookDetailViewController.h"
#import "SLMainSearchDataController.h"
#import "SLBookDetailDataController.h"
#import "SLLoginDataController.h"
#import "SLBook.h"
#import "SLSearchBookCellViewModel.h"
#import "SLMainSearchBookCell.h"
#import "SLSearchBarCell.h"
#import "SLSearchBar.h"
#import "SLStyleManager+Theme.h"
#import "SLLoginHeaderView.h"

#import <MJRefresh/MJRefresh.h>
#import <UIImageView-PlayGIF/UIImageView+PlayGIF.h>
#import <WYPopoverController/WYPopoverController.h>
#import "SLMainSearchNotification.h"

static NSString * const kSLMainSearchBookCellID = @"kSLMainSearchBookCellID";
static CGFloat kSearchBarHeight = 24;
static int64_t kDefaultSearchRows = 20;
@interface SLMainSearchViewController () <UITableViewDelegate,UITableViewDataSource,SLSearchBarDelegate,SLMainSearchBookCellDelegate>
{
    NSUInteger _currentPage;
}
@property (nonatomic, strong) UITableView *bookTableView;
@property (nonatomic, strong) SLSearchBar *searchBar;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) SLLoginHeaderView *headerView;

@end

@implementation SLMainSearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.bookTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    _currentPage = 0;
    [self setupSubview];
    [self setupLayout];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReciveBookList:) name:kQueryBookListCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReciveNoMoreBooks:) name:kQueryBookListNoMoreDataNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReciveQueryFail:) name:kQueryBookListFailNotification object:nil];

    [[SLLoginDataController sharedObject] requestMyStuLoginParamWithBlock:^(id data, NSError *error) {
        [[SLLoginDataController sharedObject] loginWithUserName:@"15ybli" password:@"Mky5537"];
    }];
}

- (void)setupTableView
{
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.sc_width, self.view.sc_height - kNavigationBarHeight) style:UITableViewStyleGrouped];
    
    [tableview registerClass:[SLMainSearchBookCell class] forCellReuseIdentifier:kSLMainSearchBookCellID];
    
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor whiteColor];
    tableview.sectionIndexColor = [UIColor grayColor];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.estimatedRowHeight = 162;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreBooks)];
    footer.hidden = YES;
    tableview.mj_footer = footer;
    self.bookTableView = tableview;
    [self.view addSubview:self.bookTableView];
}

- (void)setupSubview
{
    
    [self setupTableView];
    self.searchBar = [[SLSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.sc_width - 60, 24)];
    self.searchBar.placeholder = @"搜索你喜欢的书籍";
    self.searchBar.delegate = self;
    
    self.headerView = [[SLLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.headerView.viewType = SLHeaderViewTypeMiddleLogo;
    [self setupBarItem];
    [self.headerView updateHeaderView];
    [self.view addSubview:self.headerView];
    
}

- (void)setupBarItem
{
    BlockWeakSelf(weakSelf, self);
    SLHeaderBarItemInfo *menuItem = [[SLHeaderBarItemInfo alloc] init];
    menuItem.itemImageName = @"icon_navigationBar_menu";
    menuItem.barItemClickedHandler = ^{
        SLMenuViewController *menuVC = [[SLMenuViewController alloc] init];
        weakSelf.navigationController.pushType = SLPushTypeFromLeft;
        [weakSelf.navigationController pushViewController:menuVC animated:YES];
    };
    [self.headerView.leftBarItems addObject:menuItem];
    
    SLHeaderBarItemInfo *searchTypeItem = [[SLHeaderBarItemInfo alloc] init];
    searchTypeItem.itemImageName = @"icon_navigationBar_searchType";
    searchTypeItem.barItemClickedHandler = ^{
        SLBookDetailViewController *detailVC = [[SLBookDetailViewController alloc] init];
        weakSelf.navigationController.pushType = SLPushTypeFromRight;
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
    [self.headerView.rightBarItems addObject:searchTypeItem];
}

- (void)setupLayout
{
    self.headerView.sc_top = kStatusHeight;
    self.headerView.sc_left = 0;
    self.bookTableView.sc_top = self.headerView.sc_bottom;
}
- (void)setupLoadingAnimation{
    self.animationView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight + kSearchBarHeight + 20, kScreenWidth, kScreenHeight - kNavigationBarHeight - kSearchBarHeight - 20)];
    self.animationView.backgroundColor = [UIColor whiteColor];
    self.animationView.alpha = 0;
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    gifImageView.center = CGPointMake(kScreenWidth / 2, (kScreenHeight - kNavigationBarHeight - kSearchBarHeight - 20) / 2 - 120);
    gifImageView.gifPath = [[NSBundle mainBundle] pathForResource:@"book" ofType:@"gif"];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    loadingLabel.sc_centerX = self.view.sc_centerX;
    loadingLabel.sc_top = gifImageView.sc_bottom;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [SLStyleManager LightGrayColor];
    loadingLabel.text = @"正在努力加载~";
    
    [self.animationView addSubview:loadingLabel];
    [self.animationView addSubview:gifImageView];
    [gifImageView startGIF];

    [self.view addSubview:self.animationView];
    [UIView animateWithDuration:0.5 animations:^{
        self.animationView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeLoadingAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        self.animationView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.animationView removeFromSuperview];
    }];
}

#pragma mark - Notification
- (void)onReciveBookList:(NSNotification *)notification
{
    [_bookTableView reloadData];
    if ([SLMainSearchDataController sharedObject].bookItemList.count) {
        self.bookTableView.mj_footer.hidden = NO;
    }
    [self.bookTableView.mj_footer endRefreshing];
    [self removeLoadingAnimation];
}

- (void)onReciveNoMoreBooks:(NSNotification *)notification
{
    [self.bookTableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)onReciveQueryFail:(NSNotification *)notification
{
    [KVNProgress showErrorWithStatus:@"加载失败，请重试"];
    [self.bookTableView.mj_footer endRefreshing];
    [self removeLoadingAnimation];
}

#pragma mark - Tableview Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SLSearchBarCell *cell = [[SLSearchBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kSearchBarCell"];
        [cell updateSearchBar:self.searchBar];
        return cell;
    } else {
        SLMainSearchBookCell *cell = (SLMainSearchBookCell *)[tableView dequeueReusableCellWithIdentifier:kSLMainSearchBookCellID];
        if (cell == nil) {
            cell = [[SLMainSearchBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSLMainSearchBookCellID];
        }
        cell.delegate = self;
        SLBookListItem *book = [SLMainSearchDataController sharedObject].bookItemList[indexPath.row];
        SLSearchBookCellViewModel *viewModel = [SLSearchBookCellViewModel bookCellViewModelWithBook:book];
        [cell bindBookCellViewModel:viewModel];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 24;
    }
    
    return 162;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [SLMainSearchDataController sharedObject].bookItemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    SLBookDetailViewController *detailVC = [[SLBookDetailViewController alloc] init];
    SLBookListItem *book = [SLMainSearchDataController sharedObject].bookItemList[indexPath.row];
    detailVC.bookInfo = book;
    [self.navigationController setDefaultNavType];
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - SLSearchBarDelegate
- (void)slSearchBarDidSelectReturnWithText:(NSString *)text
{
    NSLog(@"Did Select Return");
    [[SLMainSearchDataController sharedObject] queryBookWithText:text page:1 rows:kDefaultSearchRows shouldIncrement:NO];
    self.searchBar.text = nil;
    [self setupLoadingAnimation];
    if ([SLMainSearchDataController sharedObject].bookItemList.count) {
        [self.bookTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    [self.view endEditing:YES];
}
#pragma mark - SLMainSearchBookCellDelegate
- (void)didSelectMarkBtnBookCell:(SLMainSearchBookCell *)cell isCollected:(BOOL)isCollected
{
    NSIndexPath *indexPath = [self.bookTableView indexPathForCell:cell];
    SLBookListItem *book = [SLMainSearchDataController sharedObject].bookItemList[indexPath.row];
    BlockWeakSelf(weakSelf, self);
    if (isCollected) {
        [[SLBookDetailDataController sharedObject] cancelCollectBook:book.CTRLNO complete:^(id data, NSError *error) {
            if (error == nil) {
                book.COLLECTED = @"false";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell updateMarkStatus:NO];
                    [SLProgressHUD showHUDWithText:@"取消收藏成功" inView:weakSelf.view delayTime:1.5];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                   [SLProgressHUD showHUDWithText:@"取消收藏失败，请重试" inView:weakSelf.view delayTime:1.5];
                });
            }
        }];
    } else {
        [[SLBookDetailDataController sharedObject] collectBook:book.CTRLNO complete:^(id data, NSError *error) {
            if (error == nil) {
                book.COLLECTED = @"true";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell updateMarkStatus:YES];
                    [SLProgressHUD showHUDWithText:@"收藏成功" inView:weakSelf.view delayTime:1.5];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SLProgressHUD showHUDWithText:@"收藏失败，请重试" inView:weakSelf.view delayTime:1.5];
                });
            }
        }];
    }
}

#pragma mark - Private
- (void)loadMoreBooks
{
    [[SLMainSearchDataController sharedObject] loadMoreBookLists];
}
@end
