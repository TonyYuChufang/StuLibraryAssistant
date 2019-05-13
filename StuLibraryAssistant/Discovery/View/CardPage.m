//
//  CardPage.m
//  CardPage
//
//  Created by ymj_work on 16/5/22.
//  Copyright © 2016年 ymj_work. All rights reserved.
//

#import "CardPage.h"
#import "CollectionFlowLayout.h"
#import "SLNewBookCell.h"
#import "SLStyleManager+Theme.h"
#import "UIScrollView+EmptyView.h"

static CGFloat cellWidth = 300;
static CGFloat itemSpacing = 10;
static CGFloat ButtonHeight = 80;


@interface CardPage()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *viewModelArray;
@property (nonatomic,assign) NSUInteger itemNumber;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@end



@implementation CardPage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    self.titleLabel.sc_top = 0;
    self.titleLabel.sc_left = 20;
    self.collectionView.sc_top = self.titleLabel.sc_bottom + 5;
    self.pageControl.sc_top = self.collectionView.sc_bottom + 5;
    self.pageControl.sc_centerX = self.collectionView.sc_centerX;
    self.leftBtn.sc_left = 0;
    self.leftBtn.sc_centerY = self.collectionView.sc_centerY;
    self.rightBtn.sc_right = self.sc_width;
    self.rightBtn.sc_centerY = self.collectionView.sc_centerY;
}

- (void)initSubviews
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
}

- (void)bindViewModels:(NSArray *)viewModels
{
    self.viewModelArray = viewModels;
    self.itemNumber = viewModels.count;
    self.pageControl.numberOfPages = viewModels.count;
    [self.collectionView reloadData];
    if (viewModels.count == 0) {
        [self.collectionView sl_showEmptyViewWithType:SLEmptyViewTypeNoNewBook];
        self.rightBtn.alpha = 0;
    }
}

#pragma mark - getter & setter
- (UICollectionView*)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[CollectionFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = itemSpacing;
        layout.itemSize = CGSizeMake(cellWidth, cellWidth);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 400) collectionViewLayout:layout];
        [_collectionView registerClass:[SLNewBookCell class] forCellWithReuseIdentifier:@"SLNewBookCell"];
        _collectionView.backgroundColor = [SLStyleManager LightGrayColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }

    return _collectionView;
}


- (UIPageControl*)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _pageControl.numberOfPages = 5;
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
    }
    
    return _pageControl;
}

- (UIButton*)leftBtn
{
    if (_leftBtn == nil) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, ButtonHeight)];
        _leftBtn.imageView.image = [UIImage imageNamed:@"left"];
        [_leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(lastPage:) forControlEvents:UIControlEventTouchUpInside];
        if (_collectionView.contentOffset.x<self.frame.size.width/2){
            _leftBtn.alpha = 0;
        }else{
            _leftBtn.alpha = 0.5;
        }
    }
    
    return _leftBtn;
}

- (UIButton*)rightBtn
{
    if (_rightBtn == nil) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, ButtonHeight)];
        [_rightBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        _rightBtn.imageView.image = [UIImage imageNamed:@"right"];
        [_rightBtn addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightBtn.alpha = 0.5;
        NSLog(@"rightbutton");
        NSLog(@"_collectionView.contentSize.width%f",_collectionView.contentSize.width);
    }
    return _rightBtn;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"新书通报";
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
        [_titleLabel sizeToFit];
    }
    
    return _titleLabel;
}
#pragma mark - private
- (void)lastPage:(UIButton*)button
{
    float last_X = _collectionView.contentOffset.x - (cellWidth+itemSpacing);
    [_collectionView setContentOffset:CGPointMake(last_X, 0) animated:YES];
    //set后collectionView的contentOffset.x的值还未改变，判断时多考虑一个单元
    if (_collectionView.contentOffset.x<(self.frame.size.width/2+cellWidth+itemSpacing)){
        _leftBtn.alpha = 0;
        _rightBtn.alpha = 0.4;
    }else{
        _leftBtn.alpha = 0.4;
        _rightBtn.alpha = 0.4;
    }
}

- (void)nextPage:(UIButton*)button
{
    float next_X = _collectionView.contentOffset.x + (cellWidth+itemSpacing);
    [_collectionView setContentOffset:CGPointMake(next_X, 0) animated:YES];
    //set后collectionView的contentOffset.x的值还未改变，判断时多考虑一个单元
    if(_collectionView.contentOffset.x > (_collectionView.contentSize.width-(cellWidth+itemSpacing)*5/2)){
        _leftBtn.alpha = 0.4;
        _rightBtn.alpha = 0;
    }else{
        _leftBtn.alpha = 0.4;
        _rightBtn.alpha = 0.4;
    }
}

#pragma mark - CollectionView Delegate & Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLNewBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SLNewBookCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SLNewBookCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 400)];
    }
    SLSearchBookCellViewModel *viewModel = [self.viewModelArray objectAtIndex:indexPath.row];
    [cell bindViewModel:viewModel];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 10.f;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _pageControl.currentPage = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(cardPage:didSelectItemAtIndexPath:)]) {
        [self.delegate cardPage:self didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x+self.bounds.size.width/2)/cellWidth;
    _pageControl.currentPage = index;
    //滑动过程中不显示左右翻页按钮
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _leftBtn.alpha = 0;
    _rightBtn.alpha = 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //滑动结束时显示
    int index = (scrollView.contentOffset.x+self.bounds.size.width/2)/(cellWidth+itemSpacing);
    if (index == 0){
        _leftBtn.alpha = 0;
        _rightBtn.alpha = 0.4;
    }else if(index == (_itemNumber-1)){
        _leftBtn.alpha = 0.4;
        _rightBtn.alpha = 0;
    }else{
        _leftBtn.alpha = 0.4;
        _rightBtn.alpha = 0.4;
        
    }
    
}



@end
