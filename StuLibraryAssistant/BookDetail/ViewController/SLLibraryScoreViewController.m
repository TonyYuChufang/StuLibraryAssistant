//
//  SLLibraryScoreViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLibraryScoreViewController.h"
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

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SLScoreMyCell *cell = [tableView dequeueReusableCellWithIdentifier:[SLScoreMyCell reuseId]];
        if (cell) {
            cell = [[SLScoreMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SLScoreMyCell reuseId]];
        }
        cell.starPointView.delegate = self;
        return cell;
    }
    SLScoreOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:[SLScoreOtherCell reuseId]];
    if (cell == nil) {
        cell = [[SLScoreOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SLScoreOtherCell reuseId]];
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

- (void)slstarPointViewDidSelectWithScore:(CGFloat)score
{
    [SLProgressHUD showHUDWithText:@"评分成功" inView:self.parentViewController.view delayTime:2];
}
@end
