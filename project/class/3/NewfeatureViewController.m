//
//  NewfeatureViewController.m
//  project
//
//  Created by lanou3g on 15/11/3.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "NewfeatureViewController.h"
#import "MenuViewController.h"
@interface NewfeatureViewController ()<UIScrollViewDelegate>
@property(nonatomic,weak)UIPageControl * pageControl;

@end

@implementation NewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self setupScrollView];
    
    [self setupPageControl];
    
    
}
- (void)setupScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    for (int i=1; i<5;i++) {
        UIImageView * imgView = [[UIImageView alloc] init];
        NSString * name = [NSString stringWithFormat:@"%d%d%d%d.jpg",i,i,i,i];
        imgView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imgView];
        imgView.y = 0;
        imgView.x = (i-1)*scrollView.width;
        imgView.width = scrollView.width;
        imgView.height = scrollView.height;
        // 添加按钮
        if (i == 4) {
            [self setupLastImageView:imgView];
        }
    }
    scrollView.contentSize = CGSizeMake(4*scrollView.width, scrollView.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = SLPColor;
}
- (void)setupPageControl
{
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 4;
    pageControl.centerX = self.view.width*0.5;
    pageControl.centerY = self.view.height-20;
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:253 green:98 blue:42 alpha:1];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:189 green:189 blue:189 alpha:1];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)setupLastImageView:(UIImageView *)imgView
{
    imgView.userInteractionEnabled = YES;
    [self setupStartButton:imgView];
}
- (void)setupStartButton:(UIImageView *)imgView
{
    UIButton * btn = [[UIButton alloc] init];
    imgView.userInteractionEnabled = YES;
    [imgView addSubview:btn];
    btn.backgroundColor = SLPTitleColor;
    btn.title = @"立即体验";
    btn.size = CGSizeMake(80, 35);
    btn.centerX = self.view.width*0.5;
    btn.centerY = self.view.height*0.9;
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 10;
    [btn addTarget:self action:@selector(start) forControlEvents:(UIControlEventTouchUpInside)];

}
- (void)start
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuViewController *RootVC = story.instantiateInitialViewController;
    window.rootViewController = RootVC;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat doublePage = scrollView.contentOffset.x/scrollView.width;
    int intPage = (int)(doublePage +0.5);
    self.pageControl.currentPage = intPage;
}
@end
