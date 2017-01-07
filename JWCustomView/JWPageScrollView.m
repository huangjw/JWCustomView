//
//  JWPageScrollView.m
//  ScrollView
//
//  Created by HuangJiawei on 15/10/26.
//  Copyright © 2015年 HuangJiawei. All rights reserved.
//

#import "JWPageScrollView.h"
//#import "UIImageView+WebCache.h"

@interface JWPageScrollView() <UIScrollViewDelegate>

@property (nonatomic, strong)   UIScrollView    *scrollView;
@property (nonatomic, strong)   UIPageControl   *pageControl;
@property (nonatomic, strong)   NSTimer         *scrolltTimer;

@end

@implementation JWPageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.userInteractionEnabled = YES;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        CGRect pFrame = frame;
        pFrame.origin.y = frame.size.height + self.frame.origin.y - 20;
        pFrame.size.height = 20;
        _pageControl = [[UIPageControl alloc] initWithFrame:pFrame];
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
        _duration = 8.0;
    }
    return self;
}

- (void)setImages:(NSArray *)images
{
    [self setupScrollView:images isURL:NO];
}

- (void)setImageURLs:(NSArray *)imageURLs
{
    [self setupScrollView:imageURLs isURL:YES];
}

- (void)setupScrollView:(NSArray *)images isURL:(BOOL)isURL
{
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    _images = images;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _scrollView.contentSize = CGSizeMake(width * (images.count + 2), height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = images.count;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.userInteractionEnabled = YES;
    
    if (images.count == 1) {
        _scrollView.contentSize = CGSizeMake(width, height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self setImageView:imageView withString:[images firstObject] isURL:isURL];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
        return;
    }
    for (NSInteger i = 0; i < images.count + 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        if (i == 0) {
//            imageView.image = [UIImage imageNamed:[images lastObject]];
            [self setImageView:imageView withString:[images lastObject] isURL:isURL];
            imageView.tag = 100 + images.count - 1;
        }
        else if (i == images.count + 1) {
//            imageView.image = [UIImage imageNamed:[images firstObject]];
            [self setImageView:imageView withString:[images firstObject] isURL:isURL];
            imageView.tag = 100;
        }
        else {
//            imageView.image = [UIImage imageNamed:[images objectAtIndex:i - 1]];
            [self setImageView:imageView withString:[images objectAtIndex:i - 1] isURL:isURL];
            imageView.tag = 100 + i - 1;
        }
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    [_scrollView setContentOffset:CGPointMake(width, 0)];
    _scrolltTimer = [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_scrolltTimer forMode:NSRunLoopCommonModes];
}

- (void)setImageView:(UIImageView *)img withString:(NSString *)string isURL:(BOOL)isURL
{
    if (isURL) {
//        [img sd_setImageWithURL:[NSURL URLWithString:string]];
    }
    else {
        img.image = [UIImage imageNamed:string];
    }
}

- (void)scroll
{
    NSInteger page = self.pageControl.currentPage + 1;
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * (page + 1);
    bounds.origin.y = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_scrollView scrollRectToVisible:bounds animated:YES];
    _pageControl.currentPage = page;
    [UIView commitAnimations];
}

- (void)dealloc
{
    if ([_scrolltTimer isValid]) {
        [_scrolltTimer invalidate];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.frame.size.width;
    NSInteger page = (_scrollView.contentOffset.x - pageWidth) / pageWidth + 1;
    if (page ==  (_images.count + 1)) {
        [_scrollView setContentOffset:CGPointMake(pageWidth,0) animated:NO];
        _pageControl.currentPage = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //手动滚动时暂停计时器
    if ([_scrolltTimer isValid]) {
        [_scrolltTimer invalidate];
    }
    CGFloat pageWidth = self.frame.size.width;
    NSUInteger page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    //滚动到最后一页视图时，重设pagecontrol的当前页和contentoffset（与第一张图片相同）
    if (page == _images.count + 1) {
        _pageControl.currentPage = 0;
        [self.scrollView setContentOffset:CGPointMake(pageWidth, 0) animated:NO];
    }
    //滚动到第一页视图时，重设pagecontrol的当前页和contentoffset（与最后一张图片相同）
    else if (page == 0) {
        _pageControl.currentPage = _images.count- 1;
        [self.scrollView setContentOffset:CGPointMake(pageWidth * _images.count, 0) animated:NO];
    }
    else {
        _pageControl.currentPage = page - 1;
    }
    _scrolltTimer = [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_scrolltTimer forMode:NSRunLoopCommonModes];
}

- (void)tapImage:(UIGestureRecognizer *)reco
{
    if ([_delegate respondsToSelector:@selector(imageTap:)]) {
        [_delegate imageTap:reco.view.tag - 100];
    }
}

@end
