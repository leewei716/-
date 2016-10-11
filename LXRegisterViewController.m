//
//  LXRegisterViewController.m
//   一起留学
//
//  Created by will on 16/7/23.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXRegisterViewController.h"
#import "LXUserAgreementController.h"
#import "HttpTool.h"
#import "SVProgressHUD.h"
#import "AccountTool.h"
#import "CheckStringClass.h"
#import "UIButton+Category.h"
@interface LXRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberFld;
@property (weak, nonatomic) IBOutlet UITextField *SecurityCodeFld;
@property (weak, nonatomic) IBOutlet UITextField *SetPassWordFld;
@property (weak, nonatomic) IBOutlet UIButton *agareBtn;
@property (weak, nonatomic) IBOutlet UIButton *SecurityCodeBtn;

@end

@implementation LXRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"注册";
    self.view.backgroundColor=BackColor;
  
    _SecurityCodeFld.delegate=self;
    _SetPassWordFld.delegate=self;
    _agareBtn.selected=YES;

}
- (IBAction)SendSecurityCode:(id)sender {
    if ([CheckStringClass isMobileNumber:_phoneNumberFld.text]) {
        [_SecurityCodeBtn startWithTime:60 title:@"获取验证码" countDownTitle:@"秒" mainColor:TabBarColor countColor:TabBarColor];
        [HttpTool postWithBaseURL:[NSString stringWithFormat:@"%@%@", BASE_URL, MEMBER_GETCODE] params:@{@"mobileNum":_phoneNumberFld.text, @"type":@"1"} success:^(id responseObject) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 1) {
                
                NSLog(@"短信发送成功:%@", responseObject);
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送!"];
            }
            else {
                NSLog(@"短信发送失败:%@", responseObject);
                [SVProgressHUD showErrorWithStatus:@"验证码发送失败!"];
            }
        } failure:^(NSError *error) {
            NSLog(@"短信发送失败:%@", error);
            [SVProgressHUD showErrorWithStatus:@"验证码发送失败!"];
        }];
    } else {
        NSLog(@"请输入正确的手机号码!");
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码!"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registBtn:(id)sender {
    if (_agareBtn.selected==YES) {
//      保存密码并注册
        
            if ([CheckStringClass isMobileNumber:_phoneNumberFld.text] && [CheckStringClass isPwdNumber:_SetPassWordFld.text]) {
                [HttpTool postWithBaseURL:[NSString stringWithFormat:@"%@%@", BASE_URL, MEMBER_REG] params:@{@"mobileNum":_phoneNumberFld.text, @"code":_SecurityCodeFld.text, @"password":[CheckStringClass md5:_SetPassWordFld.text]} success:^(id responseObject) {
                    NSLog(@"%@", [CheckStringClass md5:_SetPassWordFld.text]);
                    if ([[responseObject objectForKey:@"result"] integerValue] == 1) {
                        
                        NSLog(@"注册成功:%@", responseObject);
                        AccountTool *accountTool = [[AccountTool alloc] init];
                        Account *account = [[Account alloc] initWithDict:responseObject];
                        account.PASSWORD = [CheckStringClass md5:_SetPassWordFld.text];
                        
                        [accountTool saveAccount:account];
                        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                        
                    } else {
                        NSLog(@"注册失败:%@", [responseObject objectForKey:@"message"]);
                        [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
                    }
                } failure:^(NSError *error) {
                    
                    NSLog(@"注册失败:%@", error);
                    [SVProgressHUD showErrorWithStatus:@"注册失败"];
                }];
                
            } else {
                
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码!"];
          }
    }else if(_agareBtn.selected==NO){
        
        [SVProgressHUD showErrorWithStatus:@"请阅读并同意《一起留学用户协议》" maskType:SVProgressHUDMaskTypeBlack];
    }
}
//点击空白处，键盘收缩的处理
- (void)touchesBegan:(NSSet<UITouch * > *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}
//textfield随着键盘向上移动
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (ScreenWidth <=320) {
        CGRect frame = textField.frame;
        int offset = frame.origin.y +422 - (self.view.frame.size.height - 240);//键盘高度216
        NSLog(@"offset is %d",offset);
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        if(offset > 0)
        {
            CGRect rect = CGRectMake(0.0f, -60,width,height);
            self.view.frame = rect;
        }
        [UIView commitAnimations];
    }
}
//点击return按钮键盘收缩
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
static int i=1;
- (IBAction)agareBtnClick:(id)sender {
    i++;
    if (i%2==0) {
        _agareBtn.selected=YES;
    }else if(i%2==1){
        _agareBtn.selected=NO;
    }
}
- (IBAction)UserAgreementClick:(id)sender {
    LXUserAgreementController *user=[[LXUserAgreementController alloc]init];
    [self.navigationController pushViewController:user animated:YES];
}

@end
