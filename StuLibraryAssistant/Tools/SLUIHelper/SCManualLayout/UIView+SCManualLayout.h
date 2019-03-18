//
//  UIView+SCManualLayout.h
//  kiwi
//
//  Created by maihx on 15/11/20.
//  Copyright © 2015年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SCManualLayoutProperty)

@property (nonatomic, assign) CGFloat sc_top;
@property (nonatomic, assign) CGFloat sc_left;
@property (nonatomic, assign) CGFloat sc_bottom;
@property (nonatomic, assign) CGFloat sc_right;

@property (nonatomic, assign) CGFloat sc_width;
@property (nonatomic, assign) CGFloat sc_height;

@property (nonatomic, assign) CGPoint sc_origin;
@property (nonatomic, assign) CGSize sc_size;

@property (nonatomic, assign) CGFloat sc_centerX;
@property (nonatomic, assign) CGFloat sc_centerY;

@end

@interface UIView (SCManualLayoutHiberarchy)

- (UIView *)sc_topSuperview;
- (BOOL)sc_isSiblingWithView:(UIView *)view;

@end

@interface UIView (SCManualLayoutOffset)

- (void)sc_offsetX:(CGFloat)xOffset;
- (void)sc_offsetY:(CGFloat)yOffset;
- (void)sc_offsetOrigin:(CGPoint)originOffset;

- (void)sc_offsetWidth:(CGFloat)widthOffset;
- (void)sc_offsetHeight:(CGFloat)heightOffset;
- (void)sc_offsetSize:(CGSize)sizeOffset;

@end

@interface UIView (SCManualLayoutFill)

- (void)sc_fill;
- (void)sc_fillWidth;
- (void)sc_fillHeight;

- (void)sc_fillWithTopSpacing:(CGFloat)topSpacing
                   leftSpacing:(CGFloat)leftSpacing
                 bottomSpacing:(CGFloat)bottomSpacing
                  rightSpacing:(CGFloat)rightSpacing;

- (void)sc_fillWithTopSpacing:(CGFloat)topSpacing
                   leftSpacing:(CGFloat)leftSpacing
                 bottomSpacing:(CGFloat)bottomSpacing
                   resizeWidth:(CGFloat)resizeWidth;
- (void)sc_fillWithTopSpacing:(CGFloat)topSpacing
                  rightSpacing:(CGFloat)rightSpacing
                 bottomSpacing:(CGFloat)bottomSpacing
                   resizeWidth:(CGFloat)resizeWidth;
- (void)sc_fillWithLeftSpacing:(CGFloat)leftSpacing
                     topSpacing:(CGFloat)topSpacing
                   rightSpacing:(CGFloat)rightSpacing
                   resizeHeight:(CGFloat)resizeHeight;
- (void)sc_fillWithLeftSpacing:(CGFloat)leftSpacing
                  bottomSpacing:(CGFloat)bottomSpacing
                   rightSpacing:(CGFloat)rightSpacing
                   resizeHeight:(CGFloat)resizeHeight;

@end

@interface UIView (SCManualLayoutAlign)

- (void)sc_alignLeftToView:(UIView *)view
                leftSpacing:(CGFloat)leftSpacing
                     resize:(CGSize)resize;
- (void)sc_alignCenterHorizontallyToView:(UIView *)view
                                   resize:(CGSize)resize;
- (void)sc_alignRightToView:(UIView *)view
                rightSpacing:(CGFloat)rightSpacing
                      resize:(CGSize)resize;

- (void)sc_alignTopToView:(UIView *)view
                topSpacing:(CGFloat)topSpacing
                    resize:(CGSize)resize;
- (void)sc_alignCenterVerticallyToView:(UIView *)view
                                 resize:(CGSize)resize;
- (void)sc_alignBottomToView:(UIView *)view
                bottomSpacing:(CGFloat)bottomSpacing
                       resize:(CGSize)resize;

- (void)sc_alignTopLeftToView:(UIView *)view
                    topSpacing:(CGFloat)topSpacing
                   leftSpacing:(CGFloat)leftSpacing
                        resize:(CGSize)resize;
- (void)sc_alignTopCenterToView:(UIView *)view
                      topSpacing:(CGFloat)topSpacing
                          resize:(CGSize)resize;
