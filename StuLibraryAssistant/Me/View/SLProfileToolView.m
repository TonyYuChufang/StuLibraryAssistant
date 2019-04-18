//
//  SLProfileToolView.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/15.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLProfileToolView.h"
#import "SLStyleManager+Theme.h"

@interface SLProfileToolView ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *spearteLine;
@property (nonatomic, strong) UIImageView *loanBookImageView;
@property (nonatomic, strong) UILabel *loanBookLabel;
@property (nonatomic, strong) UIView *loanBookView;
@property (nonatomic, strong) UIImageView *debtImageView;
@property (nonatomic, strong) UILabel *debtLabel;
@property (nonatomic, strong) UIView *debtView;
@end

@implementation SLProfileToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubview];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topLine.sc_height = 1;
    self.topLine.sc_width = kScreenWidth;
    self.topLine.sc_top = 0;
    self.topLine.sc_left = 0;
    
    self.bottomLine.sc_height = 1;
    self.bottomLine.sc_width = kScreenWidth;
    self.bottomLine.sc_bottom = self.sc_height;
    self.bottomLine.sc_left = 0;

    self.spearteLine.sc_height = 56;
    self.spearteLine.sc_width = 1;
    self.spearteLine.sc_centerX = self.sc_width / 2.0;
    self.spearteLine.sc_centerY = self.sc_height / 2.0;
    
    self.loanBookView.sc_width = kScreenWidth / 2.0;
    self.loanBookView.sc_height = self.sc_height;
    self.loanBookView.sc_left = 0;
    self.loanBookView.sc_top = 0;
    
    self.debtView.sc_width = kScreenWidth / 2.0;
    self.debtView.sc_height = self.sc_height;
    self.debtView.sc_left = self.loanBookView.sc_right;
    self.debtView.sc_top = 0;
    
    self.loanBookImageView.sc_height = 32;
    self.loanBookImageView.sc_width = 28;
    self.loanBookImageView.sc_centerX = self.loanBookView.sc_centerX;
    self.loanBookImageView.sc_top = 21;
    
    self.loanBookLabel.sc_top = self.loanBookImageView.sc_bottom + 11;
    self.loanBookLabel.sc_centerX = self.loanBookImageView.sc_centerX;
    
    self.debtImageView.sc_height = 32;
    self.debtImageView.sc_width = 21.3;
    self.debtImageView.sc_left = self.debtView.sc_width / 2.0 - 10.5;
    self.debtImageView.sc_top = 21;
    
    self.debtLabel.sc_top = self.debtImageView.sc_bottom + 11;
    self.debtLabel.sc_centerX = self.debtImageView.sc_centerX;
}
- (void)setupSubview
{
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [SLStyleManager LightGrayColor];
    [self addSubview:self.topLine];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [SLStyleManager LightGrayColor];
    [self addSubview:self.bottomLine];
    
    self.spearteLine = [[UIView alloc] init];
    self.spearteLine.backgroundColor = [SLStyleManager LightGrayColor];
    [self addSubview:self.spearteLine];
    
    self.loanBookView = [[UIView alloc] init];
    [self addSubview:self.loanBookView];
    
    self.debtView = [[UIView alloc] init];
    [self addSubview:self.debtView];
    
    self.loanBookImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_profile_book"]];
    self.loanBookLabel = [[UILabel alloc] init];
    self.loanBookLabel.textColor = [UIColor blackColor];
    self.loanBookLabel.font = [UIFont systemFontOfSize:16];
    self.loanBookLabel.text = @"0/20 可借阅";
    [self.loanBookLabel sizeToFit];
    [self.loanBookView addSubview:self.loanBookImageView];
    [self.loanBookView addSubview:self.loanBookLabel];
    
    self.debtImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_profile_money"]];
    self.debtLabel = [[UILabel alloc] init];
    self.debtLabel.textColor = [UIColor blackColor];
    self.debtLabel.font = [UIFont systemFontOfSize:16];
    self.debtLabel.text = @"-45.0 欠款";
    [self.debtLabel sizeToFit];
    
    [self.debtView addSubview:self.debtImageView];
    [self.debtView addSubview:self.debtLabel];
}

- (void)setDebt:(NSString *)debt
{
    _debt = debt;
    self.debtLabel.text = debt;
    [self.debtLabel sizeToFit];
}

- (void)setLoanBookCount:(NSString *)loanBookCount
{
    _loanBookCount = loanBookCount;
    self.loanBookLabel.text = loanBookCount;
    [self.loanBookLabel sizeToFit];
}
@end
