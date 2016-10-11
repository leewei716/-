//
//  LXUserAgreementController.m
//   一起留学
//
//  Created by will on 16/9/1.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXUserAgreementController.h"

@interface LXUserAgreementController ()

@end

@implementation LXUserAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"用户协议";
    self.view.backgroundColor=[UIColor whiteColor];
    UIWebView *web=[[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    web.backgroundColor=[UIColor whiteColor];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [self.view addSubview:web];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
