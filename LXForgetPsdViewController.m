//
//  LXForgetPsdViewController.m
//   一起留学
//
//  Created by will on 16/7/23.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXForgetPsdViewController.h"
#import "HttpTool.h"
#import "SVProgressHUD.h"
#import "AccountTool.h"
#import "CheckStringClass.h"
#import "UIButton+Category.h"
@interface LXForgetPsdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberFld;
@property (weak, nonatomic) IBOutlet UITextField *SecurityCodeFld;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWordFld;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordFld;
@property (weak, nonatomic) IBOutlet UIButton *GetSecurityCodeBtn;

@end

@implementation LXForgetPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title=@"找回密码";
    self.view.backgroundColor=BackColor;
    _NewPassWordFld.delegate=self;
    _againPasswordFld.delegate=self;
}
- (IBAction)GetSecurityCode:(id)sender {
    if ([CheckStringClass isMobileNumber:_phoneNumberFld.text]) {
        [_GetSecurityCodeBtn startWithTime:60 title:@"获取验证码" countDownTitle:@"秒" mainColor:TabBarColor countColor:TabBarColor];
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
- (IBAction)sureBtnClick:(id)sender {
    if (_NewPassWordFld.text==_againPasswordFld.text) {
        if ([CheckStringClass isMobileNumber:_phoneNumberFld.text] && [CheckStringClass isPwdNumber:_NewPassWordFld.text]) {
            [HttpTool postWithBaseURL:[NSString stringWithFormat:@"%@%@", BASE_URL, MEMBER_REG] params:@{@"mobileNum":_phoneNumberFld.text, @"code":_SecurityCodeFld.text, @"password":[CheckStringClass md5:_NewPassWordFld.text]} success:^(id responseObject) {
                NSLog(@"%@", [CheckStringClass md5:_NewPassWordFld.text]);
                if ([[responseObject objectForKey:@"result"] integerValue] == 1) {
                    NSLog(@"找回密码成功:%@", responseObject);
                    AccountTool *accountTool = [[AccountTool alloc] init];
                    Account *account = [[Account alloc] initWithDict:responseObject];
                    account.PASSWORD = [CheckStringClass md5:_NewPassWordFld.text];
                    [accountTool saveAccount:account];
                    [SVProgressHUD showSuccessWithStatus:@"找回密码成功"];
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    NSLog(@"找回密码失败:%@", [responseObject objectForKey:@"message"]);
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
                }
            } failure:^(NSError *error) {
                
                NSLog(@"找回密码失败:%@", error);
                [SVProgressHUD showErrorWithStatus:@"找回密码失败"];
            }];
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码!"];
        }
    }else if(!(_NewPassWordFld.text==_againPasswordFld.text)){
        [SVProgressHUD  showErrorWithStatus:@"两次输入的密码不一致"];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
