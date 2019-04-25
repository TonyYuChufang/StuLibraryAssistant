//
//  SLLibraryCollectedViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLibraryCollectedViewController.h"
#import "SLBookDetailDataController.h"
#import "SLDetailCells.h"
#import "SLBookDetailViewModel.h"
#import <MJRefresh/MJRefresh.h>

@interface SLLibraryCollectedViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tablview;

@end

@implementation SLLibraryCollectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
    [self.tablview.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveBookCollectedInfo:) name:kQueryBookCollectedInfoCompleteNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SLBookDetailDataController sharedObject].bookLocations removeAllObjects];
}

- (void)setupSubview
{
    self.tablview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.sc_height) style:UITableViewStylePlain];
    [self.tablview registerClass:[SLCollectInfoCell class] forCellReuseIdentifier:[SLCollectInfoCell reuseId]];
    self.tablview.delegate = self;
    self.tablview.rowHeight = 105;
    self.tablview.dataSource = self;
    self.tablview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tablview.backgroundColor = [UIColor clearColor];
    BlockWeakSelf(weakSelf, self);
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [[SLBookDetailDataController sharedObject] queryBookCollectInfoWithCtrl:weakSelf.ctrlNo Complete:nil];
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

- (void)onReceiveBookCollectedInfo:(NSNotification *)notification
{
    [self.tablview reloadData];
    [self.tablview.mj_header endRefreshing];
}
#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SLBookDetailDataController sharedObject].bookLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLCollectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[SLCollectInfoCell reuseId]];
    SLBookLoactionViewModel *locationViewModel = [SLBookLoactionViewModel bookLocationViewModelWithLocation:[SLBookDetailDataController sharedObject].bookLocations[indexPath.row]];
    if (cell == nil) {
        cell = [[SLCollectInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SLCollectInfoCell reuseId]];
    }
    [cell bindBookLocationViewModel:locationViewModel];
    return cell;
}

@end
