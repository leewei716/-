//
//  LXNotificationController.m
//   一起留学
//
//  Created by will on 16/9/1.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXNotificationController.h"

@interface LXNotificationController ()

@property (weak, nonatomic) IBOutlet UIButton *newsBtn;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIButton *systemNewSBtn;

@end

@implementation LXNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"通知设置";
    self.view.backgroundColor=BackColor;
//    _newsBtn.selected=NO;
//    _replyBtn.selected=NO;
//    _systemNewSBtn.selected=NO;
    

}
static int a=1;
static int b=1;
static int c=1;
- (IBAction)newsClick:(id)sender {
       a++;
    if (a%2==0) {
        _newsBtn.selected=YES;
    }else  if(a%2==1){
        _newsBtn.selected= NO;
    }
}
- (IBAction)replyClick:(id)sender {
    b++;
    if (b%2==0) {
        _replyBtn.selected=YES;
    }else if(b%2==1){
        _replyBtn.selected=NO;
    }
    
}
- (IBAction)systemBtnClick:(id)sender {
    c++;
    if (c%2==0) {
        _systemNewSBtn.selected=YES;
    }else if (c%2==1){
        _systemNewSBtn.selected=NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