- (void)sc_alignTopRightToView:(UIView *)view
                     topSpacing:(CGFloat)topSpacing
                   rightSpacing:(CGFloat)rightSpacing
                         resize:(CGSize)resize;

- (void)sc_alignLeftCenterToView:(UIView *)view
                      leftSpacing:(CGFloat)leftSpacing
                           resize:(CGSize)resize;
- (void)sc_alignCenterToView:(UIView *)view
                       resize:(CGSize)resize;
- (void)sc_alignRightCenterToView:(UIView *)view
                      rightSpacing:(CGFloat)rightSpacing
                            resize:(CGSize)resize;

- (void)sc_alignBottomLeftToView:(UIView *)view
                    bottomSpacing:(CGFloat)bottomSpacing
                      leftSpacing:(CGFloat)leftSpacing
                           resize:(CGSize)resize;
- (void)sc_alignBottomCenterToView:(UIView *)view
                      bottomSpacing:(CGFloat)bottomSpacing
                             resize:(CGSize)resize;
- (void)sc_alignBottomRightToView:(UIView *)view
                     bottomSpacing:(CGFloat)bottomSpacing
                      rightSpacing:(CGFloat)rightSpacing
                            resize:(CGSize)resize;

@end

@interface UIView (SCManualLayoutNeighbor)

- (void)sc_neighborTopToView:(UIView *)view
                   topSpacing:(CGFloat)topSpacing
                       resize:(CGSize)resize;
- (void)sc_neighborLeftToView:(UIView *)view
                   leftSpacing:(CGFloat)leftSpacing
                        resize:(CGSize)resize;
- (void)sc_neighborBottomToView:(UIView *)view
                   bottomSpacing:(CGFloat)bottomSpacing
                          resize:(CGSize)resize;
- (void)sc_neighborRightToView:(UIView *)view
                   rightSpacing:(CGFloat)rightSpacing
                         resize:(CGSize)resize;

- (void)sc_neighborTopLeftToBottomLeftInView:(UIView *)view
                                   topSpacing:(CGFloat)topSpacing
                                  leftSpacing:(CGFloat)leftSpacing
                                       resize:(CGSize)resize;
- (void)sc_neighborTopLeftToTopRightInView:(UIView *)view
                                 topSpacing:(CGFloat)topSpacing
                                leftSpacing:(CGFloat)leftSpacing
                                     resize:(CGSize)resize;
- (void)sc_neighborTopLeftToBottomRightInView:(UIView *)view
                                    topSpacing:(CGFloat)topSpacing
                                   leftSpacing:(CGFloat)leftSpacing
                                        resize:(CGSize)resize;

- (void)sc_neighborTopRightToTopLeftInView:(UIView *)view
                                 topSpacing:(CGFloat)topSpacing
                               rightSpacing:(CGFloat)rightSpacing
                                     resize:(CGSize)resize;
- (void)sc_neighborTopRightToBottomLeftInView:(UIView *)view
                                    topSpacing:(CGFloat)topSpacing
                                  rightSpacing:(CGFloat)rightSpacing
                                        resize:(CGSize)resize;
- (void)sc_neighborTopRightToBottomRightInView:(UIView *)view
                                     topSpacing:(CGFloat)topSpacing
                                   rightSpacing:(CGFloat)rightSpacing
                                         resize:(CGSize)resize;

- (void)sc_neighborBottomLeftToTopLeftInView:(UIView *)view
                                bottomSpacing:(CGFloat)bottomSpacing
                                  leftSpacing:(CGFloat)leftSpacing
                                       resize:(CGSize)resize;
- (void)sc_neighborBottomLeftToTopRightInView:(UIView *)view
                                 bottomSpacing:(CGFloat)bottomSpacing
                                   leftSpacing:(CGFloat)leftSpacing
                                        resize:(CGSize)resize;
- (void)sc_neighborBottomLeftToBottomRightInView:(UIView *)view
                                    bottomSpacing:(CGFloat)bottomSpacing
                                      leftSpacing:(CGFloat)leftSpacing
                                           resize:(CGSize)resize;

