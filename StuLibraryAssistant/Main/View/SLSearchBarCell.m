//
//  SLSearchBarCell.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/14.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLSearchBarCell.h"

@interface SLSearchBarCell ()

@property (nonatomic, strong) UIView *searchBar;

@end

@implementation SLSearchBarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews
{
    if (self.searchBar) {
        self.searchBar.sc_centerX = self.contentView.sc_centerX;
        self.searchBar.sc_centerY = self.contentView.sc_centerY;
    }
}

- (void)updateSearchBar:(UIView *)searchBar
{
    self.searchBar = searchBar;
    [self.contentView addSubview:self.searchBar];
    [self layoutIfNeeded];
}
@end
