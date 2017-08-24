//
//  CFCycleView.m
//  CFCycleView
//
//  Created by Apple.Cao on 2017/6/21.
//  Copyright © 2017年 Apple.Cao. All rights reserved.
//

#define kBaseTag 10000

#import "CFCycleView.h"
#import "UIImageView+WebCache.h"

@interface CFCycleView ()<UIScrollViewDelegate>

@property (nonatomic, assign) CGRect    cycleViewFrame;
@property (nonatomic, strong) NSTimer   *timer;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat   currentOffset_X;
@property (nonatomic, assign) BOOL      remoteImage;
@property (nonatomic, copy) NSString    *placeholderImage;
@property (nonatomic, strong) UIPageControl *pageControl;


@end

@implementation CFCycleView

- (void)setLocationImageArray:(NSArray *)imageArray {
    
    self.count = imageArray.count+2;
    self.pageControl.numberOfPages = imageArray.count;
    self.scrollView.contentSize = CGSizeMake(self.cycleViewFrame.size.width * (self.count), self.cycleViewFrame.size.height);
    
    for (UIView *view in self.scrollView.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    for (int i=0; i<self.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.cycleViewFrame.size.width * i, 0, self.cycleViewFrame.size.width, self.cycleViewFrame.size.height)];
        
        if (i==0) {
            
            if (self.remoteImage) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[imageArray.count-1]] placeholderImage:[UIImage imageNamed:self.placeholderImage]];
            } else {
                imageView.image = [UIImage imageNamed:imageArray[imageArray.count-1]];
            }
            
        } else if (i==self.count-1) {
            
            if (self.remoteImage) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:[UIImage imageNamed:self.placeholderImage]];
            } else {
                imageView.image = [UIImage imageNamed:imageArray[0]];
            }
            
        } else {
            
            if (self.remoteImage) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i-1]] placeholderImage:[UIImage imageNamed:self.placeholderImage]];
            } else {
                imageView.image = [UIImage imageNamed:imageArray[i-1]];
            }
            imageView.userInteractionEnabled = YES;
            imageView.tag = kBaseTag + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerHeadler:)];
            [imageView addGestureRecognizer:tap];
        }
        [self.scrollView addSubview:imageView];
    }
    
    if (self.currentOffset_X > self.scrollView.contentSize.width - self.cycleViewFrame.size.width || self.currentOffset_X ==0) {
        [self.scrollView setContentOffset:CGPointMake(self.cycleViewFrame.size.width, 0)];
        self.pageControl.currentPage = 0;

    } else {
        [self.scrollView setContentOffset:CGPointMake(self.currentOffset_X, 0)];
        self.pageControl.currentPage = (int)((self.currentOffset_X-self.cycleViewFrame.size.width)/self.cycleViewFrame.size.width);
    }
}

- (void)setRemoteImageArray:(NSArray *)imageArray placeholderImage:(NSString *)placeholder {
    
    self.remoteImage = YES;
    self.placeholderImage = placeholder;
    [self setLocationImageArray:imageArray];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.cycleViewFrame = frame;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.cycleViewFrame.size.width, self.cycleViewFrame.size.height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.cycleViewFrame.size.height-25, self.cycleViewFrame.size.width, 20)];
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:self.pageControl];
        
    
    [self openTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.currentOffset_X = self.scrollView.contentOffset.x;
    if (self.currentOffset_X >= self.cycleViewFrame.size.width * (self.count-1)) {
        [self.scrollView setContentOffset:CGPointMake(self.cycleViewFrame.size.width, 0)];
        self.pageControl.currentPage = 0;
        self.currentOffset_X = self.scrollView.contentOffset.x;
    } else if (self.currentOffset_X <= 0) {
        [self.scrollView setContentOffset:CGPointMake(self.cycleViewFrame.size.width * (self.count-2), 0)];
        self.currentOffset_X = self.scrollView.contentOffset.x;
        self.pageControl.currentPage = self.count-2;
    } else {
        self.pageControl.currentPage = (int)((self.currentOffset_X-self.cycleViewFrame.size.width)/self.cycleViewFrame.size.width);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self dertoryTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self openTimer];
}

- (void)tapGestureRecognizerHeadler:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    if (self.selectedImageIndex) {
        self.selectedImageIndex(imageView.tag - kBaseTag-1);
    }
}

- (void)timerHeadler:(NSTimer *)timer {
    self.currentOffset_X += self.cycleViewFrame.size.width;
    [self.scrollView setContentOffset:CGPointMake(self.currentOffset_X, 0) animated:YES];
}

- (void)openTimer {
    
    [self dertoryTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kCycleTimerInterval target:self selector:@selector(timerHeadler:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)dertoryTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc
{
    
    [self dertoryTimer];
    
    NSLog(@"===%@",NSStringFromClass([self class]));
}

@end
