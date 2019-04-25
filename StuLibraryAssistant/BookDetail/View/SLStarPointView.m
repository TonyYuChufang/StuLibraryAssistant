//
//  SLStarPointView.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLStarPointView.h"
#import "SLStyleManager+Theme.h"
static CGFloat kStarSpace = 3.0;
static CGFloat kStarWidth = 20.0;
static CGFloat kStarHeight = 18.7;
@interface SLStarPointView ()

@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) NSMutableArray *stars;

@end

@implementation SLStarPointView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.stars = [[NSMutableArray alloc] init];
        [self setupSubview];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < self.stars.count; i++) {
        UIView *view = [self.stars objectAtIndex:i];
        view.sc_size = CGSizeMake(kStarWidth, kStarHeight);
        view.sc_left = i * kStarSpace + i * kStarWidth;
        view.sc_centerY = self.sc_height / 2.0;
        
        if (i == self.stars.count - 1) {
            self.pointLabel.sc_left = view.sc_right + 10;
            self.pointLabel.sc_centerY = self.sc_height / 2.0;
        }
    }
}

- (void)setupSubview
{
    self.pointLabel = [[UILabel alloc] init];
    self.pointLabel.textColor = [SLStyleManager GrayColor];
    self.pointLabel.font = [UIFont systemFontOfSize:14];
    self.pointLabel.text = @"0.0";
    [self.pointLabel sizeToFit];
    [self addSubview:self.pointLabel];
}

- (void)updateStarPoint:(CGFloat)point
{
    NSUInteger fullStarCount = (NSUInteger)point;
    NSUInteger halfStarCount = 0;
    if (point - fullStarCount > 0.5) {
        fullStarCount++;
    } else if (point - fullStarCount > 0.000001){
        halfStarCount = 1;
    }
    
    if (self.stars.count > 0) {
        for (int i = 0; i < 5; i++) {
            UIImageView *imageView = [self.stars objectAtIndex:i];
            imageView.userInteractionEnabled = self.canScore;
            if (fullStarCount > 0) {
                imageView.image = [UIImage imageNamed:@"icon_bookDetail_star_full"];
                fullStarCount--;
            } else if (halfStarCount) {
                imageView.image = [UIImage imageNamed:@"icon_bookDetail_star_half"];
                halfStarCount--;
            } else {
                imageView.image = [UIImage imageNamed:@"icon_bookDetail_star_normal"];
            }
        }
    } else {
        for (int i = 0; i < 5; i++) {
            UIImageView *imageView = nil;
            if (fullStarCount > 0) {
                imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bookDetail_star_full"]];
                fullStarCount--;
            } else if (halfStarCount) {
                imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bookDetail_star_half"]];
                halfStarCount--;
            } else {
                imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bookDetail_star_normal"]];
            }
            imageView.tag = i + 1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starDidSelected:)];
            imageView.userInteractionEnabled = self.canScore;
            [imageView addGestureRecognizer:tap];
            [self addSubview:imageView];
            [self.stars addObject:imageView];
        }
    }
    self.pointLabel.text = [NSString stringWithFormat:@"%.1lf",point];
    self.pointLabel.hidden = !_shouldShowScore;
    [self.pointLabel sizeToFit];
}

- (void)starDidSelected:(UITapGestureRecognizer *)recognizer
{
    CGFloat score = recognizer.view.tag;
    if ([self.delegate respondsToSelector:@selector(slstarPointView:DidSelectWithScore:)]) {
        [self.delegate slstarPointView:self DidSelectWithScore:score];
    }
}
@end