- (void)sc_neighborBottomRightToTopLeftInView:(UIView *)view
                                 bottomSpacing:(CGFloat)bottomSpacing
                                  rightSpacing:(CGFloat)rightSpacing
                                        resize:(CGSize)resize;
- (void)sc_neighborBottomRightToBottomLeftInView:(UIView *)view
                                    bottomSpacing:(CGFloat)bottomSpacing
                                     rightSpacing:(CGFloat)rightSpacing
                                           resize:(CGSize)resize;
- (void)sc_neighborBottomRightToTopRightInView:(UIView *)view
                                  bottomSpacing:(CGFloat)bottomSpacing
                                   rightSpacing:(CGFloat)rightSpacing
                                         resize:(CGSize)resize;

- (void)sc_neighborTopCenterToView:(UIView *)view
                         topSpacing:(CGFloat)topSpacing
                             resize:(CGSize)resize;
- (void)sc_neighborLeftCenterToView:(UIView *)view
                         leftSpacing:(CGFloat)leftSpacing
                              resize:(CGSize)resize;
- (void)sc_neighborBottomCenterToView:(UIView *)view
                         bottomSpacing:(CGFloat)bottomSpacing
                                resize:(CGSize)resize;
- (void)sc_neighborRightCenterToView:(UIView *)view
                         rightSpacing:(CGFloat)rightSpacing
                               resize:(CGSize)resize;

@end

@interface UIView (SCManualLayoutEqualize)

- (void)sc_equalizeTopToView:(UIView *)view;
- (void)sc_equalizeLeftToView:(UIView *)view;
- (void)sc_equalizeBottomToView:(UIView *)view;
- (void)sc_equalizeRightToView:(UIView *)view;
- (void)sc_equalizeOriginToView:(UIView *)view;

@end

@interface UIView (SCManualLayoutHelper)

- (void)sc_fillTopWithHeight:(CGFloat)height;
- (void)sc_fillLeftWithWidth:(CGFloat)width;
- (void)sc_fillBottomWithHeight:(CGFloat)height;
- (void)sc_fillRightWithWidth:(CGFloat)width;

- (void)sc_fillTopWithBottomSpacing:(CGFloat)bottomSpacing;
- (void)sc_fillLeftWithRightSpacing:(CGFloat)rightSpacing;
- (void)sc_fillBottomWithTopSpacing:(CGFloat)topSpacing;
- (void)sc_fillRightWithLeftSpacing:(CGFloat)leftSpacing;

- (void)sc_neighborTopLeftToBottomLeftInView:(UIView *)view resize:(CGSize)resize;
- (void)sc_neighborTopLeftToTopRightInView:(UIView *)view resize:(CGSize)resize;
- (void)sc_neighborTopLeftToBottomRightInView:(UIView *)view resize:(CGSize)resize;

- (void)sc_neighborTopRightToTopLeftInView:(UIView *)view resize:(CGSize)resize;
- (void)sc_neighborTopRightToBottomLeftInView:(UIView *)view resize:(CGSize)resize;
- (void)sc_neighborTopRightToBottomRightInView:(UIView *)view resize:(CGSize)resize;

- (void)sc_neighborBottomLeftToTopLeftInView:(UIView *)view resize:(CGSize)resize;
- (void)sc_neighborBottomLeftToTopRightInView:(UIView *)view resize:(CGSize)resize;
- (void)sc_neighborBottomLeftToBottomRightInView:(UIView *)view resize:(CGSize)resize;

- (void)sc_neighborBottomRightToTopLeftInView:(UIView *)view resize:(CGSize)resize;
- (void)sc_neighborBottomRightToBottomLeftInView:(UIView *)view resize:(CGSize)resize;
- (void)sc_neighborBottomRightToTopRightInView:(UIView *)view resize:(CGSize)resize;

- (void)sc_alignTopToView:(UIView *)view;
- (void)sc_alignLeftToView:(UIView *)view;
- (void)sc_alignBottomToView:(UIView *)view;
- (void)sc_alignRightToView:(UIView *)view;

- (void)sc_alignTopLeftWithSize:(CGSize)size;
- (void)sc_alignTopRightWithSize:(CGSize)size;
- (void)sc_alignBottomLeftWithSize:(CGSize)size;
- (void)sc_alignBottomRightWithSize:(CGSize)size;

@end
