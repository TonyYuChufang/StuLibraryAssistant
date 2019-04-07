//
//  SLMainSearchViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/19.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLMainSearchViewController.h"
#import "SLMainSearchDataController.h"
#import "SLBook.h"
#import "SLSearchBookCellViewModel.h"
#import "SLMainSearchBookCell.h"
#import "SLSearchBar.h"
#import "SLStyleManager+Theme.h"
#import <MJRefresh/MJRefresh.h>

static NSString * const kSLMainSearchBookCellID = @"kSLMainSearchBookCellID";
static CGFloat kSearchBarHeight = 24;
static CGFloat kNavigationBarHeight = 64;
@interface SLMainSearchViewController () <UITableViewDelegate,UITableViewDataSource,SLSearchBarDelegate>

@property (nonatomic, strong) UITableView *bookTableView;
@property (nonatomic, strong) SLSearchBar *searchBar;

@end

@implementation SLMainSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
    [self setupLayout];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReciveBookList:) name:@"QueryBookListComplete" object:nil];
}

- (void)setupTableView
{
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.sc_width, self.view.sc_height - kNavigationBarHeight - kSearchBarHeight)];
    
    [tableview registerClass:[SLMainSearchBookCell class] forCellReuseIdentifier:kSLMainSearchBookCellID];
    
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor whiteColor];
    tableview.sectionIndexColor = [UIColor grayColor];
    tableview.rowHeight = 162;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bookTableView = tableview;
    [self.view addSubview:self.bookTableView];
}

- (void)setupSubview
{
    [self setupTableView];
    self.searchBar = [[SLSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.sc_width - 60, 24)];
    self.searchBar.placeholder = @"搜索你喜欢的书籍";
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

- (void)setupLayout
{
    self.searchBar.sc_top = kNavigationBarHeight + 10;
    self.searchBar.sc_centerX = self.view.sc_centerX;
    self.bookTableView.sc_top = self.searchBar.sc_bottom;
}
#pragma mark - Notification
- (void)onReciveBookList:(NSNotification *)notification
{
    [_bookTableView reloadData];
}

#pragma mark - Tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLMainSearchBookCell *cell = (SLMainSearchBookCell *)[tableView dequeueReusableCellWithIdentifier:kSLMainSearchBookCellID];
    if (cell == nil) {
        cell = [[SLMainSearchBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSLMainSearchBookCellID];
    }
    SLBookListItem *book = [SLMainSearchDataController sharedObject].bookItemList[indexPath.row];
    SLSearchBookCellViewModel *viewModel = [SLSearchBookCellViewModel bookCellViewModelWithBook:book];
    [cell bindBookCellViewModel:viewModel];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [SLMainSearchDataController sharedObject].bookItemList.count;
}

#pragma mark - SLSearchBarDelegate
- (void)slSearchBarDidSelectReturnWithText:(NSString *)text
{
    NSLog(@"Did Select Return");
    [[SLMainSearchDataController sharedObject] queryBookWithText:text page:0 rows:20 shouldIncrement:NO];
    self.searchBar.text = nil;
    if ([SLMainSearchDataController sharedObject].bookItemList.count) {
        [self.bookTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    [self.view endEditing:YES];
}
@end
