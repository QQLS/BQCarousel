//
//  BQCarousel.m
//  BQCarouselView
//
//  Created by QQLS on 2017/12/26.
//  Copyright © 2017年 QQLS. All rights reserved.
//

#import "BQCarousel.h"

#import "BQWeakTimer.h"

#import "UIImageView+WebCache.h"

@interface BQCarousel () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) BQWeakTimer *scrollTimer;

@end

@implementation BQCarousel

#pragma mark - Initial
+ (instancetype)carouselWithFrame:(CGRect)frame imageURLStrings:(NSArray *)imageURLStrings {
    
    return [[BQCarousel alloc] initWithFrame:frame imageURLStrings:imageURLStrings];
}

- (instancetype)initWithFrame:(CGRect)frame imageURLStrings:(NSArray *)imageURLStrings {
    
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        self.imageURLStrings = imageURLStrings;
    }
    return self;
}

- (void)initialization {
    
    _switchInterval = 3.f;
    
    _currentIndex = -1;
    
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.bounds) - 30.f, CGRectGetWidth(self.bounds), 20.f);
    
    CGFloat imageWidth = CGRectGetWidth(self.scrollView.bounds);
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    self.leftImageView.frame    = CGRectMake(imageWidth * 0, 0, imageWidth, imageHeight);
    self.middleImageView.frame  = CGRectMake(imageWidth * 1, 0, imageWidth, imageHeight);
    self.rightImageView.frame   = CGRectMake(imageWidth * 2, 0, imageWidth, imageHeight);
    self.scrollView.contentSize = CGSizeMake(imageWidth * 3, 0);
    
    [self setScrollViewContentOffsetCenter];
}

#pragma mark - Setter
- (void)setSwitchInterval:(NSTimeInterval)switchInterval {
    _switchInterval = switchInterval;
    
    [self createTimer];
}

- (void)setImageURLStrings:(NSArray *)imageURLStrings {
    
    if (imageURLStrings) {
        _imageURLStrings = imageURLStrings;
        self.currentIndex = 0;
        
        if (imageURLStrings.count > 1) {
            [self createTimer];
            
            self.pageControl.hidden = NO;
            self.pageControl.numberOfPages = imageURLStrings.count;
            self.pageControl.currentPage = self.currentIndex;
        } else {
            self.pageControl.hidden = YES;
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    if (currentIndex >= 0
        && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        
        // caculate index
        NSInteger imageCount = self.imageURLStrings.count;
        NSInteger leftIndex = (currentIndex + imageCount - 1) % imageCount;
        NSInteger rightIndex= (currentIndex + 1) % imageCount;
        
        // set image
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLStrings[leftIndex]]];
        [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLStrings[currentIndex]]];
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLStrings[rightIndex]]];
        
        // every scrolled, move current page to center
        [self setScrollViewContentOffsetCenter];
        
        self.pageControl.currentPage = currentIndex;
    }
}

#pragma mark - Helpers
- (void)createTimer {
    
    [self.scrollTimer stopTimer];
    self.scrollTimer = [BQWeakTimer scheduledTimerWithTimeInterval:self.switchInterval target:self selector:@selector(scrollTimerDidFired) userInfo:nil repeats:YES];
}

- (void)setScrollViewContentOffsetCenter {
    
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
}

#pragma mark - caculate currentIndex
- (void)caculateCurIndex {
    
    if (self.imageURLStrings.count > 0) {
        CGFloat pointX = self.scrollView.contentOffset.x;
        
        // judge critical value，first and third imageView's contentoffset
        CGFloat criticalValue = .2f;
        
        // scroll right, judge right critical value
        if (pointX > 2 * CGRectGetWidth(self.scrollView.bounds) - criticalValue) {
            self.currentIndex = (self.currentIndex + 1) % self.imageURLStrings.count;
        } else if (pointX < criticalValue) {
            // scroll left，judge left critical value
            self.currentIndex = (self.currentIndex + self.imageURLStrings.count - 1) % self.imageURLStrings.count;
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self caculateCurIndex];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.imageURLStrings.count > 1) {
        [self.scrollTimer pauseTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.imageURLStrings.count > 1) {
        [self.scrollTimer resumeTimer];
    }
}

#pragma mark - Action
- (void)imageDidClicked {
    
    if (self.didSelectedIndex) {
        self.didSelectedIndex(self.currentIndex);
    }
}

- (void)scrollTimerDidFired {
    
    // correct the imageview's frame, because after every auto scroll,
    // may show two images in one page.
    if (self.scrollView.contentOffset.x != CGRectGetWidth(self.scrollView.bounds)) {
        [self setScrollViewContentOffsetCenter];
    }
    
    // Scroll to next imageview.
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

#pragma mark - Lazy
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = UIColor.lightGrayColor;
        _pageControl.currentPageIndicatorTintColor = UIColor.purpleColor;
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}

- (UIImageView *)leftImageView {
    
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:self.leftImageView];
    }
    
    return _leftImageView;
}

- (UIImageView *)middleImageView {
    
    if (!_middleImageView) {
        _middleImageView = [[UIImageView alloc] init];
        _middleImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked)];
        [_middleImageView addGestureRecognizer:tap];
        [self.scrollView addSubview:self.middleImageView];
    }
    
    return _middleImageView;
}

- (UIImageView *)rightImageView {
    
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:self.rightImageView];
    }
    
    return _rightImageView;
}

#pragma mark - Lifecycle
- (void)dealloc {
    
    [self.scrollTimer stopTimer];
}

@end
