//
//  CFCycleView_.m
//  CFCycleView
//
//  Created by MountainCao on 2017/8/24.
//  Copyright © 2017年 深圳中业兴融互联网金融服务有限公司. All rights reserved.
//

#import "CFCycleView_.h"

@interface CFCycleView_ ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray      *imageArray;
@property (nonatomic, assign) NSInteger    currentPage;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *leftImageView;

@end

@implementation CFCycleView_

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        self.scrollView.contentSize = CGSizeMake(3*CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        
        self.imageArray = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
        
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        [self.scrollView addSubview:self.rightImageView];
        
        self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        [self.scrollView addSubview:self.centerImageView];
        
        self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)*2, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        [self.scrollView addSubview:self.leftImageView];
        

        [self showImage];
        
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == 0) {
        if (self.currentPage == 0) {
            self.currentPage = self.imageArray.count-1;
        } else {
            self.currentPage -=1;
        }
        
    } else if (scrollView.contentOffset.x == 2*CGRectGetWidth(self.bounds)) {
        
        if (self.currentPage == self.imageArray.count-1) {
           self.currentPage = 0;
        } else {
            self.currentPage +=1;
        }
    }
    scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
    
    [self showImage];
}

- (void)showImage {
    
    self.rightImageView.image = [UIImage imageNamed:self.imageArray[[self lastPage]]];
    self.centerImageView.image = [UIImage imageNamed:self.imageArray[self.currentPage]];
    self.leftImageView.image = [UIImage imageNamed:self.imageArray[[self nextPage]]];
}

- (NSInteger)nextPage {
    
    if (self.currentPage == self.imageArray.count-1) {
        return 0;
    }
    return self.currentPage+1;
}

- (NSInteger)lastPage {
    
    if (self.currentPage == 0) {
        return self.imageArray.count-1;
    }
    return self.currentPage-1;
}


@end
