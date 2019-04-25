//
//  SLLibraryDetailInfoViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLibraryDetailInfoViewController.h"
#import "SLBookDetailDataController.h"
#import "SLDetailCells.h"
#import "SLBookDetailModel.h"
#import <MJRefresh/MJRefresh.h>
@interface SLLibraryDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tablview;

@end

@implementation SLLibraryDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveBookDetailInfo:) name:kQueryBookDetailCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveBookContentInfo:) name:kQueryBookContentInfoCompleteNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SLBookDetailDataController sharedObject].bookContents removeAllObjects];
}

- (void)setupSubview
{
    self.tablview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.sc_height) style:UITableViewStylePlain];
    [self.tablview registerClass:[SLDetailInfoCell class] forCellReuseIdentifier:[SLDetailInfoCell reuseId]];
    self.tablview.delegate = self;
    self.tablview.dataSource = self;
    self.tablview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tablview.backgroundColor = [UIColor clearColor];
    BlockWeakSelf(weakSelf, self);
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [[SLBookDetailDataController sharedObject] queryBookContentInfoComplete:nil];
    }];
    [header setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeText = ^NSString *(NSDate *lastUpdatedTime) {
        return nil;
    };
    self.tablview.mj_header = header;
    [self.view addSubview:self.tablview];
}

- (void)viewDidLayoutSubviews
{
    self.tablview.frame = CGRectMake(0, 0, kScreenWidth, self.view.sc_height);
}

#pragma mark - Notification
- (void)onReceiveBookDetailInfo:(NSNotification *)notification
{
    [self.tablview.mj_header beginRefreshing];
}

- (void)onReceiveBookContentInfo:(NSNotification *)notification
{
    [self.tablview reloadData];
    [self.tablview.mj_header endRefreshing];
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SLBookDetailDataController sharedObject].bookContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[SLDetailInfoCell reuseId]];
    if (cell == nil) {
        cell = [[SLDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SLDetailInfoCell reuseId]];
    }
    SLBookContentInfoModel *contentInfo = [[SLBookDetailDataController sharedObject].bookContents objectAtIndex:indexPath.row];
    [cell updateDetailInfoWith:contentInfo.title content:contentInfo.content];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLBookContentInfoModel *contentInfo = [[SLBookDetailDataController sharedObject].bookContents objectAtIndex:indexPath.row];
    return [SLDetailInfoCell heightForDetailCellWithContent:contentInfo.content];
}
@end
