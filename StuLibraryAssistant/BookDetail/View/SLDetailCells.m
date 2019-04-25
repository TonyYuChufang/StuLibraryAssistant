//
//  SLDetailCells.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/17.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLDetailCells.h"
#import "SLStarPointView.h"
#import "SLStyleManager+Theme.h"
#import "SLBookDetailViewModel.h"
@interface SLCollectInfoCell ()
@property (nonatomic, strong) UILabel *assetIdLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *fetchIdLabel;
@property (nonatomic, strong) UILabel *loanTypeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *spereatorLine;
@end

@implementation SLCollectInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubview];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.assetIdLabel.sc_top = 10;
    self.assetIdLabel.sc_left = 20;
    
    self.locationLabel.sc_top = self.assetIdLabel.sc_bottom + 5;
    self.locationLabel.sc_left = 20;
    
    self.fetchIdLabel.sc_top = self.locationLabel.sc_bottom + 5;
    self.fetchIdLabel.sc_left = 20;
    
    self.loanTypeLabel.sc_top = self.fetchIdLabel.sc_bottom + 5;
    self.loanTypeLabel.sc_left = 20;
    
    self.statusLabel.sc_top = self.loanTypeLabel.sc_bottom + 5;
    self.statusLabel.sc_left = 20;
    
    self.spereatorLine.sc_bottom = self.sc_height;
    self.spereatorLine.sc_left = 0;
}

- (void)setupSubview
{
    self.assetIdLabel = [[UILabel alloc] init];
    self.assetIdLabel.font = [UIFont systemFontOfSize:10];
    self.assetIdLabel.textColor = [UIColor blackColor];
    self.assetIdLabel.text = @"登录号：3214978";
    [self.assetIdLabel sizeToFit];
    [self.contentView addSubview:self.assetIdLabel];
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.font = [UIFont systemFontOfSize:10];
    self.locationLabel.textColor = [UIColor blackColor];
    self.locationLabel.text = @"馆藏地点：三楼东北区34排3列4层";
    [self.locationLabel sizeToFit];
    [self.contentView addSubview:self.locationLabel];
    
    self.fetchIdLabel = [[UILabel alloc] init];
    self.fetchIdLabel.font = [UIFont systemFontOfSize:10];
    self.fetchIdLabel.textColor = [UIColor blackColor];
    self.fetchIdLabel.text = @"索取号：I313.65/201506D";
    [self.fetchIdLabel sizeToFit];
    [self.contentView addSubview:self.fetchIdLabel];
    
    self.loanTypeLabel = [[UILabel alloc] init];
    self.loanTypeLabel.font = [UIFont systemFontOfSize:10];
    self.loanTypeLabel.textColor = [UIColor blackColor];
    self.loanTypeLabel.text = @"借阅类型：普通图书";
    [self.loanTypeLabel sizeToFit];
    [self.contentView addSubview:self.loanTypeLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:10];
    self.statusLabel.textColor = [UIColor blackColor];
    self.statusLabel.text = @"状态：已借出/应还时间：2019.04.03";
    [self.statusLabel sizeToFit];
    [self.contentView addSubview:self.statusLabel];
    
    self.spereatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    self.spereatorLine.backgroundColor = [SLStyleManager LightGrayColor];
    [self.contentView addSubview:self.spereatorLine];
}

+ (NSString *)reuseId
{
    return @"SLCollectInfoCell";
}

- (void)bindBookLocationViewModel:(SLBookLoactionViewModel *)viewModel
{
    self.assetIdLabel.text = viewModel.bookAssetId;
    self.fetchIdLabel.text = viewModel.bookFetchId;
    self.statusLabel.text = viewModel.bookStatus;
    self.loanTypeLabel.text = viewModel.bookLoanType;
    self.locationLabel.text = viewModel.bookLocation;
    
    [self.assetIdLabel sizeToFit];
    [self.fetchIdLabel sizeToFit];
    [self.statusLabel sizeToFit];
    [self.locationLabel sizeToFit];
    [self.loanTypeLabel sizeToFit];
}
@end

@interface SLDetailInfoCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation SLDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubview];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    self.titleLabel.sc_left = 20;
    self.titleLabel.sc_top = 10;
    
    self.contentLabel.sc_top = self.titleLabel.sc_bottom + 10;
    self.contentLabel.sc_left = 20;
    self.contentLabel.sc_width = kScreenWidth - 40;
}

- (void)setupSubview
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = @"摘要";
    [self.titleLabel sizeToFit];
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.textColor = [SLStyleManager GrayColor];
    self.contentLabel.text = @"我觉得这是一本很好的书";
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.sc_width = kScreenWidth - 40;
    CGSize fitSize = CGSizeMake(kScreenWidth - 40, CGFLOAT_MAX);
    CGSize bestSize = [self.contentLabel sizeThatFits:fitSize];
    self.contentLabel.sc_height = bestSize.height;
    [self.contentView addSubview:self.contentLabel];
}

