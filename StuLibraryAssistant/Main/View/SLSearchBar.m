//
//  SLSearchBar.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/28.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLSearchBar.h"
#import "SLStyleManager+Theme.h"
@interface SLSearchBar () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *searchIcon;

@end

@implementation SLSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.searchIcon.sc_centerY = self.textField.sc_centerY;
    self.searchIcon.sc_left = self.sc_width / 2 - 70;
}

- (void)setupSubView
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.sc_width, self.sc_height)];
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentCenter;
    UILabel *placeholderLabel = [textField valueForKey:@"_placeholderLabel"];
    placeholderLabel.font = [UIFont systemFontOfSize:10];
    placeholderLabel.textAlignment = NSTextAlignmentCenter;
    placeholderLabel.textColor = [SLStyleManager LightGrayColor];
    
    textField.layer.borderColor = [SLStyleManager LightGrayColor].CGColor;
    textField.layer.cornerRadius = 12;
    textField.layer.borderWidth = 1;
    textField.layer.masksToBounds = YES;
    textField.font = [UIFont systemFontOfSize:12];
    [self addSubview:textField];
    self.textField = textField;
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    searchIcon.image = [UIImage imageNamed:@"ic_search"];
    [self addSubview:searchIcon];
    self.searchIcon = searchIcon;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textField) {
        if ([self.delegate respondsToSelector:@selector(slSearchBarDidSelectReturnWithText:)]) {
            [self.delegate slSearchBarDidSelectReturnWithText:self.textField.text];
        }
        return YES;
    }
    
    return NO;
}

#pragma mark - setter and getter
- (NSString *)text
{
    return self.textField.text;
}

- (void)setText:(NSString *)text
{
    self.textField.text = text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.textField.placeholder = placeholder;
}
@end
