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
#import "SLLibraryDetailInfoViewController.h"
#import "SLBookDetailDataController.h"
#import "SLLoginHeaderView.h"
#import "SLBookDetailInfoView.h"
#import "SLInfoSegmentControl.h"
#import "SLMenuItemView.h"
#import "SLDetailToolView.h"
#import "SLStyleManager+Theme.h"
#import "SLBookDetailViewModel.h"
#import "SLBookDetailDataController.h"

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
@property (nonatomic, strong) SLDetailToolView *toolView;
@property (nonatomic, strong) NSMutableArray *toolItemInfos;

@property (nonatomic, strong) SLLibraryCollectedViewController *libraryCollectedViewController;
@property (nonatomic, strong) SLLibraryScoreViewController *libraryScoreVC;
@property (nonatomic, strong) SLLibraryDetailInfoViewController *detailInfoVC;
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
    self.toolItemInfos = [[NSMutableArray alloc] initWithCapacity:2];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubview];
    [self updateDetailView];
    [self queryData];
    [self addLibraryCollectVC];
    [self addLibraryScoreVC];
    [self addDetailInfoVC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveScoreInfo:) name:kGiveBookScoreCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveDetailInfo:) name:kQueryBookDetailCompleteNotification object:nil];
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
    
    self.pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - 160 - 46 - 50)];
    self.pageScrollView.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeight - kNavigationBarHeight - 160 - 46 - 50);
    self.pageScrollView.backgroundColor = [SLStyleManager LightGrayColor];
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    self.pageScrollView.bounces = NO;
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.delegate = self;
    [self.view addSubview:self.pageScrollView];
    
    self.toolView = [[SLDetailToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [self setupToolViewItem];
    [self.view addSubview:self.toolView];
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
    
    self.toolView.sc_left = 0;
    self.toolView.sc_bottom = kScreenHeight;
}

- (void)dealloc
{
    self.libraryCollectedViewController = nil;
    self.libraryScoreVC = nil;
    self.detailInfoVC = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupHeaderBarItem
{
    BlockWeakSelf(weakSelf, self);
    SLHeaderBarItemInfo *backBarItem = [[SLHeaderBarItemInfo alloc] init];
    backBarItem.itemImageName = @"icon_navigationBar_back";
    backBarItem.barItemClickedHandler = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
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

- (void)setupToolViewItem
{
    BlockWeakSelf(weakSelf, self);
    
    SLMenuItemInfo *collectedItem = [[SLMenuItemInfo alloc] init];
    collectedItem.isSelected = YES;
    collectedItem.title = @"收藏";
    collectedItem.menuItemSelectedHandler = ^{
        if (weakSelf.bookInfo.COLLECTED) {
            [[SLBookDetailDataController sharedObject] cancelCollectBook:weakSelf.bookInfo.CTRLNO complete:^(id data, NSError *error) {
                if (error == nil) {
                    weakSelf.bookInfo.COLLECTED = @"false";
                    SLMenuItemInfo *toolCollectItem = [weakSelf.toolItemInfos objectAtIndex:0];
                    toolCollectItem.title = @"收藏";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.toolView updateToolView];
                        [SLProgressHUD showHUDWithText:@"取消收藏成功" inView:weakSelf.view delayTime:1.5];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SLProgressHUD showHUDWithText:@"取消收藏失败，请重试" inView:weakSelf.view delayTime:1.5];
                    });
                }
            }];
        } else {
            [[SLBookDetailDataController sharedObject] collectBook:weakSelf.bookInfo.CTRLNO complete:^(id data, NSError *error) {
                if (error == nil) {
                    weakSelf.bookInfo.COLLECTED = @"true";
                    SLMenuItemInfo *toolCollectItem = [weakSelf.toolItemInfos objectAtIndex:0];
                    toolCollectItem.title = @"取消收藏";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.toolView updateToolView];
                        [SLProgressHUD showHUDWithText:@"收藏成功" inView:weakSelf.view delayTime:1.5];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SLProgressHUD showHUDWithText:@"收藏失败，请重试" inView:weakSelf.view delayTime:1.5];
                    });
                }
            }];
        }
    };
    [self.toolItemInfos addObject:collectedItem];
    
    SLMenuItemInfo *bookingItem = [[SLMenuItemInfo alloc] init];
    bookingItem.isSelected = YES;
    bookingItem.title = @"预约";
    bookingItem.menuItemSelectedHandler = ^{
        
    };
    [self.toolItemInfos addObject:bookingItem];
    self.toolView.controlItems = self.toolItemInfos;
    [self.toolView updateToolView];
    
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

