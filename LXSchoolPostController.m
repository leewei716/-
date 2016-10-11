//
//  LXSchoolPostController.m
//   一起留学
//
//  Created by will on 16/9/7.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXSchoolPostController.h"

@interface LXSchoolPostController ()

@end

@implementation LXSchoolPostController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self hideTabBar];

}
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"大学帖子";
    self.view.backgroundColor=[UIColor whiteColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
