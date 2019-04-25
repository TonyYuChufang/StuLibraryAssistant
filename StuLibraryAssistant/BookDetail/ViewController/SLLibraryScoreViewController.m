//
//  SLLibraryScoreViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLibraryScoreViewController.h"
#import "SLBookDetailDataController.h"
#import "SLBookDetailViewModel.h"
#import "SLStarPointView.h"
#import "SLDetailCells.h"
#import "SLProgressHUD.h"

@interface SLLibraryScoreViewController ()<UITableViewDelegate,UITableViewDataSource,SLStarPointViewDelegate>

@property (nonatomic, strong) UITableView *tablview;

@end

@implementation SLLibraryScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
    [self queryData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveScoreInfos:) name:kQueryBookScoreInfoCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveMyScoreInfos:) name:kQueryBookMyScoreInfoCompleteNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [SLBookDetailDataController sharedObject].myScore = nil;
    [[SLBookDetailDataController sharedObject].bookScores removeAllObjects];
}

- (void)setupSubview
{
    self.tablview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.sc_height) style:UITableViewStylePlain];
    [self.tablview registerClass:[SLScoreMyCell class] forCellReuseIdentifier:[SLScoreMyCell reuseId]];
    [self.tablview registerClass:[SLScoreOtherCell class] forCellReuseIdentifier:[SLCollectInfoCell reuseId]];
    self.tablview.delegate = self;
    self.tablview.dataSource = self;
    self.tablview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tablview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tablview];
}

- (void)viewDidLayoutSubviews
{
    self.tablview.frame = CGRectMake(0, 0, kScreenWidth, self.view.sc_height);
}

- (void)queryData
{
    [[SLBookDetailDataController sharedObject] queryBookScoreInfoCtrlNo:self.ctrlNo complete:nil];
    [[SLBookDetailDataController sharedObject] queryMyScoreInfo:self.ctrlNo complete:nil];
}

#pragma mark - Notification
- (void)onReceiveScoreInfos:(NSNotification *)notification
{
    [self.tablview reloadData];
}

- (void)onReceiveMyScoreInfos:(NSNotification *)notification
{
    [self.tablview reloadData];
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SLBookDetailDataController sharedObject].bookScores.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SLScoreMyCell *cell = [tableView dequeueReusableCellWithIdentifier:[SLScoreMyCell reuseId]];
        if (cell) {
            cell = [[SLScoreMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SLScoreMyCell reuseId]];
        }
        SLBookScoreViewModel *viewModel = [SLBookScoreViewModel bookScoreViewModelWithScore:[SLBookDetailDataController sharedObject].myScore];
        [cell bindBookScoreViewModel:viewModel];
        cell.starPointView.delegate = self;
        return cell;
    }
    SLScoreOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:[SLScoreOtherCell reuseId]];
    if (cell == nil) {
        cell = [[SLScoreOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SLScoreOtherCell reuseId]];
        SLBookScoreViewModel *viewModel = [SLBookScoreViewModel bookScoreViewModelWithScore:[SLBookDetailDataController sharedObject].bookScores[indexPath.row - 1]];
        [cell bindBookScoreViewModel:viewModel];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }
    
    return 60;
}

- (void)slstarPointView:(SLStarPointView *)starPointView DidSelectWithScore:(CGFloat)score
{
    [[SLBookDetailDataController sharedObject] giveTheScore:score Book:self.ctrlNo complete:^(id data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SLProgressHUD showHUDWithText:@"评分成功" inView:self.parentViewController.view delayTime:2];
        });
    }];
    [starPointView updateStarPoint:score];
}
@end
