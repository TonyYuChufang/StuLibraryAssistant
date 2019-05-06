//
//  SLDiscoveryViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/5.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLDiscoveryViewController.h"
#import "SLBookDetailViewController.h"
#import "SLLoginHeaderView.h"
#import "SLDiscoveryDataController.h"
#import "SLSearchBookCellViewModel.h"
#import "SLBook.h"
#import "CardPage.h"
@interface SLDiscoveryViewController ()<SLCardPageDelegate>

@property (nonatomic, strong) SLLoginHeaderView *headerView;
@property (nonatomic, strong) CardPage *bookCardView;
@end

@implementation SLDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
    [self queryData];
}

- (void)setupSubview
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headerView = [[SLLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.headerView.viewType = SLHeaderViewTypeNoLogo;
    self.headerView.title = @"发现广场";
    [self setupBarItem];
    [self.headerView updateHeaderView];
    [self.view addSubview:self.headerView];
    
    self.bookCardView = [[CardPage alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 400)];
    self.bookCardView.delegate = self;
    [self.view addSubview:self.bookCardView];
}

- (void)viewDidLayoutSubviews
{
    self.headerView.sc_top = kStatusHeight;
    self.headerView.sc_left = 0;
    self.bookCardView.sc_top = self.headerView.sc_bottom;
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

- (void)queryData
{
    BlockWeakSelf(weakSelf, self);
    [[SLDiscoveryDataController sharedObject] queryNewBooks:^(NSMutableArray *data, NSError *error) {
        if (error == nil) {
            NSArray *array = [SLSearchBookCellViewModel viewModelsWithBooks:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.bookCardView bindViewModels:array];
            });
        }
    }];
}

#pragma mark - SLCardPageDelegate
- (void)cardPage:(UIView *)cardPage didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLBookDetailViewController *detailVC = [[SLBookDetailViewController alloc] init];
    SLBookListItem *book = [[SLDiscoveryDataController sharedObject].books objectAtIndex:indexPath.row];
    
    detailVC.bookInfo = book;
    [self.navigationController setDefaultNavType];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
