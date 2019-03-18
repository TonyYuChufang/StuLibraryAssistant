//
//  UIView+SCManualLayout.m
//  stuclass
//
//  Copyright © 2018年 JunhaoWang. All rights reserved.

//  @ref https://github.com/casatwy/HandyAutoLayout

#define RETURN_IF_NIL_VIEW(view) \
do { \
if (view == nil) { \
NSAssert(NO, @"SCManualLayout: View is nil."); \
return; \
} \
} while(0)

#import "UIView+SCManualLayout.h"

@interface UIView (SCManualLayoutCommon)

- (CGPoint)sc_convertOriginFromView:(UIView *)view;

@end

@implementation UIView (SCManualLayoutCommon)

- (CGPoint)sc_convertOriginFromView:(UIView *)view
{
    if (view == nil || view == self.superview) {
        return CGPointZero;
    }
    
    //[NOTE] 同一父View或父View均为nil时，为同一坐标系
    if (self.superview == view.superview) {
        return view.sc_origin;
    }
    
    if (self.superview == nil) {
        UIView *otherTopSuperview = [view sc_topSuperview];
        return [view.superview convertPoint:view.sc_origin toView:otherTopSuperview];
    } else {
        UIView *fromView = (view.superview != nil) ? view.superview : [self sc_topSuperview];
        return [self.superview convertPoint:view.sc_origin fromView:fromView];
    }
}

@end

@implementation UIView (SCManualLayoutProperty)

- (CGFloat)sc_top
{
    return CGRectGetMinY(self.frame);
}

- (void)setSc_top:(CGFloat)sc_top
{
    CGRect frame = self.frame;
    frame.origin.y = sc_top;
    self.frame = frame;
}

- (CGFloat)sc_left
{
    return CGRectGetMinX(self.frame);
}

- (void)setSc_left:(CGFloat)sc_left
{
    CGRect frame = self.frame;
    frame.origin.x = sc_left;
    self.frame = frame;
}

- (CGFloat)sc_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setSc_bottom:(CGFloat)sc_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = sc_bottom - self.sc_height;
    self.frame = frame;
}

- (CGFloat)sc_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setSc_right:(CGFloat)sc_right
{
    CGRect frame = self.frame;
    frame.origin.x = sc_right - self.sc_width;
    self.frame = frame;
}

- (CGFloat)sc_centerX
{
    return self.center.x;
}

- (void)setSc_centerX:(CGFloat)sc_centerX
{
    CGPoint center = self.center;
    center.x = sc_centerX;
    self.center = center;
}

- (CGFloat)sc_centerY
{
    return self.center.y;
}

- (void)setSc_centerY:(CGFloat)sc_centerY
{
    CGPoint center = self.center;
    center.y = sc_centerY;
    self.center = center;
}

- (CGFloat)sc_width
{
    return CGRectGetWidth(self.frame);
}

- (void)setSc_width:(CGFloat)sc_width
{
    CGRect frame = self.frame;
    frame.size.width = sc_width;
    self.frame = frame;
}

- (CGFloat)sc_height
{
    return CGRectGetHeight(self.frame);
}

- (void)setSc_height:(CGFloat)sc_height
{
    CGRect frame = self.frame;
    frame.size.height = sc_height;
    self.frame = frame;
}

- (CGPoint)sc_origin
{
    return self.frame.origin;
}

- (void)setSc_origin:(CGPoint)sc_origin
{
    CGRect frame = self.frame;
    frame.origin = sc_origin;
    self.frame = frame;
}

- (CGSize)sc_size
{
    return self.frame.size;
}

- (void)setSc_size:(CGSize)sc_size
{
    CGRect frame = self.frame;
    frame.size = sc_size;
    self.frame = frame;
}

@end

@implementation UIView (SCManualLayoutHiberarchy)

- (UIView *)sc_topSuperview
{
    UIView *topSuperview = self.superview;
    while (topSuperview.superview != nil) {
        topSuperview = topSuperview.superview;
    }
    return topSuperview;
}

- (BOOL)sc_isSiblingWithView:(UIView *)view
{
    return view.superview != nil ? self.superview == view.superview : NO;
}