- (void)updateDetailInfoWith:(NSString *)title content:(NSString *)content
{
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    
    [self.titleLabel sizeToFit];
    [self.contentLabel sizeToFit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+ (CGFloat)heightForDetailCellWithContent:(NSString *)content
{
    CGFloat totalHeight = 46;
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.textColor = [SLStyleManager GrayColor];
    contentLabel.text = content;
    contentLabel.numberOfLines = 0;
    CGSize fitSize = CGSizeMake(kScreenWidth - 40, CGFLOAT_MAX);
    CGSize bestSize = [contentLabel sizeThatFits:fitSize];
    totalHeight = totalHeight + bestSize.height;
    return totalHeight;
}
+ (NSString *)reuseId
{
    return @"SLDetailInfoCell";
}

@end

@interface SLScoreMyCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *spereatorLine;
@end

@implementation SLScoreMyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubview];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat centerY = self.sc_height / 2.0;
    self.titleLabel.sc_centerY = centerY;
    self.titleLabel.sc_left = 20;
    
    self.starPointView.sc_right = self.sc_width - 20;
    self.starPointView.sc_centerY = centerY;
    
    self.spereatorLine.sc_bottom = self.sc_height;
    self.spereatorLine.sc_left = 0;
}

- (void)setupSubview
{
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"我的评分";
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.titleLabel sizeToFit];
    [self.contentView addSubview:self.titleLabel];
    
    self.starPointView = [[SLStarPointView alloc] initWithFrame:CGRectMake(0, 0, 110, 24)];
    self.starPointView.canScore = YES;
    self.starPointView.shouldShowScore = NO;
    [self.starPointView updateStarPoint:0.0];
    [self.contentView addSubview:self.starPointView];
    
    self.spereatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    self.spereatorLine.backgroundColor = [SLStyleManager LightGrayColor];
    [self.contentView addSubview:self.spereatorLine];
    
}


+ (NSString *)reuseId
{
    return @"SLScoreMyCell";
}

- (void)bindBookScoreViewModel:(SLBookScoreViewModel *)viewModel
{
    if (viewModel == nil) {
        self.starPointView.canScore = YES;
        self.starPointView.shouldShowScore = NO;
        [self.starPointView updateStarPoint:0.0];
    } else {
        self.starPointView.canScore = NO;
        self.starPointView.shouldShowScore = NO;
        [self.starPointView updateStarPoint:viewModel.score];
    }
}
@end

@interface SLScoreOtherCell ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) SLStarPointView *starPointView;
@property (nonatomic, strong) UIView *spereatorLine;


@end

@implementation SLScoreOtherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubview];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat centerY = self.sc_height / 2.0;
    self.avatarView.sc_left = 20;
    self.avatarView.sc_centerY = centerY;
    
    self.nickNameLabel.sc_top = self.avatarView.sc_top;
    self.nickNameLabel.sc_left = self.avatarView.sc_right + 10;
    
    self.dateLabel.sc_top = self.nickNameLabel.sc_bottom + 3;
    self.dateLabel.sc_left = self.nickNameLabel.sc_left;
    
    self.starPointView.sc_right = self.sc_width - 20;
    self.starPointView.sc_centerY = centerY;
    
    self.spereatorLine.sc_left = 0;
    self.spereatorLine.sc_bottom = self.sc_height;
}

- (void)setupSubview
{
    self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    self.avatarView.image = [UIImage imageNamed:@"icon_avatar_defalut"];
    [self.contentView addSubview:self.avatarView];
    
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.text = @"余楚放";
    self.nickNameLabel.textColor = [UIColor blackColor];
    self.nickNameLabel.font = [UIFont systemFontOfSize:10];
    [self.nickNameLabel sizeToFit];
    [self.contentView addSubview:self.nickNameLabel];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.text = @"2018.04.18 14:58:03";
    self.dateLabel.textColor = [SLStyleManager LightGrayColor];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    [self.dateLabel sizeToFit];
    [self.contentView addSubview:self.dateLabel];
    
    self.starPointView = [[SLStarPointView alloc] initWithFrame:CGRectMake(0, 0, 110, 24)];
    self.starPointView.canScore = NO;
    self.starPointView.shouldShowScore = NO;
    [self.starPointView updateStarPoint:3.8];
    [self.contentView addSubview:self.starPointView];
    
    self.spereatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    self.spereatorLine.backgroundColor = [SLStyleManager LightGrayColor];
    [self.contentView addSubview:self.spereatorLine];
    
}

+ (NSString *)reuseId
{
    return @"SLScoreOtherCell";
}

- (void)bindBookScoreViewModel:(SLBookScoreViewModel *)viewModel
{
    self.nickNameLabel.text = viewModel.nickName;
    self.dateLabel.text = viewModel.createDate;
    [self.starPointView updateStarPoint:viewModel.score];
}
@end
