//
//  SLDetailToolView.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/21.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLDetailToolView.h"
#import "SLStyleManager+Theme.h"
#import "SLMenuItemView.h"

@interface SLDetailToolView ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, strong) NSMutableArray *lineViews;

@end

@implementation SLDetailToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubview];
        self.itemViews = [[NSMutableArray alloc] init];
        self.lineViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setupSubview
{
    self.topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sc_width, 1)];
    self.topLine.backgroundColor = [SLStyleManager LightGrayColor];
    [self addSubview:self.topLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topLine.sc_top = 0;
    self.topLine.sc_left = 0;
    
    CGFloat itemWidth = kScreenWidth / self.itemViews.count;
    CGFloat itemHeight = self.sc_height;
    for (int i = 0; i < self.itemViews.count; i++) {
        UIView *view = [self.itemViews objectAtIndex:i];
        view.sc_width = itemWidth;
        view.sc_height = itemHeight;
        view.sc_left = i * itemWidth;
        view.sc_top = 0;
    }
    for (int i = 0; i < self.lineViews.count; i++) {
        UIView *view = [self.lineViews objectAtIndex:i];
        view.sc_left = (i + 1) * itemWidth;
        view.sc_centerY = self.sc_height / 2.0;
    }
}

- (void)updateToolView
{
    if (self.itemViews.count) {
        for (int i = 0; i < self.itemViews.count; i++) {
            SLTextItemView *textItem = [self.itemViews objectAtIndex:i];
            [textItem updateItemWithInfo:[self.controlItems objectAtIndex:i]];
        }
        return;
    }
    
    for (int i = 0; i < self.controlItems.count; i++) {
        SLMenuItemInfo *info = [self.controlItems objectAtIndex:i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemDidSelected:)];
        SLTextItemView *textItem = [SLTextItemView textItemViewWithInfo:info];
        textItem.tag = i;
        [textItem addGestureRecognizer:tap];
        [self addSubview:textItem];
        [self.itemViews addObject:textItem];
    }
    
    for (int i = 0; i < self.controlItems.count - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.sc_height - 20)];
        lineView.backgroundColor = [SLStyleManager LightGrayColor];
        [self addSubview:lineView];
        [self.lineViews addObject:lineView];
    }
}

- (void)itemDidSelected:(UITapGestureRecognizer *)sender
{
    for (SLTextItemView *view in self.itemViews) {
        SLMenuItemInfo *info = [self.controlItems objectAtIndex:view.tag];
        if (sender.view == view) {
            info.menuItemSelectedHandler();
        }
    }
}
@end
