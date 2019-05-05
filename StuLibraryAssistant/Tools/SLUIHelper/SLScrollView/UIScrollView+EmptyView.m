//
//  UIScrollView+EmptyView.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/5/3.
//  Copyright © 2019 yu. All rights reserved.
//

#import "UIScrollView+EmptyView.h"
#import "SLStyleManager+Theme.h"
#import <objc/runtime.h>
static NSString *kEmptyViewKey = @"kEmptyViewKey";
static NSString *kEmptyViewScrollEnableKey = @"kEmptyViewScrollEnableKey";

@interface UIScrollView ()

@property (nonatomic, assign) BOOL sl_emptyViewScrollEnable;
@end

@implementation UIScrollView (EmptyView)
-(UIView *)sl_emptyView
{
    return objc_getAssociatedObject(self, &kEmptyViewKey);
}

- (void)setSl_emptyView:(UIView *)sl_emptyView
{
    objc_setAssociatedObject(self, &kEmptyViewKey, sl_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sl_emptyViewScrollEnable
{
    return [objc_getAssociatedObject(self, &kEmptyViewScrollEnableKey) boolValue];
}

- (void)setSl_emptyViewScrollEnable:(BOOL)sl_emptyViewScrollEnable
{
    objc_setAssociatedObject(self, &kEmptyViewScrollEnableKey, @(sl_emptyViewScrollEnable), OBJC_ASSOCIATION_ASSIGN);
}

- (void)sl_showEmptyViewWithType:(SLEmptyViewType)type
{
    self.sl_emptyViewScrollEnable = self.scrollEnabled;
    self.scrollEnabled = NO;
    
    if (self.sl_emptyView) {
        [self.sl_emptyView removeFromSuperview];
        self.sl_emptyView = nil;
    }
    
    self.sl_emptyView = [[UIView alloc] init];
    self.sl_emptyView.sc_size = CGSizeMake(100, 100);
    self.sl_emptyView.sc_centerX = self.sc_width / 2.0;
    self.sl_emptyView.sc_centerY = self.sc_height / 2.0 - 50;
    [self addSubview:self.sl_emptyView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.sc_top = 0;
    imageView.sc_size = CGSizeMake(80, 80);
    imageView.sc_centerX = self.sl_emptyView.sc_width / 2.0;
    [self.sl_emptyView addSubview:imageView];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textColor = [SLStyleManager LightGrayColor];
    descLabel.sc_top = imageView.sc_bottom + 10;
    [self.sl_emptyView addSubview:descLabel];
    
    switch (type) {
        case SLEmptyViewTypeNoScore:
            descLabel.text = @"这本书还没有评分";
            imageView.image = [UIImage imageNamed:@"icon_emptyList_score"];
            break;
        
        case SLEmptyViewTypeNetWorkError:
            descLabel.text = @"网络异常";
            imageView.image = [UIImage imageNamed:@"icon_emptyList_network"];
            break;
            
        case SLEmptyViewTypeInitialBookList:
            descLabel.text = @"快来检索书籍吧~";
            imageView.image = [UIImage imageNamed:@"icon_emptyList_book"];
            break;
            
        case SLEmptyViewTypeEmptyBookList:
            descLabel.text = @"没有相关书籍~";
            imageView.image = [UIImage imageNamed:@"icon_emptyList_book"];
            break;
        case SLEmptyViewTypeNoLoanBook:
            descLabel.text = @"当前没有借阅书籍";
            imageView.image = [UIImage imageNamed:@"icon_emptyList_book"];
            self.scrollEnabled = YES;
            break;
        case SLEmptyViewTypeNoCollectBook:
            descLabel.text = @"当前没有收藏书籍";
            imageView.image = [UIImage imageNamed:@"icon_emptyList_book"];
            self.scrollEnabled = YES;
            break;
        default:
            break;
    }
    [descLabel sizeToFit];
    descLabel.sc_centerX = self.sl_emptyView.sc_width / 2.0;
}

- (void)sl_removeEmptyView
{
    if (self.sl_emptyView) {
        [self.sl_emptyView removeFromSuperview];
        self.sl_emptyView = nil;
    } else {
        return;
    }
    
    self.scrollEnabled = self.sl_emptyViewScrollEnable;
}
@end