@end

@implementation UIView (SCManualLayoutOffset)

- (void)sc_offsetX:(CGFloat)xOffset
{
    self.sc_left += xOffset;
}

- (void)sc_offsetY:(CGFloat)yOffset
{
    self.sc_top += yOffset;
}

- (void)sc_offsetOrigin:(CGPoint)originOffset
{
    self.sc_origin = CGPointMake(self.sc_left + originOffset.x, self.sc_top + originOffset.y);
}

- (void)sc_offsetWidth:(CGFloat)widthOffset
{
    self.sc_width += widthOffset;
}

- (void)sc_offsetHeight:(CGFloat)heightOffset
{
    self.sc_height += heightOffset;
}

- (void)sc_offsetSize:(CGSize)sizeOffset
{
    self.sc_size = CGSizeMake(self.sc_width + sizeOffset.width, self.sc_height + sizeOffset.height);
}

@end

@implementation UIView (SCManualLayoutFill)

- (void)sc_fill
{
    RETURN_IF_NIL_VIEW(self.superview);
    
    self.frame = CGRectMake(0.0, 0.0, self.superview.sc_width, self.superview.sc_height);
}

- (void)sc_fillWidth
{
    RETURN_IF_NIL_VIEW(self.superview);
    
    self.frame = CGRectMake(0.0, self.sc_top, self.superview.sc_width, self.sc_height);
}

- (void)sc_fillHeight
{
    RETURN_IF_NIL_VIEW(self.superview);
    
    self.frame = CGRectMake(self.sc_left, 0.0, self.sc_width, self.superview.sc_height);
}

- (void)sc_fillWithTopSpacing:(CGFloat)topSpacing leftSpacing:(CGFloat)leftSpacing bottomSpacing:(CGFloat)bottomSpacing rightSpacing:(CGFloat)rightSpacing
{
    RETURN_IF_NIL_VIEW(self.superview);
    
    self.frame = CGRectMake(leftSpacing,
                            topSpacing,
                            self.superview.sc_width - leftSpacing - rightSpacing,
                            self.superview.sc_height - topSpacing - bottomSpacing);
}

- (void)sc_fillWithTopSpacing:(CGFloat)topSpacing leftSpacing:(CGFloat)leftSpacing bottomSpacing:(CGFloat)bottomSpacing resizeWidth:(CGFloat)resizeWidth
{
    RETURN_IF_NIL_VIEW(self.superview);
    
    self.frame = CGRectMake(leftSpacing,
                            topSpacing,
                            resizeWidth,
                            self.superview.sc_height - topSpacing - bottomSpacing);
}

- (void)sc_fillWithTopSpacing:(CGFloat)topSpacing rightSpacing:(CGFloat)rightSpacing bottomSpacing:(CGFloat)bottomSpacing resizeWidth:(CGFloat)resizeWidth
{
    RETURN_IF_NIL_VIEW(self.superview);
    
    self.frame = CGRectMake(self.superview.sc_width - rightSpacing - resizeWidth,
                            topSpacing,
                            resizeWidth,
                            self.superview.sc_height - topSpacing - bottomSpacing);
}

- (void)sc_fillWithLeftSpacing:(CGFloat)leftSpacing topSpacing:(CGFloat)topSpacing rightSpacing:(CGFloat)rightSpacing resizeHeight:(CGFloat)resizeHeight
{
    RETURN_IF_NIL_VIEW(self.superview);
    
    self.frame = CGRectMake(leftSpacing,
                            topSpacing,
                            self.superview.sc_width - leftSpacing - rightSpacing,
                            resizeHeight);
}

- (void)sc_fillWithLeftSpacing:(CGFloat)leftSpacing bottomSpacing:(CGFloat)bottomSpacing rightSpacing:(CGFloat)rightSpacing resizeHeight:(CGFloat)resizeHeight
{
    RETURN_IF_NIL_VIEW(self.superview);
    
    self.frame = CGRectMake(leftSpacing,
                            self.superview.sc_height - bottomSpacing - resizeHeight,
                            self.superview.sc_width - leftSpacing - rightSpacing,
                            resizeHeight);
}

