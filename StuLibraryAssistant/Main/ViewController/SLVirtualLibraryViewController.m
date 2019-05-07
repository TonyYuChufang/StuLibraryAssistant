//
//  SLVirtualLibraryViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/7.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLVirtualLibraryViewController.h"
#import "SLLoginHeaderView.h"
#import <WebKit/WebKit.h>
@interface SLVirtualLibraryViewController ()
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) SLLoginHeaderView *headerView;
@end

@implementation SLVirtualLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubview];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.stu.flyread.com.cn/opac.php?from=singlemessage&isappinstalled=0#virtualLibPage"]];
    [self.webview loadRequest:request];
}

- (void)viewDidLayoutSubviews
{
    self.headerView.sc_top = kStatusHeight;
    self.headerView.sc_left = 0;
    
    self.webview.sc_top = kStatusHeight;
    self.webview.sc_left = 0;
}

- (void)setupSubview
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight)];
    [self.view addSubview:self.webview];
    
    self.headerView = [[SLLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    self.headerView.viewType = SLHeaderViewTypeNoLogo;
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
@end
