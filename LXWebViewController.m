//
//  LXWebViewController.m
//   一起留学
//
//  Created by will on 16/8/6.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXWebViewController.h"

@interface LXWebViewController ()

@end

@implementation LXWebViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"留学广告信息";
    _web=[[UIWebView alloc]initWithFrame:CGRectMake(0  , 0, self.view.width, self.view.height)];
    _web.backgroundColor=[UIColor whiteColor];
    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_stringurl]]];
    [self.view addSubview:_web];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