@end

@implementation UIView (SCManualLayoutAlign)

- (void)sc_alignLeftToView:(UIView *)view leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + leftSpacing,
                            self.sc_top,
                            resize.width,
                            resize.height);
}

- (void)sc_alignCenterHorizontallyToView:(UIView *)view resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + round((view.sc_width - resize.width) * 0.5),
                            self.sc_top,
                            resize.width,
                            resize.height);
}

- (void)sc_alignRightToView:(UIView *)view rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width - resize.width - rightSpacing,
                            self.sc_top,
                            resize.width,
                            resize.height);
}

- (void)sc_alignTopToView:(UIView *)view topSpacing:(CGFloat)topSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(self.sc_left,
                            origin.y + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_alignCenterVerticallyToView:(UIView *)view resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(self.sc_left,
                            origin.y + round((view.sc_height - resize.height) * 0.5),
                            resize.width,
                            resize.height);
}

- (void)sc_alignBottomToView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(self.sc_left,
                            origin.y + view.sc_height - resize.height - bottomSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_alignTopLeftToView:(UIView *)view topSpacing:(CGFloat)topSpacing leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + leftSpacing,
                            origin.y + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_alignTopCenterToView:(UIView *)view topSpacing:(CGFloat)topSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + round((view.sc_width - resize.width) * 0.5),
                            origin.y + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_alignTopRightToView:(UIView *)view topSpacing:(CGFloat)topSpacing rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width - resize.width - rightSpacing,
                            origin.y + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_alignLeftCenterToView:(UIView *)view leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + leftSpacing,
                            origin.y + round((view.sc_height - resize.height) * 0.5),
                            resize.width,
                            resize.height);
}

- (void)sc_alignCenterToView:(UIView *)view resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + round((view.sc_width - resize.width) * 0.5),
                            origin.y + round((view.sc_height - resize.height) * 0.5),
                            resize.width,
                            resize.height);
}

- (void)sc_alignRightCenterToView:(UIView *)view rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width - resize.width - rightSpacing,
                            origin.y + round((view.sc_height - resize.height) * 0.5),
                            resize.width,
                            resize.height);
}

- (void)sc_alignBottomLeftToView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + leftSpacing,
                            origin.y + view.sc_height - resize.height - bottomSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_alignBottomCenterToView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + round((view.sc_width - resize.width) * 0.5),
                            origin.y + view.sc_height - resize.height - bottomSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_alignBottomRightToView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width - resize.width - rightSpacing,
                            origin.y + view.sc_height - resize.height - bottomSpacing,
                            resize.width,
                            resize.height);
}

@end

@implementation UIView (SCManualLayoutNeighbor)

- (void)sc_neighborTopToView:(UIView *)view topSpacing:(CGFloat)topSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(self.sc_left,
                            origin.y + view.sc_height + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborLeftToView:(UIView *)view leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width + leftSpacing,
                            self.sc_top,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborBottomToView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(self.sc_left,
                            origin.y - bottomSpacing - resize.height,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborRightToView:(UIView *)view rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x - rightSpacing - resize.width,
                            self.sc_top,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborTopLeftToBottomLeftInView:(UIView *)view topSpacing:(CGFloat)topSpacing leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + leftSpacing,
                            origin.y + view.sc_height + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborTopLeftToTopRightInView:(UIView *)view topSpacing:(CGFloat)topSpacing leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width + leftSpacing,
                            origin.y + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborTopLeftToBottomRightInView:(UIView *)view topSpacing:(CGFloat)topSpacing leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width + leftSpacing,
                            origin.y + view.sc_height + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborTopRightToTopLeftInView:(UIView *)view topSpacing:(CGFloat)topSpacing rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x - rightSpacing - resize.width,
                            origin.y + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborTopRightToBottomLeftInView:(UIView *)view topSpacing:(CGFloat)topSpacing rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x - rightSpacing - resize.width,
                            origin.y + view.sc_height + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborTopRightToBottomRightInView:(UIView *)view topSpacing:(CGFloat)topSpacing rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width - rightSpacing - resize.width,
                            origin.y + view.sc_height + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborBottomLeftToTopLeftInView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + leftSpacing,
                            origin.y - bottomSpacing - resize.height,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborBottomLeftToTopRightInView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width + leftSpacing,
                            origin.y - bottomSpacing - resize.height,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborBottomLeftToBottomRightInView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width + leftSpacing,
                            origin.y + view.sc_height  - bottomSpacing - resize.height,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborBottomRightToTopLeftInView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x - rightSpacing - resize.width,
                            origin.y - bottomSpacing - resize.height,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborBottomRightToBottomLeftInView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x - rightSpacing - resize.width,
                            origin.y + view.sc_height - bottomSpacing - resize.height,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborBottomRightToTopRightInView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width - rightSpacing - resize.width,
                            origin.y - bottomSpacing - resize.height,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborTopCenterToView:(UIView *)view topSpacing:(CGFloat)topSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + round((view.sc_width - resize.width) * 0.5),
                            origin.y + view.sc_height + topSpacing,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborLeftCenterToView:(UIView *)view leftSpacing:(CGFloat)leftSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + view.sc_width + leftSpacing,
                            origin.y + round((view.sc_height - resize.height) * 0.5),
                            resize.width,
                            resize.height);
}

