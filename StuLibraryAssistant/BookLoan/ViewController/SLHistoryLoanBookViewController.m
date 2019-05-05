//
//  SLHistoryLoanBookViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/4.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLHistoryLoanBookViewController.h"
#import "SLBookDetailViewController.h"
#import "SLLoginHeaderView.h"
#import "SLMainSearchBookCell.h"
#import "SLLoanBookCellViewModel.h"
#import "SLLoanBook.h"
#import "SLLoanBookDataController.h"
#import <MJRefresh/MJRefresh.h>
#import "UIScrollView+EmptyView.h"

static NSString * kLoanBookCellID = @"kLoanBookCellID";

@interface SLHistoryLoanBookViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SLLoginHeaderView *headerView;
@property (nonatomic, strong) UITableView *bookTableView;

@end

@implementation SLHistoryLoanBookViewController

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
    self.headerView.title = @"历史借阅";
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
    [[SLLoanBookDataController sharedObject] queryHistoryLoanBooksWithIncrement:NO completed:^(NSMutableArray *data, NSError *error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.bookTableView reloadData];
                if (data.count == 0) {
                    [self.bookTableView sl_showEmptyViewWithType:SLEmptyViewTypeNoLoanBook];
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
    return [SLLoanBookDataController sharedObject].historyLoanBooks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLMainSearchBookCell *cell = (SLMainSearchBookCell *)[tableView dequeueReusableCellWithIdentifier:kLoanBookCellID];
    if (cell == nil) {
        cell = [[SLMainSearchBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLoanBookCellID];
    }
    
    SLLoanBook *loanBook = [[SLLoanBookDataController sharedObject].historyLoanBooks objectAtIndex:indexPath.row];
    SLLoanBookCellViewModel *viewModel = [SLLoanBookCellViewModel bookCellViewModelWithBook:loanBook];
    [cell bindBookCellViewModel:viewModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLBookDetailViewController *detailVC = [[SLBookDetailViewController alloc] init];
    SLLoanBook *loanBook = [SLLoanBookDataController sharedObject].historyLoanBooks[indexPath.row];
    SLBookListItem *book = [SLBookListItem bookListItemWithLoanBook:loanBook];
    detailVC.bookInfo = book;
    [self.navigationController setDefaultNavType];
    [self.navigationController pushViewController:detailVC animated:YES];
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
@end
