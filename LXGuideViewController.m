//
//  LXGuideViewController.m
//   
//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXGuideViewController.h"
#import "LXMainViewController.h"

@interface LXGuideViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *pageView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong)NSArray *guideArr;
@end

@implementation LXGuideViewController
+ (instancetype)shareGuideVC
{
    static LXGuideViewController *shareGuideVC;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareGuideVC = [[LXGuideViewController alloc] init];
    });
    return shareGuideVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBarHidden=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    _guideArr = @[@"11", @"22", @"33"];
    _pageView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _pageView.pagingEnabled = YES;
    _pageView.showsHorizontalScrollIndicator = NO;
    _pageView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 3, CGRectGetHeight(self.view.frame));
    _pageView.bounces = NO;
    _pageView.delegate = self;
    [self.view addSubview:_pageView];
    for (NSInteger i = 0; i < 3; i ++) {
        NSString *imageName = _guideArr[i];
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        view.image = [UIImage imageNamed:imageName];
        [_pageView addSubview:view];
        
        if (i == 2) {
            UIButton *enterButton = [[UIButton alloc] init];
            [enterButton setBackgroundColor:[UIColor clearColor]];
            [enterButton setFrame:CGRectMake(self.view.frame.size.width/5, self.view.frame.size.height - 100, self.view.frame.size.width/2, 35)];
            enterButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 70);
            [enterButton setTitle:@"立即开启" forState:UIControlStateNormal];
            enterButton.titleLabel.font = [UIFont systemFontOfSize:18];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            enterButton.layer.cornerRadius = 5;
            enterButton.layer.borderWidth = 2;
            enterButton.layer.borderColor = [UIColor whiteColor].CGColor;
            enterButton.layer.masksToBounds = YES;
            [enterButton addTarget:self action:@selector(touchEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            view.userInteractionEnabled = YES;
            [view addSubview:enterButton];
        }
    }
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 20, self.view.frame.size.width, 20)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 3;
    _pageControl.userInteractionEnabled = NO;
    [self.view addSubview:_pageControl];
    
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) +1;
    _pageControl.currentPage = page;
    [_pageView setContentOffset:CGPointMake(page * self.view.frame.size.width, 0)];
}

- (void)touchEnterButton:(id)sender
{
    LXMainViewController *main=[[LXMainViewController alloc]init];
    [self.navigationController pushViewController:main animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