- (void)sc_neighborBottomCenterToView:(UIView *)view bottomSpacing:(CGFloat)bottomSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x + round((view.sc_width - resize.width) * 0.5),
                            origin.y - bottomSpacing - resize.height,
                            resize.width,
                            resize.height);
}

- (void)sc_neighborRightCenterToView:(UIView *)view rightSpacing:(CGFloat)rightSpacing resize:(CGSize)resize
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.frame = CGRectMake(origin.x - rightSpacing - resize.width,
                            origin.y + round((view.sc_height - resize.height) * 0.5),
                            resize.width,
                            resize.height);
}

@end

@implementation UIView (SCManualLayoutEqualize)

- (void)sc_equalizeTopToView:(UIView *)view
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.sc_top = origin.y;
}

- (void)sc_equalizeLeftToView:(UIView *)view
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.sc_left = origin.x;
}

- (void)sc_equalizeBottomToView:(UIView *)view
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.sc_bottom = origin.y + view.sc_height;
}

- (void)sc_equalizeRightToView:(UIView *)view
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.sc_right = origin.x + view.sc_width;
}

- (void)sc_equalizeOriginToView:(UIView *)view
{
    RETURN_IF_NIL_VIEW(view);
    
    CGPoint origin = [self sc_convertOriginFromView:view];
    self.sc_origin = origin;
}

@end

@implementation UIView (SCManualLayoutHelper)

- (void)sc_fillTopWithHeight:(CGFloat)height
{
    [self sc_fillWithLeftSpacing:0.0 topSpacing:0.0 rightSpacing:0.0 resizeHeight:height];
}

- (void)sc_fillLeftWithWidth:(CGFloat)width
{
    [self sc_fillWithTopSpacing:0.0 leftSpacing:0.0 bottomSpacing:0.0 resizeWidth:width];
}

- (void)sc_fillBottomWithHeight:(CGFloat)height
{
    [self sc_fillWithLeftSpacing:0.0 bottomSpacing:0.0 rightSpacing:0.0 resizeHeight:height];
}

- (void)sc_fillRightWithWidth:(CGFloat)width
{
    [self sc_fillWithTopSpacing:0.0 rightSpacing:0.0 bottomSpacing:0.0 resizeWidth:width];
}

- (void)sc_fillTopWithBottomSpacing:(CGFloat)bottomSpacing
{
    [self sc_fillWithTopSpacing:0.0 leftSpacing:0.0 bottomSpacing:bottomSpacing rightSpacing:0.0];
}

- (void)sc_fillLeftWithRightSpacing:(CGFloat)rightSpacing
{
    [self sc_fillWithTopSpacing:0.0 leftSpacing:0.0 bottomSpacing:0.0 rightSpacing:rightSpacing];
}

