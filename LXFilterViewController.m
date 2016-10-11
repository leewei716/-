//
//  LXFilterViewController.m
//   一起留学
//
//  Created by will on 16/7/17.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXFilterViewController.h"
#import "LXSchoolLocationController.h"
#import "LXLikeMajorController.h"

@interface LXFilterViewController ()

@end

@implementation LXFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackColor;
    self.navigationController.navigationBarHidden=YES;

}

- (IBAction)miss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)schoolLocation:(id)sender {
    LXSchoolLocationController  *location=[[LXSchoolLocationController alloc]init];
    [self.navigationController pushViewController:location animated:YES];
    
}
- (IBAction)likeProfessional:(id)sender {
    LXLikeMajorController  *like=[[LXLikeMajorController alloc]init];
    [self.navigationController pushViewController:like animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
