//
//  CollectionViewCell.m
//  CollectionCardPage
//
//  Created by ymj_work on 16/5/22.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import "SLNewBookCell.h"
#import "SLSearchBookCellViewModel.h"
#import "SLNetwokrManager.h"

@interface SLNewBookCell ()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *bookNameLabel;
@property (nonatomic, strong) UILabel *bookAuthorLabel;
@property (nonatomic, strong) UILabel *pubDateLabel;
@end

@implementation SLNewBookCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}

- (void)layoutSubviews
{
    [self updateLayout];
}

- (void)updateLayout
{
    self.coverImageView.sc_top = 20;
    self.coverImageView.sc_centerX = self.contentView.sc_width / 2.0;
    
    self.bookNameLabel.sc_top = self.coverImageView.sc_bottom + 20;
    self.bookNameLabel.sc_left = 20;
    self.bookNameLabel.sc_width = self.contentView.sc_width - 40;
    
    self.bookAuthorLabel.sc_top = self.bookNameLabel.sc_bottom + 10;
    self.bookAuthorLabel.sc_left = 20;
    
    self.pubDateLabel.sc_top = self.bookAuthorLabel.sc_bottom + 10;
    self.pubDateLabel.sc_left = 20;
}
- (void)setupSubview
{
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 130)];
    self.coverImageView.image = [UIImage imageNamed:@"main_search_empty_holder"];
    [self.contentView addSubview:self.coverImageView];
    
    self.bookNameLabel = [[UILabel alloc] init];
    self.bookNameLabel.textColor = [UIColor blackColor];
    self.bookNameLabel.font = [UIFont systemFontOfSize:14];
    self.bookNameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.bookNameLabel];
    
    self.bookAuthorLabel = [[UILabel alloc] init];
    self.bookAuthorLabel.textColor = [UIColor blackColor];
    self.bookAuthorLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.bookAuthorLabel];
    
    self.pubDateLabel = [[UILabel alloc] init];
    self.pubDateLabel.textColor = [UIColor blackColor];
    self.pubDateLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.pubDateLabel];
}

- (void)bindViewModel:(SLSearchBookCellViewModel *)viewModel
{
    self.bookNameLabel.text = [NSString stringWithFormat:@"书名：%@",[viewModel.bookName substringFromIndex:1]];
    self.bookAuthorLabel.text =[NSString stringWithFormat:@"作者：%@",viewModel.authorName];
    self.pubDateLabel.text = [NSString stringWithFormat:@"出版时间：%@",viewModel.publishDate];
    
    [self updateCoverImageWithUrlStr:viewModel.coverImageUrl];
    [self.bookNameLabel sizeToFit];
    [self.bookAuthorLabel sizeToFit];
    [self.pubDateLabel sizeToFit];
    [self updateLayout];
}

- (void)updateCoverImageWithUrlStr:(NSString *)imageUrl
{
    [[SLNetwokrManager sharedObject] downloadOpacImageWithUrl:imageUrl completeBlock:^(id responseObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (responseObject) {
                self.coverImageView.image = responseObject;
            } else {
                self.coverImageView.image = [UIImage imageNamed:@"main_search_empty_holder"];
            }
        });
    }];
}
@end

