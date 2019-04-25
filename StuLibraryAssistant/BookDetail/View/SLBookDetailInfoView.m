//
//  SLBookDetailInfoView.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLBookDetailInfoView.h"
#import "SLStarPointView.h"
#import "SLStyleManager+Theme.h"
#import "SLBookDetailViewModel.h"
#import "SLCacheManager.h"
#import "SLNetwokrManager.h"

@interface SLBookDetailInfoView ()

@property (nonatomic, strong) UIImageView *bookImageView;
@property (nonatomic, strong) UIImageView *bookNameIcon;
@property (nonatomic, strong) UILabel *bookNameLabel;
@property (nonatomic, strong) SLStarPointView *starPointView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *publishInfoLabel;

@end

@implementation SLBookDetailInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubview];
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.bookImageView.sc_left = 20;
    self.bookImageView.sc_centerY = self.sc_height / 2.0;
    
    self.bookNameIcon.sc_left = self.bookImageView.sc_right + 20;
    self.bookNameIcon.sc_top = self.bookImageView.sc_top;
    
    self.bookNameLabel.sc_left = self.bookNameIcon.sc_right + 5;
    self.bookNameLabel.sc_width = self.sc_width - self.bookNameLabel.sc_left - 20;
    self.bookNameLabel.sc_centerY = self.bookNameIcon.sc_centerY;
    
    self.starPointView.sc_top = self.bookNameIcon.sc_bottom + 10;
    self.starPointView.sc_left = self.bookNameIcon.sc_left;
    
    self.authorLabel.sc_left = self.bookNameIcon.sc_left;
    self.authorLabel.sc_width = self.sc_width - self.authorLabel.sc_left - 20;
    self.authorLabel.sc_top = self.starPointView.sc_bottom + 10;
    
    self.publishInfoLabel.sc_left = self.bookNameIcon.sc_left;
    self.publishInfoLabel.sc_top = self.authorLabel.sc_bottom + 10;
}

- (void)setupSubview
{
    UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 108)];
    bookImageView.image = [UIImage imageNamed:@"main_search_empty_holder"];
    [self addSubview:bookImageView];
    self.bookImageView = bookImageView;
    
    UIImageView *bookIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    bookIconImageView.image = [UIImage imageNamed:@"icon_bookDetail_bookType"];
    [self addSubview:bookIconImageView];
    self.bookNameIcon = bookIconImageView;
    
    UILabel *bookNameLabel = [[UILabel alloc] init];
    bookNameLabel.font = [UIFont systemFontOfSize:16];
    bookNameLabel.textColor = [UIColor blackColor];
    bookNameLabel.text = @"C语言程序设计";
    bookNameLabel.numberOfLines = 2;
    [bookNameLabel sizeToFit];
    [self addSubview:bookNameLabel];
    self.bookNameLabel = bookNameLabel;
    
    SLStarPointView *starPointView = [[SLStarPointView alloc] initWithFrame:CGRectMake(0, 0, 146, 20)];
    starPointView.shouldShowScore = YES;
    starPointView.canScore = NO;
    [starPointView updateStarPoint:3.8];
    [self addSubview:starPointView];
    self.starPointView = starPointView;
    
    UILabel *authorLabel = [[UILabel alloc] init];
    authorLabel.textColor = [SLStyleManager GrayColor];
    authorLabel.font = [UIFont systemFontOfSize:14];
    authorLabel.text = @"余楚放 著 黄嘉琳 译";
    authorLabel.numberOfLines = 2;
    [authorLabel sizeToFit];
    [self addSubview:authorLabel];
    self.authorLabel = authorLabel;
    
    UILabel *publishLabel = [[UILabel alloc] init];
    publishLabel.textColor = [SLStyleManager GrayColor];
    publishLabel.font = [UIFont systemFontOfSize:14];
    publishLabel.text = @"汕头大学 2019.3";
    [publishLabel sizeToFit];
    [self addSubview:publishLabel];
    self.publishInfoLabel = publishLabel;
}

- (void)setScore:(CGFloat)score
{
    _score = score;
    [self.starPointView updateStarPoint:score];
}

- (void)updateDetailViewWithViewModel:(SLBookDetailViewModel *)viewModel
{
    self.bookNameLabel.text = viewModel.bookName;
    self.authorLabel.text = viewModel.bookAuthor;
    self.publishInfoLabel.text = viewModel.bookPublishInfo;
    [self.publishInfoLabel sizeToFit];
    
    self.score = viewModel.bookPoint;
    BlockWeakSelf(weakSelf, self);
    [[SLNetwokrManager sharedObject] downloadOpacImageWithUrl:viewModel.bookImageUrl completeBlock:^(id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (responseObject) {
                weakSelf.bookImageView.image = responseObject;
            } else {
                weakSelf.bookImageView.image = [UIImage imageNamed:@"main_search_empty_holder"];
            }
        });
    }];
}


@end
