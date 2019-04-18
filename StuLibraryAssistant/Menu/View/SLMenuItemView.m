//
//  SLMenuItemView.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/7.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLMenuItemView.h"
#import "SLStyleManager+Theme.h"

@implementation SLMenuItemInfo

@end

@interface SLMenuItemView ()

@property (nonatomic, strong) UIImageView *menuIcon;
@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UIView *containView;

@end

@implementation SLMenuItemView

+ (SLMenuItemView *)menuItemViewWithInfo:(SLMenuItemInfo *)info
{
    SLMenuItemView *itemView = [[SLMenuItemView alloc] initWithFrame:CGRectZero];
    [itemView updateItemWithInfo:info];
    return itemView;
}

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
    [self updateItemLayout];
}
- (void)updateItemWithInfo:(SLMenuItemInfo *)info
{
    self.menuIcon.image = [[UIImage imageNamed:info.imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.menuLabel.text = info.title;
    self.menuItemSelectedHandler = info.menuItemSelectedHandler;
    [self.menuLabel sizeToFit];
    [self updateItemLayout];
}
- (void)updateItemLayout
{
    self.containView.sc_centerX = self.sc_width / 2.0;
    self.containView.sc_centerY = self.sc_height / 2.0;
    
    self.menuIcon.sc_top = 0;
    self.menuIcon.sc_centerX = self.containView.sc_width / 2.0;
    
    self.menuLabel.sc_top = self.menuIcon.sc_bottom + 10;
    self.menuLabel.sc_centerX = self.menuIcon.sc_centerX;
}

- (void)setupSubview
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemViewClicked:)];
    [self addGestureRecognizer:tap];
    UIImageView *menuIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    menuIcon.tintColor = [SLStyleManager menuItemDarkColor];
    self.menuIcon = menuIcon;
    
    UILabel *menuLabel = [[UILabel alloc] init];
    menuLabel.text = @"默认选项";
    menuLabel.font = [UIFont systemFontOfSize:14];
    menuLabel.textColor = [SLStyleManager menuItemDarkColor];
    [menuLabel sizeToFit];
    self.menuLabel = menuLabel;
    
    self.containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.menuLabel.sc_width, 34 + self.menuLabel.sc_height)];
    [self addSubview:self.containView];
    [self.containView addSubview:menuIcon];
    [self.containView addSubview:menuLabel];
}

- (void)onItemViewClicked:(id)sender
{
    if (self.menuItemSelectedHandler) {
        self.menuItemSelectedHandler();
    }
}
@end

@interface SLTextItemView ()

@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, assign) BOOL selected;

@end

@implementation SLTextItemView

+ (SLTextItemView *)textItemViewWithInfo:(SLMenuItemInfo *)info
{
    SLTextItemView *itemView = [[SLTextItemView alloc] initWithFrame:CGRectZero];
    [itemView updateItemWithInfo:info];
    return itemView;
}

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
    [self updateItemLayout];
}

- (void)updateItemLayout
{
    self.menuLabel.sc_centerY = self.sc_height / 2.0;
    self.menuLabel.sc_centerX = self.sc_width / 2.0;
}

- (void)updateItemWithInfo:(SLMenuItemInfo *)info
{
    self.selected = info.isSelected;
    self.menuLabel.text = info.title;
    self.menuLabel.textColor = info.isSelected ? [SLStyleManager MainGreenColor] : [SLStyleManager DarkGrayColor];
    [self.menuLabel sizeToFit];
    [self updateItemLayout];
}

- (void)setupSubview
{
    UILabel *menuLabel = [[UILabel alloc] init];
    menuLabel.text = @"默认选项";
    menuLabel.font = [UIFont systemFontOfSize:16];
    menuLabel.textColor = [SLStyleManager menuItemDarkColor];
    [menuLabel sizeToFit];
    [self addSubview:menuLabel];
    self.menuLabel = menuLabel;
}
@end
