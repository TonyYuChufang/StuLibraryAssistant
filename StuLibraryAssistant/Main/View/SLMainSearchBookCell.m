//
//  SLMainSearchBookCell.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/20.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLMainSearchBookCell.h"
#import "SLStyleManager+Theme.h"
#import "SLSearchBookCellViewModel.h"
#import "SLLoanBookCellViewModel.h"
#import "SLCollectBookCellViewModel.h"
#import "SLNetwokrManager.h"
#import "SLCacheManager.h"
@interface SLMainSearchBookCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *bookNameLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *bookCountLabel;
@property (nonatomic, strong) UIButton *markBtn;
@property (nonatomic, strong) UIView *sperateLine;
@property (nonatomic, strong) UILabel *loanStatusLabel;
@property (nonatomic, strong) UIImageView *loanStatusImageView;
@property (nonatomic, assign) BOOL isCollected;

@end

@implementation SLMainSearchBookCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIImageView *cover = [[UIImageView alloc] init];
    cover.image = [UIImage imageNamed:@"main_search_empty_holder"];
    [self.contentView addSubview:cover];
    self.coverImageView = cover;
    
    UIImageView *loanStatus = [[UIImageView alloc] init];
    loanStatus.image = [UIImage imageNamed:@"icon_loanbook_status_normal"];
    [self.contentView addSubview:loanStatus];
    loanStatus.hidden = YES;
    self.loanStatusImageView = loanStatus;
    
    UILabel *loanStatusLabel = [[UILabel alloc] init];
    loanStatusLabel.font = [UIFont systemFontOfSize:14];
    [loanStatusLabel setTextColor:[SLStyleManager LightGrayColor]];
    loanStatusLabel.text = @"借阅状态：";
    [loanStatusLabel sizeToFit];
    [self.contentView addSubview:loanStatusLabel];
    self.loanStatusLabel = loanStatusLabel;
    
    UIButton *markBtn = [[UIButton alloc] init];
    [markBtn setImage:[UIImage imageNamed:@"main_search_cell_mark"] forState:UIControlStateNormal];
    [markBtn addTarget:self action:@selector(onMarkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:markBtn];
    self.markBtn = markBtn;
    
    UILabel *bookname = [[UILabel alloc] init];
    bookname.font = [UIFont systemFontOfSize:16];
    [bookname setTextColor:[SLStyleManager DeepDarkGrayColor]];
    bookname.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    bookname.numberOfLines = 2;
    [self.contentView addSubview:bookname];
    self.bookNameLabel = bookname;
    
    
    UILabel *author = [[UILabel alloc] init];
    author.font = [UIFont systemFontOfSize:14];
    [author setTextColor:[SLStyleManager LightGrayColor]];
    [self.contentView addSubview:author];
    self.authorLabel = author;
    
    UILabel *bookCount = [[UILabel alloc] init];
    bookCount.font = [UIFont systemFontOfSize:14];
    [bookCount setTextColor:[SLStyleManager LightGrayColor]];
    [self.contentView addSubview:bookCount];
    self.bookCountLabel = bookCount;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [SLStyleManager LightGrayColor];
    [self.contentView addSubview:line];
    self.sperateLine = line;
}

- (void)layoutSubviews
{
    self.coverImageView.sc_size = CGSizeMake(67, 85);
    self.coverImageView.sc_left = 32;
    self.coverImageView.sc_centerY = self.contentView.sc_centerY;
    
    self.loanStatusLabel.sc_left = \
    self.authorLabel.sc_left = \
    self.bookCountLabel.sc_left = \
    self.bookNameLabel.sc_left = self.coverImageView.sc_right + 16;
    
    self.bookNameLabel.sc_top = self.coverImageView.sc_top;
    self.bookNameLabel.sc_width = self.contentView.sc_width - self.coverImageView.sc_width - 64 - 28;
    
    self.authorLabel.sc_top = self.bookNameLabel.sc_bottom + 6;
    self.authorLabel.sc_width = self.contentView.sc_width - self.coverImageView.sc_width - 64 - 28;
    self.authorLabel.sc_height = 16;

    self.loanStatusLabel.sc_top = self.authorLabel.sc_bottom + 6;
    self.loanStatusImageView.sc_centerY = self.loanStatusLabel.sc_centerY;
    self.loanStatusImageView.sc_left = self.loanStatusLabel.sc_right;

    self.bookCountLabel.sc_bottom = self.coverImageView.sc_bottom;
    self.bookCountLabel.sc_width = self.contentView.sc_width - self.coverImageView.sc_width - 64 - 28;
    self.bookCountLabel.sc_height = 16;
    
    if (!self.loanStatusImageView.hidden) {
        self.bookCountLabel.sc_top = self.loanStatusLabel.sc_bottom + 6;
    }
    
    self.markBtn.sc_centerY = self.bookCountLabel.sc_centerY;
    self.markBtn.sc_size = CGSizeMake(30, 35);
    self.markBtn.sc_right = self.contentView.sc_right - 32;
    
    self.sperateLine.sc_size = CGSizeMake(self.sc_width-30, 1);
    self.sperateLine.sc_bottom = self.contentView.sc_bottom;
    self.sperateLine.sc_right = self.contentView.sc_right;
}
#pragma mark - Action
- (void)onMarkBtnClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectMarkBtnBookCell:isCollected:)]) {
        [self.delegate didSelectMarkBtnBookCell:self isCollected:self.isCollected];
    }
}

