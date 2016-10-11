//
//  LXProfessionalIntroductionController.m
//   一起留学
//
//  Created by will on 16/7/19.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXProfessionalIntroductionController.h"

@interface LXProfessionalIntroductionController ()

@end

@implementation LXProfessionalIntroductionController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web=[[UIWebView alloc]init];
    if (ScreenHeight==480) {
        web.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(-20), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(268+20+24));
    }else if (ScreenHeight==568){
        web.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(-13), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(228+20+24));
    }else if (ScreenHeight==667){
        web.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(-8), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(188+20+24));
    }else{
        web.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(-8), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(168+20+24));
    }
    web.backgroundColor=[UIColor whiteColor];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [self.view addSubview:web];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
