//
//  SLCollectedBookViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/5.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLCollectedBookViewController.h"
#import "SLBookDetailViewController.h"
#import "SLLoginHeaderView.h"
#import "SLMainSearchBookCell.h"
#import "SLCollectBookCellViewModel.h"
#import "SLCollectedBook.h"
#import "SLCollectBookDataController.h"
#import "SLBookDetailDataController.h"
#import <MJRefresh/MJRefresh.h>
#import "UIScrollView+EmptyView.h"

static NSString * kLoanBookCellID = @"kLoanBookCellID";

@interface SLCollectedBookViewController ()<UITableViewDelegate,UITableViewDataSource,SLMainSearchBookCellDelegate>

@property (nonatomic, strong) SLLoginHeaderView *headerView;
@property (nonatomic, strong) UITableView *bookTableView;

@end

@implementation SLCollectedBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
    [self.bookTableView.mj_header beginRefreshing];

}

- (void)setupSubview
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    
    self.headerView = [[SLLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.headerView.viewType = SLHeaderViewTypeNoLogo;
    self.headerView.title = @"收藏";
    [self setupBarItem];
    [self.headerView updateHeaderView];
    [self.view addSubview:self.headerView];
    
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

- (void)setupTableView
{
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.sc_width, self.view.sc_height - kNavigationBarHeight) style:UITableViewStyleGrouped];
    
    [tableview registerClass:[SLMainSearchBookCell class] forCellReuseIdentifier:kLoanBookCellID];
    
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor whiteColor];
    tableview.sectionIndexColor = [UIColor grayColor];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.estimatedRowHeight = 162;
    //    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreBooks)];
    //    footer.hidden = YES;
    //    tableview.mj_footer = footer;
    BlockWeakSelf(weakSelf, self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf queryData];
    }];
    tableview.mj_header = header;
    self.bookTableView = tableview;
    [self.view addSubview:self.bookTableView];
}

- (void)viewDidLayoutSubviews
{
    self.headerView.sc_top = kStatusHeight;
    self.headerView.sc_left = 0;
    self.bookTableView.sc_top = self.headerView.sc_bottom;
}

- (void)queryData
{
    BlockWeakSelf(weakSelf, self);
    [[SLCollectBookDataController sharedObject] queryCollectedBooksWithIncrement:NO completed:^(NSMutableArray *data, NSError *error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.bookTableView reloadData];
                if (data.count == 0) {
                    [self.bookTableView sl_showEmptyViewWithType:SLEmptyViewTypeNoCollectBook];
                } else {
                    [self.bookTableView sl_removeEmptyView];
                }
            });
        }
        [weakSelf.bookTableView.mj_header endRefreshing];
        
    }];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SLCollectBookDataController sharedObject].collectedBooks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLMainSearchBookCell *cell = (SLMainSearchBookCell *)[tableView dequeueReusableCellWithIdentifier:kLoanBookCellID];
    if (cell == nil) {
        cell = [[SLMainSearchBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLoanBookCellID];
    }
    cell.delegate = self;
    SLCollectedBook *collectBook = [[SLCollectBookDataController sharedObject].collectedBooks objectAtIndex:indexPath.row];
    SLCollectBookCellViewModel *viewModel = [SLCollectBookCellViewModel viewModelWithCollectBook:collectBook];
    [cell bindBookCellViewModel:viewModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLBookDetailViewController *detailVC = [[SLBookDetailViewController alloc] init];
    SLCollectedBook *collectBook = [SLCollectBookDataController sharedObject].collectedBooks[indexPath.row];
    SLBookListItem *book = [SLBookListItem bookListItemWithCollectBook:collectBook];

    detailVC.bookInfo = book;
    [self.navigationController setDefaultNavType];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
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

#pragma mark - SLMainSearchBookCellDelegate
- (void)didSelectMarkBtnBookCell:(SLMainSearchBookCell *)cell isCollected:(BOOL)isCollected
{
    BlockWeakSelf(weakSelf, self);
    NSIndexPath *indexPath = [self.bookTableView indexPathForCell:cell];
    SLCollectedBook *collectBook = [[SLCollectBookDataController sharedObject].collectedBooks objectAtIndex:indexPath.row];
    [[SLBookDetailDataController sharedObject] cancelCollectBook:collectBook.ctrlNo complete:^(id data, NSError *error) {
        if ([data boolValue]) {
            [[SLCollectBookDataController sharedObject].collectedBooks removeObjectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SLProgressHUD showHUDWithText:@"取消收藏成功" inView:self.view delayTime:2];
                [weakSelf.bookTableView reloadData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SLProgressHUD showHUDWithText:@"取消收藏失败，请重试" inView:self.view delayTime:2];
            });
        }
    }];
}
@end
