//
//  LXLoginController.m
//   一起留学
//
//  Created by will on 16/7/18.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXLoginController.h"
#import "LXRegisterViewController.h"
#import "LXForgetPsdViewController.h"
#import "LXTabbarViewController.h"
#import "CheckStringClass.h"
#import "SVProgressHUD.h"
#import "HttpTool.h"
#import "AccountTool.h"


#import "SPKitExample.h"
#import "SPUtil.h"
#import <YWExtensionForCustomerServiceFMWK/YWExtensionForCustomerServiceFMWK.h>

@interface LXLoginController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *titelView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *passWordFld;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

/**
 *  获取随机游客账号
 */
- (void)_getVisitorUserID:(NSString **)aGetUserID password:(NSString **)aGetPassword;
@end


/// for iPad
@interface LXLoginController ()
<UISplitViewControllerDelegate>

@property (nonatomic, weak) UINavigationController *weakDetailNavigationController;

@end


@implementation LXLoginController
#pragma mark - public

+ (void)getLastUserID:(NSString *__autoreleasing *)aUserID lastPassword:(NSString *__autoreleasing *)aPassword
{
    if (aUserID) {
        *aUserID = [self lastUserID];
    }
    
    if (aPassword) {
        *aPassword = [self lastPassword];
    }
}

#pragma mark - private

- (void)_getVisitorUserID:(NSString *__autoreleasing *)aGetUserID password:(NSString *__autoreleasing *)aGetPassword
{
    if (aGetUserID) {
        *aGetUserID = [NSString stringWithFormat:@"visitor%d", arc4random()%1000+1];
    }
    
    if (aGetPassword) {
        *aGetPassword = [NSString stringWithFormat:@"taobao1234"];
    }
}
- (void)_presentSplitControllerAnimated:(BOOL)aAnimated
{

        [self.view.window.rootViewController isKindOfClass:[UISplitViewController class]];

}

- (void)_pushMainControllerAnimated:(BOOL)aAnimated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self _presentSplitControllerAnimated:aAnimated];
    } else {
        if ([self.view.window.rootViewController isKindOfClass:[LXTabbarViewController class]]) {
            /// 已经进入主页面
            return;
        }
        
        LXTabbarViewController *tabController = [[LXTabbarViewController alloc] init];
        tabController.view.frame = self.view.window.bounds;
        [UIView transitionWithView:self.view.window
                          duration:0.25
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.view.window.rootViewController = tabController;
                        }
                        completion:nil];
    }
}