- (void)updateDetailView
{
    SLBookDetailViewModel *detailVM = [SLBookDetailViewModel bookDetailViewModelWithBook:self.bookInfo];
    [self.detailInfoView updateDetailViewWithViewModel:detailVM];
    SLMenuItemInfo *collectItem = [self.segmentControlItemInfos objectAtIndex:0];
    SLMenuItemInfo *scoreItem = [self.segmentControlItemInfos objectAtIndex:2];
    collectItem.title = detailVM.bookCollectedTitle;
    scoreItem.title = detailVM.bookScoreTitle;
    [self.segmentControl updateSegmentControl];
}

- (void)queryData
{
    [KVNProgress showWithStatus:@"正在加载..."];
    [[SLBookDetailDataController sharedObject] queryBookDetailWithCtrlNo:self.bookInfo.CTRLNO complete:^(id data, NSError *error) {
        [KVNProgress dismiss];
    }];
}
- (void)addLibraryCollectVC
{
    self.libraryCollectedViewController = [[SLLibraryCollectedViewController alloc] init];
    self.libraryCollectedViewController.ctrlNo = self.bookInfo.CTRLNO;
    self.libraryCollectedViewController.view.frame = CGRectMake(0, 0, kScreenWidth, self.pageScrollView.sc_height);
    [self.libraryCollectedViewController willMoveToParentViewController:self];
    [self addChildViewController:self.libraryCollectedViewController];
    [self.libraryCollectedViewController didMoveToParentViewController:self];
    [self.pageScrollView addSubview:self.libraryCollectedViewController.view];
}

- (void)addLibraryScoreVC
{
    self.libraryScoreVC = [[SLLibraryScoreViewController alloc] init];
    self.libraryScoreVC.ctrlNo = self.bookInfo.CTRLNO;
    self.libraryScoreVC.view.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth, self.pageScrollView.sc_height);
    [self.libraryScoreVC willMoveToParentViewController:self];
    [self addChildViewController:self.libraryScoreVC];
    [self.libraryScoreVC didMoveToParentViewController:self];
    [self.pageScrollView addSubview:self.libraryScoreVC.view];
}

- (void)addDetailInfoVC
{
    self.detailInfoVC = [[SLLibraryDetailInfoViewController alloc] init];
    self.detailInfoVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.pageScrollView.sc_height);
    [self.detailInfoVC willMoveToParentViewController:self];
    [self addChildViewController:self.detailInfoVC];
    [self.detailInfoVC didMoveToParentViewController:self];
    [self.pageScrollView addSubview:self.detailInfoVC.view];
}

#pragma mark - Notification
- (void)onReceiveScoreInfo:(NSNotification *)notification
{
    SLMenuItemInfo *scoreItem = [self.segmentControlItemInfos objectAtIndex:2];
    scoreItem.title = [NSString stringWithFormat:@"评分(%@)",notification.userInfo[@"totalCount"]];
    self.detailInfoView.score = [notification.userInfo[@"averageScore"] floatValue];
    [self.segmentControl updateSegmentControl];
}

- (void)onReceiveDetailInfo:(NSNotification *)notification
{
    SLBookDetailViewModel *detailVM = [SLBookDetailViewModel bookDetailViewModelWithDetailModel:[SLBookDetailDataController sharedObject].detailInfo];
    [self.detailInfoView updateDetailViewWithViewModel:detailVM];
    SLMenuItemInfo *collectItem = [self.segmentControlItemInfos objectAtIndex:0];
    SLMenuItemInfo *scoreItem = [self.segmentControlItemInfos objectAtIndex:2];
    SLMenuItemInfo *toolCollectItem = [self.toolItemInfos objectAtIndex:0];
    collectItem.title = detailVM.bookCollectedTitle;
    scoreItem.title = detailVM.bookScoreTitle;
    toolCollectItem.title = detailVM.isCollected ? @"取消收藏" : @"收藏";
    [self.segmentControl updateSegmentControl];
    [self.toolView updateToolView];
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
