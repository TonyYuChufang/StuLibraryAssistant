//
//  SLBookDetailViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLBookDetailViewController.h"
#import "SLLibraryCollectedViewController.h"
#import "SLLibraryScoreViewController.h"
#import "SLLoginHeaderView.h"
#import "SLBookDetailInfoView.h"
#import "SLInfoSegmentControl.h"
#import "SLMenuItemView.h"
#import "SLStyleManager+Theme.h"

typedef NS_ENUM(NSUInteger, SLDetailSegmentControlSelectIndex) {
    SLDetailSegmentControlSelectIndexCollected = 0,
    SLDetailSegmentControlSelectIndexDetailInfo,
    SLDetailSegmentControlSelectIndexScore
};
@interface SLBookDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) SLLoginHeaderView *headerView;
@property (nonatomic, strong) SLBookDetailInfoView *detailInfoView;
@property (nonatomic, strong) SLInfoSegmentControl *segmentControl;
@property (nonatomic, strong) UIScrollView *pageScrollView;
@property (nonatomic, strong) NSMutableArray *segmentControlItemInfos;

@property (nonatomic, strong) SLLibraryCollectedViewController *libraryCollectedViewController;
@property (nonatomic, strong) SLLibraryScoreViewController *libraryScoreVC;
@end

@implementation SLBookDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setDefaultNavType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentControlItemInfos = [[NSMutableArray alloc] initWithCapacity:2];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubview];
    [self addLibraryCollectVC];
    [self addLibraryScoreVC];
}

- (void)setupSubview
{
    self.headerView = [[SLLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.headerView.viewType = SLHeaderViewTypeNoLogo;
    self.headerView.title = @"书籍详情";
    [self setupHeaderBarItem];
    [self.headerView updateHeaderView];
    [self.view addSubview:self.headerView];
    
    self.detailInfoView = [[SLBookDetailInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    self.detailInfoView.score = 3.8;
    [self.view addSubview:self.detailInfoView];
    
    self.segmentControl = [[SLInfoSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    self.segmentControl.viewType = SLInfoSegmentControlTypeText;
    [self setupSegmentControlItem];
    [self.view addSubview:self.segmentControl];
    
    self.pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - 160 - 46)];
    self.pageScrollView.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeight - kNavigationBarHeight - 160 - 46);
    self.pageScrollView.backgroundColor = [SLStyleManager LightGrayColor];
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    self.pageScrollView.bounces = NO;
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.delegate = self;
    
    [self.view addSubview:self.pageScrollView];
}

- (void)viewDidLayoutSubviews
{
    self.headerView.sc_top = kStatusHeight;
    self.headerView.sc_left = 0;
    
    self.detailInfoView.sc_top = self.headerView.sc_bottom;
    self.detailInfoView.sc_left = 0;
    
    self.segmentControl.sc_left = 0;
    self.segmentControl.sc_top = self.detailInfoView.sc_bottom;
    
    self.pageScrollView.sc_top = self.segmentControl.sc_bottom;
    self.pageScrollView.sc_left = 0;
}

- (void)setupHeaderBarItem
{
    SLHeaderBarItemInfo *backBarItem = [[SLHeaderBarItemInfo alloc] init];
    backBarItem.itemImageName = @"icon_navigationBar_back";
    backBarItem.barItemClickedHandler = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.headerView.leftBarItems addObject:backBarItem];
}

- (void)setupSegmentControlItem
{
    BlockWeakSelf(weakSelf, self);
    SLMenuItemInfo *collectedItem = [[SLMenuItemInfo alloc] init];
    collectedItem.isSelected = YES;
    collectedItem.title = @"藏书情况(1/1)";
    collectedItem.menuItemSelectedHandler = ^{
        [weakSelf segmentControlDidSelect:SLDetailSegmentControlSelectIndexCollected];
    };
    [self.segmentControlItemInfos addObject:collectedItem];
    
    SLMenuItemInfo *detailItem = [[SLMenuItemInfo alloc] init];
    detailItem.isSelected = NO;
    detailItem.title = @"详细信息";
    detailItem.menuItemSelectedHandler = ^{
        [weakSelf segmentControlDidSelect:SLDetailSegmentControlSelectIndexDetailInfo];
    };
    [self.segmentControlItemInfos addObject:detailItem];
    
    SLMenuItemInfo *scoreItem = [[SLMenuItemInfo alloc] init];
    scoreItem.isSelected = NO;
    scoreItem.title = @"评分(2)";
    scoreItem.menuItemSelectedHandler = ^{
        [weakSelf segmentControlDidSelect:SLDetailSegmentControlSelectIndexScore];
    };
    [self.segmentControlItemInfos addObject:scoreItem];
    self.segmentControl.controlItems = self.segmentControlItemInfos;
    [self.segmentControl updateSegmentControl];
}

- (void)segmentSelectedToIndex:(NSUInteger)index
{
    NSUInteger i = 0;
    for (SLMenuItemInfo *info in self.segmentControlItemInfos) {
        if (index == i) {
            info.isSelected = YES;
        } else {
            info.isSelected = NO;
        }
        i++;
    }
    [self.segmentControl updateSegmentControl];
}

- (void)addLibraryCollectVC
{
    self.libraryCollectedViewController = [[SLLibraryCollectedViewController alloc] init];
    self.libraryCollectedViewController.view.frame = CGRectMake(0, 0, kScreenWidth, self.pageScrollView.sc_height);
    [self.libraryCollectedViewController willMoveToParentViewController:self];
    [self addChildViewController:self.libraryCollectedViewController];
    [self.libraryCollectedViewController didMoveToParentViewController:self];
    [self.pageScrollView addSubview:self.libraryCollectedViewController.view];
}

- (void)addLibraryScoreVC
{
    self.libraryScoreVC = [[SLLibraryScoreViewController alloc] init];
    self.libraryScoreVC.view.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth, self.pageScrollView.sc_height);
    [self.libraryScoreVC willMoveToParentViewController:self];
    [self addChildViewController:self.libraryScoreVC];
    [self.libraryScoreVC didMoveToParentViewController:self];
    [self.pageScrollView addSubview:self.libraryScoreVC.view];
}
#pragma mark - Action
- (void)segmentControlDidSelect:(SLDetailSegmentControlSelectIndex)selectedIndex
{
    switch (selectedIndex) {
        case SLDetailSegmentControlSelectIndexCollected:
            [self scrollToPageWithIndex:0];
            NSLog(@"藏书情况");
            break;
        case SLDetailSegmentControlSelectIndexDetailInfo:
            [self scrollToPageWithIndex:1];
            NSLog(@"详细信息");
            break;
        case SLDetailSegmentControlSelectIndexScore:
            [self scrollToPageWithIndex:2];
            NSLog(@"评分");
            break;
        default:
            break;
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollToPageWithIndex:(NSUInteger)index
{
    CGRect bounds = UIEdgeInsetsInsetRect(self.pageScrollView.bounds, self.pageScrollView.contentInset);
    bounds.origin.x = CGRectGetWidth(bounds) * index;
    bounds.origin.y = 0;

    [self.pageScrollView scrollRectToVisible:bounds animated:NO];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    CGFloat position = self.pageScrollView.contentOffset.x;
    [self segmentSelectedToIndex:round(position / width)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    CGFloat position = self.pageScrollView.contentOffset.x;
    [self segmentSelectedToIndex:round(position / width)];
}
@end