- (void)_tryLogin
{
    __weak typeof(self) weakSelf = self;
    
    [[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:self.description];
    
    //这里先进行应用的登录
    
    //应用登陆成功后，登录IMSDK
    [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:self.phoneNumber.text
                                                                           passWord:self.passWordFld.text
                                                                    preloginedBlock:^{
                                                                        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
                                                                        [weakSelf _pushMainControllerAnimated:YES];
                                                                    } successBlock:^{
                                                                        
                                                                        //  到这里已经完成SDK接入并登录成功，你可以通过exampleMakeConversationListControllerWithSelectItemBlock获得会话列表
                                                                        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
                                                                        
                                                                        [weakSelf _pushMainControllerAnimated:YES];
#if DEBUG
                                                                        // 自定义轨迹参数均为透传
                                                                        //                                                                        [YWExtensionServiceFromProtocol(IYWExtensionForCustomerService) updateExtraInfoWithExtraUI:@"透传内容" andExtraParam:@"透传内容"];
#endif
                                                                    } failedBlock:^(NSError *aError) {
                                                                        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
                                                                        
                                                                        if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
                                                                            
                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                
                                                                                [SVProgressHUD showErrorWithStatus:@"登录失败"];
                                                                            });
                                                                        }
                                                                        
                                                                    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
//   开始动画效果
    if (_titelView.height>0&&_loginView.height>0) {
        _titelView.frame=CGRectMake(0, -500, _titelView.width, _titelView.height);
        _loginView.frame=CGRectMake(0, 700, _loginView.width, _loginView.height);
    }
    [UIView animateWithDuration:1.5 animations:^{
//        [self.view layoutIfNeeded];
        [self.view layoutSubviews];
      }];

    _phoneNumber.delegate=self;
    _passWordFld.delegate=self;
    BOOL shouldAutoLogin = NO;
    NSString *userID = [LXLoginController lastUserID];
    NSString *password = nil;
    if (userID) {
        password = [LXLoginController lastPassword];
    }
    else {
        shouldAutoLogin = NO;
        [self _getVisitorUserID:&userID password:&password];
    }
    
    if ([SPKitExample sharedInstance].lastConnectionStatus == YWIMConnectionStatusForceLogout || [SPKitExample sharedInstance].lastConnectionStatus == YWIMConnectionStatusMannualLogout) {
        /// 被踢或者登出后，不要自动登录
        shouldAutoLogin = NO;
    }
    
    [self.phoneNumber setText:userID];
    [self.passWordFld setText:password];
    [self _addNotifications];

    if (shouldAutoLogin && self.phoneNumber.text.length > 0 && self.passWordFld.text.length > 0) {
        LXTabbarViewController *main=[LXTabbarViewController alloc];
        [self.navigationController pushViewController:main animated:YES];
        [self _tryLogin];
    }

    
}
- (void)_addNotifications
{
    /// 监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)onApplicationDidBecomeActiveNotification:(NSNotification *)aNote
{
    [[SPKitExample sharedInstance] exampleGetFeedbackUnreadCount:YES inViewController:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[SPKitExample sharedInstance] exampleGetFeedbackUnreadCount:YES inViewController:self];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;


}
- (IBAction)LoginBtnClick:(id)sender {
    if ([CheckStringClass isMobileNumber:_phoneNumber.text] && [CheckStringClass isPwdNumber:_passWordFld.text]) {
        
        [HttpTool postWithBaseURL:[NSString stringWithFormat:@"%@%@", BASE_URL, MEMBER_REG] params:@{@"mobileNum":_phoneNumber.text, @"password":[CheckStringClass md5:_passWordFld.text]} success:^(id responseObject) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 1) {
                NSLog(@"登录成功:%@", responseObject);
                AccountTool *accountTool = [[AccountTool alloc] init];
                Account *account = [[Account alloc] initWithDict:responseObject];
                account.PASSWORD = [CheckStringClass md5:_passWordFld.text];
                [accountTool saveAccount:account];
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                LXTabbarViewController *main=[LXTabbarViewController alloc];
                [self.navigationController pushViewController:main animated:YES];
            }
            else {
                
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"登录失败:%@", error);
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
            
        }];
    } else {
        NSLog(@"手机号或密码输入有误!");
        [SVProgressHUD showErrorWithStatus:@"手机号或密码输入有误!"];
    }
}


- (IBAction)forgetBtn:(id)sender {
    
    LXForgetPsdViewController *ee=[[LXForgetPsdViewController alloc]init];
    [self.navigationController pushViewController:ee animated:YES];
    
}
- (IBAction)registBtn:(id)sender {
    
    LXRegisterViewController *qw=[[LXRegisterViewController alloc]init];
    [self.navigationController pushViewController:qw animated:YES];

    
}
- (IBAction)WeiXinBtn:(id)sender {
    [self.view endEditing:YES];
    
    [LXLoginController setLastUserID:self.phoneNumber.text];
    [LXLoginController setLastPassword:self.passWordFld.text];
    
    [self _tryLogin];


}


#pragma mark - properties

+ (NSString *)lastUserID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUserID"];
}

+ (void)setLastUserID:(NSString *)lastUserID
{
    [[NSUserDefaults standardUserDefaults] setObject:lastUserID forKey:@"lastUserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)lastPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPassword"];
}

+ (void)setLastPassword:(NSString *)lastPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:lastPassword forKey:@"lastPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)backBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
            CGRect rect = CGRectMake(0.0f, -120,width,height);
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
    // Dispose of any resources that can be recreated.
}






//- (IBAction)actionLogoutiPad:(id)sender
//{
//    [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
//    [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
//}
//
//- (IBAction)actionCloseiPad:(id)sender
//{
//    [self.weakDetailNavigationController popToRootViewControllerAnimated:NO];
//}

- (IBAction)actionVisitor:(id)sender {
    NSString *userID = nil, *password = nil;
    [self _getVisitorUserID:&userID password:&password];
    
    [self.phoneNumber setText:userID];
    [self.passWordFld setText:password];
    
    [self WeiXinBtn:nil];
}
- (IBAction)actionOpenFeedback:(UIButton *)sender
{
    [[SPKitExample sharedInstance] exampleSetProfile];
    
    [[SPKitExample sharedInstance] exampleOpenFeedbackViewController:YES fromViewController:self];
}


#pragma mark - UISplitViewController delegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation  NS_DEPRECATED_IOS(5_0, 8_0, "Use preferredDisplayMode instead")
{
    return NO;
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self actionVisitor:nil];
    }
}

@end
