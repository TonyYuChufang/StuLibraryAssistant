//
//  SLLoginHeaderView.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/13.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLLoginHeaderView.h"
#import "UIView+SCManualLayout.h"
#import "SLStyleManager+Theme.h"
static CGFloat kItemSpace = 15.0;
static CGFloat kItemWidth = 24.0;
static CGFloat kItemHeight = 24.0;

@implementation SLHeaderBarItemInfo

@end


@interface SLHeaderBarItem ()

@property (nonatomic, copy) void (^barItemClickedHandler)(void);
@property (nonatomic, strong) UIButton *button;

@end

@implementation SLHeaderBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubview];
    }
    
    return self;
}

- (void)setupSubview
{
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kItemWidth, kItemWidth)];
    [self.button addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
}

- (void)onBtnClicked:(id)sender
{
    if (self.barItemClickedHandler) {
        self.barItemClickedHandler();
    }
}

@end

@interface SLLoginHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *logoIcon;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation SLLoginHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.leftBarItems = [[NSMutableArray alloc] init];
        self.rightBarItems = [[NSMutableArray alloc] init];
        self.items = [[NSMutableArray alloc] init];
        [self setupSubview];
    }
    
    return self;
}

- (void)setupSubview
{
    self.logoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    UIImage *image = [[UIImage imageNamed:@"login_icon_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.logoIcon.tintColor = [SLStyleManager LightGrayColor];
    self.logoIcon.image = image;
    self.logoIcon.hidden = YES;
    [self addSubview:self.logoIcon];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
}

- (void)updateHeaderView
{
    if (self.leftBarItems) {
        [self.leftBarItems enumerateObjectsUsingBlock:^(SLHeaderBarItemInfo *info, NSUInteger idx, BOOL * _Nonnull stop) {
            SLHeaderBarItem *itemView = [[SLHeaderBarItem alloc] initWithFrame:CGRectMake(0, 0, kItemWidth, kItemHeight)];
            itemView.barItemClickedHandler = info.barItemClickedHandler;
            [itemView.button setImage:[[UIImage imageNamed:info.itemImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            itemView.button.tintColor = [SLStyleManager DarkGrayColor];
            itemView.sc_left = kItemSpace * (idx + 1) + idx * kItemWidth;
            itemView.sc_centerY = self.sc_centerY;
            [self addSubview:itemView];
            [self.items addObject:itemView];
        }];
    }
    
    if (self.rightBarItems) {
        [self.rightBarItems enumerateObjectsUsingBlock:^(SLHeaderBarItemInfo *info, NSUInteger idx, BOOL * _Nonnull stop) {
            SLHeaderBarItem *itemView = [[SLHeaderBarItem alloc] initWithFrame:CGRectMake(0, 0, kItemWidth, kItemHeight)];
            itemView.barItemClickedHandler = info.barItemClickedHandler;
            [itemView.button setImage:[[UIImage imageNamed:info.itemImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            itemView.button.tintColor = [SLStyleManager DarkGrayColor];
            itemView.sc_right = self.sc_right - (kItemSpace * (idx + 1) + idx * kItemWidth);
            itemView.sc_centerY = self.sc_centerY;
            [self addSubview:itemView];
            [self.items addObject:itemView];
        }];
    }
    
    switch (self.viewType) {
        case SLHeaderViewTypeNoLogo:
            self.logoIcon.hidden = YES;
            break;
        case SLHeaderViewTypeLeftLogo:
            self.logoIcon.hidden = NO;
            self.logoIcon.sc_left = 10;
            break;
        case SLHeaderViewTypeRightLogo:
            self.logoIcon.hidden = NO;
            self.logoIcon.sc_right = self.sc_right - 10;
            break;
        case SLHeaderViewTypeMiddleLogo:
            self.logoIcon.hidden = NO;
            self.logoIcon.tintColor = [SLStyleManager DarkGrayColor];
            self.logoIcon.sc_centerX = self.sc_centerX;
            break;
        default:
            break;
    }
    
    self.logoIcon.sc_centerY = self.sc_centerY;
    self.titleLabel.text = self.title;
    [self.titleLabel sizeToFit];
    self.titleLabel.sc_centerX = self.sc_centerX;
    self.titleLabel.sc_centerY = self.sc_centerY;
}

@end

