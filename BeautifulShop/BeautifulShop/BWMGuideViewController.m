//
//  BWMGuideViewController.m
//  BeautifulShop
//
//  Created by btw on 15/3/10.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMGuideViewController.h"
#import "BWMSystemConfigurationManager.h"
#import "CEExplodeAnimationController.h"
#import "SwipeView.h"
#import "UIColorFactory.h"

@interface BWMGuideViewController () <SwipeViewDataSource, SwipeViewDelegate, UIViewControllerTransitioningDelegate> {
    CEReversibleAnimationController *_animationController;
    SwipeView *_swipeView;
    NSArray *_guideImages;
}
@end

@implementation BWMGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0 && version < 8.0) {
        self.transitioningDelegate = self;
        _animationController = [[CEExplodeAnimationController alloc] init];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:201/255.0 green:62/255.0 blue:125/255.0 alpha:1.0f];
    
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Guide0%d", i]];
        [imagesArray addObject:image];
    }
    _guideImages = imagesArray;
    
    CGRect frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    _swipeView = [[SwipeView alloc] initWithFrame:frame];
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    _swipeView.alignment = SwipeViewAlignmentCenter;
    _swipeView.truncateFinalPage = YES;
    [self.view addSubview:_swipeView];
}

#pragma mark- SwipeViewDataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return _guideImages.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:swipeView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        view = imageView;
    }
    
    ((UIImageView*)view).image = _guideImages[index];
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return swipeView.frame.size;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    if (swipeView.numberOfItems-1 == index) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:^{
            [[BWMSystemConfigurationManager sharedSystemConfigurationManager] setNotFirstLaunching];
        }];
    }
}

#pragma mark- Animationing
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _animationController.reverse = YES;
    return _animationController;
}

@end
