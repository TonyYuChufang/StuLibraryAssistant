//
//  SLLibraryCollectedViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLibraryCollectedViewController.h"
#import "SLDetailCells.h"

@interface SLLibraryCollectedViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tablview;

@end

@implementation SLLibraryCollectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
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
    [self.view addSubview:self.tablview];
}

- (void)viewDidLayoutSubviews
{
    self.tablview.frame = CGRectMake(0, 0, kScreenWidth, self.view.sc_height);
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLCollectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[SLCollectInfoCell reuseId]];
    if (cell == nil) {
        cell = [[SLCollectInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SLCollectInfoCell reuseId]];
    }
    return cell;
}
@end