#pragma mark - Public
-(void)bindBookCellViewModel:(id)viewModel
{
    [self layoutIfNeeded];
    if ([viewModel isKindOfClass:[SLSearchBookCellViewModel class]]) {
        [self updateCellWithSearchBookCellViewModel:viewModel];
    } else if ([viewModel isKindOfClass:[SLLoanBookCellViewModel class]]) {
        [self updateCellWithLoanBookViewModel:viewModel];
    } else if ([viewModel isKindOfClass:[SLCollectBookCellViewModel class]]) {
        [self updateCellWithCollectBookViewModel:viewModel];
    }
   
    [self.bookNameLabel sizeToFit];
    [self.authorLabel sizeToFit];
    [self.bookCountLabel sizeToFit];
    [self layoutIfNeeded];
}

#pragma mark - Private
- (void)updateCellWithSearchBookCellViewModel:(SLSearchBookCellViewModel *)viewModel
{
    self.bookNameLabel.text = viewModel.bookName;
    self.authorLabel.text = viewModel.authorName;
    self.bookCountLabel.text = viewModel.bookCount;
    self.markBtn.hidden = NO;
    self.loanStatusImageView.hidden = YES;
    self.loanStatusLabel.hidden = YES;
    self.isCollected = viewModel.isCollected;
    //    其他控件装配
    //    。。。。
    if (viewModel.isCollected) {
        [self.markBtn setImage:[UIImage imageNamed:@"main_search_cell_mark_highlighted"] forState:normal];
    } else {
        [self.markBtn setImage:[UIImage imageNamed:@"main_search_cell_mark"] forState:UIControlStateNormal];
    }
    self.coverImageView.image = [UIImage imageNamed:@"main_search_empty_holder"];
    [self updateCoverImageWithUrlStr:viewModel.coverImageUrl];
}

- (void)updateCellWithLoanBookViewModel:(SLLoanBookCellViewModel *)viewModel
{
    self.loanStatusImageView.hidden = NO;
    self.loanStatusLabel.hidden = NO;
    self.markBtn.hidden = YES;
    self.bookNameLabel.text = viewModel.bookName;
    self.authorLabel.text = viewModel.authorName;
    self.bookCountLabel.text = viewModel.loanDate;
    self.coverImageView.image = [UIImage imageNamed:@"main_search_empty_holder"];
    self.loanStatusImageView.image = [UIImage imageNamed:viewModel.loanStatus];
    self.loanStatusImageView.sc_size = viewModel.loanStatusSize;
    [self updateCoverImageWithUrlStr:viewModel.coverImageUrl];
}

- (void)updateCellWithCollectBookViewModel:(SLCollectBookCellViewModel *)viewModel
{
    self.loanStatusLabel.hidden = YES;
    self.loanStatusImageView.hidden = YES;
    self.bookNameLabel.text = viewModel.bookName;
    self.bookCountLabel.text = viewModel.bookCount;
    self.authorLabel.text = viewModel.bookAuthor;
    self.coverImageView.image = [UIImage imageNamed:@"main_search_empty_holder"];
    self.isCollected = YES;
    [self.markBtn setImage:[UIImage imageNamed:@"main_search_cell_mark_highlighted"] forState:normal];
    [self updateCoverImageWithUrlStr:viewModel.coverImageUrl];
}

- (void)updateMarkStatus:(BOOL)isCollected
{
    self.isCollected = isCollected;
    if (isCollected) {
        [self.markBtn setImage:[UIImage imageNamed:@"main_search_cell_mark_highlighted"] forState:normal];
    } else {
        [self.markBtn setImage:[UIImage imageNamed:@"main_search_cell_mark"] forState:UIControlStateNormal];
    }
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
