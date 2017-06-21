//
//  CFCycleView.h
//  CFCycleView
//
//  Created by Apple.Cao on 2017/6/21.
//  Copyright © 2017年 Apple.Cao. All rights reserved.
//

#define kCycleTimerInterval 3

#import <UIKit/UIKit.h>

@interface CFCycleView : UIView

- (void)setLocationImageArray:(NSArray *)imageArray;

- (void)setRemoteImageArray:(NSArray *)imageArray placeholderImage:(NSString *)placeholder;

@property (nonatomic, copy) void (^selectedImageIndex)(NSInteger index);

@end
