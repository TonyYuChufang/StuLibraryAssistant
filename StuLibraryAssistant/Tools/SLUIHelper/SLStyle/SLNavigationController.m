//
//  SLNavigationViewController.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/4/12.
//  Copyright © 2019 yu. All rights reserved.
//

#import "SLNavigationController.h"
#import <WebKit/WebKit.h>
@interface SLNavigationController ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic)UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic)UIImageView *backView;

@property (strong, nonatomic)NSMutableArray *backImgs;
@property (assign) CGPoint panBeginPoint;
@property (assign) CGPoint panEndPoint;

@end

@implementation SLNavigationController
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        //initlization
//       [self setDefaultNavType];
//    }
//    return self;
//}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setDefaultNavType];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [self initilization];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBaseUI];
}

- (void)initilization{
    self.backImgs = [[NSMutableArray alloc] init];
}

- (void)loadBaseUI{
    //原生方法无效
    self.interactivePopGestureRecognizer.enabled = NO;
    
    //设置手势
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    self.panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"WKContentView")]) {
        return YES;
    }
    return NO;
}
#pragma mark- public method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //截图
    if (animated) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kScreenHeight), YES, 0.0);
        [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.backImgs addObject:img];
        [self pushViewController:viewController Type:self.pushType];
    } else {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kScreenHeight), YES, 0.0);
        [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.backImgs addObject:img];
        [super pushViewController:viewController animated:NO];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [self removeLastViewFromSuperView];
    if (animated) {
        return [self popViewControllerWithType:self.popType];
    } else {
        return [super popViewControllerAnimated:NO];
    }
}

#pragma mark- private method
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer*)panGestureRecognizer{
    if ([self.viewControllers count] == 1) {
        return ;
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.panBeginPoint = [panGestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];
        [self insertLastViewFromSuperView:self.view.superview];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded){

        self.panEndPoint = [panGestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];
        CGFloat offetX = self.popType == SLPushTypeFromLeft ? (_panEndPoint.x - _panBeginPoint.x) : (_panBeginPoint.x - _panEndPoint.x);
        if (offetX > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveNavigationViewWithLenght:(self.popType == SLPushTypeFromLeft ? kScreenWidth : -kScreenWidth)];
                
            } completion:^(BOOL finished) {
                [super popViewControllerAnimated:NO];
                [self removeLastViewFromSuperView];
                [self moveNavigationViewWithLenght:0];
            }];
            
            
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveNavigationViewWithLenght:0];
            }];
        }
    } else {
        CGFloat panLength = self.popType == SLPushTypeFromLeft ? ([panGestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow].x - _panBeginPoint.x) : (_panBeginPoint.x - [panGestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow].x);
        if (panLength > 0) {
            if (self.popType == SLPushTypeFromRight) {
                panLength = -panLength;
            }
            [self moveNavigationViewWithLenght:panLength];
        }
    }
    
}

/**
 *  移动视图界面
 *
 *  @param lenght 移动的长度
 */
- (void)moveNavigationViewWithLenght:(CGFloat)lenght{
    
    //图片位置设置
    self.view.frame = CGRectMake(lenght, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //图片动态阴影
    if (lenght < 0) {
        lenght = -lenght;
    }
    _backView.alpha = (lenght/[UIScreen mainScreen].bounds.size.width)*2/3 + 0.33;
}

/**
 *  插图上一级图片
 *
 *  @param superView 图片的superView
 */
- (void)insertLastViewFromSuperView:(UIView *)superView{
    //插入上一级视图背景
    if (_backView == nil) {
        _backView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backView.image = [_backImgs lastObject];
    }
    [self.view.superview insertSubview:_backView belowSubview:self.view];
}

/**
 *  移除上一级图片
 */
- (void)removeLastViewFromSuperView{
    [_backView removeFromSuperview];
    [self.backImgs removeLastObject];
    _backView = nil;
}


- (void)pushViewController:(UIViewController *)vc Type:(SLPushType)type
{
    CATransition* transition = [CATransition animation];
    transition.duration =0.2f;
    transition.type = kCATransitionMoveIn;
    switch (type) {
            case SLPushTypeFromTop:
            transition.subtype = kCATransitionFromTop;
            break;
            case SLPushTypeFromLeft:
            transition.subtype = kCATransitionFromLeft;
            break;
            case SLPushTypeFromRight:
            transition.subtype = kCATransitionFromRight;
            break;
            case SLPushTypeFromBottom:
            transition.subtype = kCATransitionFromBottom;
            break;
        default:
            break;
    }
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [super pushViewController:vc animated:NO];
}

- (UIViewController *)popViewControllerWithType:(SLPushType)type
{
    CATransition* transition = [CATransition animation];
    transition.duration =0.2f;
    transition.type = kCATransitionReveal;
    switch (type) {
            case SLPushTypeFromTop:
            transition.subtype = kCATransitionFromTop;
            break;
            case SLPushTypeFromLeft:
            transition.subtype = kCATransitionFromLeft;
            break;
            case SLPushTypeFromRight:
            transition.subtype = kCATransitionFromRight;
            break;
            case SLPushTypeFromBottom:
            transition.subtype = kCATransitionFromBottom;
            break;
        default:
            break;
    }
    [self.view.layer addAnimation:transition forKey:kCATransition];
    return [super popViewControllerAnimated:NO];
}
@end