- (void)sc_fillBottomWithTopSpacing:(CGFloat)topSpacing
{
    [self sc_fillWithTopSpacing:topSpacing leftSpacing:0.0 bottomSpacing:0.0 rightSpacing:0.0];
}

- (void)sc_fillRightWithLeftSpacing:(CGFloat)leftSpacing
{
    [self sc_fillWithTopSpacing:0.0 leftSpacing:leftSpacing bottomSpacing:0.0 rightSpacing:0.0];
}

- (void)sc_neighborTopLeftToBottomLeftInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborTopLeftToBottomLeftInView:view topSpacing:0.0 leftSpacing:0.0 resize:resize];
}
- (void)sc_neighborTopLeftToTopRightInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborTopLeftToTopRightInView:view topSpacing:0.0 leftSpacing:0.0 resize:resize];
}

- (void)sc_neighborTopLeftToBottomRightInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborTopLeftToBottomRightInView:view topSpacing:0.0 leftSpacing:0.0 resize:resize];
}

- (void)sc_neighborTopRightToTopLeftInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborTopRightToTopLeftInView:view topSpacing:0.0 rightSpacing:0.0 resize:resize];
}

- (void)sc_neighborTopRightToBottomLeftInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborTopRightToBottomLeftInView:view topSpacing:0.0 rightSpacing:0.0 resize:resize];
}

- (void)sc_neighborTopRightToBottomRightInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborTopRightToBottomRightInView:view topSpacing:0.0 rightSpacing:0.0 resize:resize];
}

- (void)sc_neighborBottomLeftToTopLeftInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborBottomLeftToTopLeftInView:view bottomSpacing:0.0 leftSpacing:0.0 resize:resize];
}

- (void)sc_neighborBottomLeftToTopRightInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborBottomLeftToTopRightInView:view bottomSpacing:0.0 leftSpacing:0.0 resize:resize];
}

- (void)sc_neighborBottomLeftToBottomRightInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborBottomLeftToBottomRightInView:view bottomSpacing:0.0 leftSpacing:0.0 resize:resize];
}

- (void)sc_neighborBottomRightToTopLeftInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborBottomRightToTopLeftInView:view bottomSpacing:0.0 rightSpacing:0.0 resize:resize];
}

- (void)sc_neighborBottomRightToBottomLeftInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborBottomRightToBottomLeftInView:view bottomSpacing:0.0 rightSpacing:0.0 resize:resize];
}

- (void)sc_neighborBottomRightToTopRightInView:(UIView *)view resize:(CGSize)resize
{
    [self sc_neighborBottomRightToTopRightInView:view bottomSpacing:0.0 rightSpacing:0.0 resize:resize];
}

- (void)sc_alignTopToView:(UIView *)view
{
    [self sc_alignTopToView:view topSpacing:0.0 resize:self.sc_size];
}

- (void)sc_alignLeftToView:(UIView *)view
{
    [self sc_alignLeftToView:view leftSpacing:0.0 resize:self.sc_size];
}

- (void)sc_alignBottomToView:(UIView *)view
{
    [self sc_alignBottomToView:view bottomSpacing:0.0 resize:self.sc_size];
}

- (void)sc_alignRightToView:(UIView *)view
{
    [self sc_alignRightToView:view rightSpacing:0.0 resize:self.sc_size];
}

- (void)sc_alignTopLeftWithSize:(CGSize)size
{
    [self sc_alignTopLeftToView:self.superview topSpacing:0.0 leftSpacing:0.0 resize:size];
}

- (void)sc_alignTopRightWithSize:(CGSize)size
{
    [self sc_alignTopRightToView:self.superview topSpacing:0.0 rightSpacing:0.0 resize:size];
}

- (void)sc_alignBottomLeftWithSize:(CGSize)size
{
    [self sc_alignBottomLeftToView:self.superview bottomSpacing:0.0 leftSpacing:0.0 resize:size];
}

- (void)sc_alignBottomRightWithSize:(CGSize)size
{
    [self sc_alignBottomRightToView:self.superview bottomSpacing:0.0 rightSpacing:0.0 resize:size];
}

@end
