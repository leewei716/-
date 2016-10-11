//
//  Login.m
//  cbs
//
//  Created by 祝健 on 16/1/7.
//  Copyright © 2016年 cyb. All rights reserved.
//

#import "Login.h"
#import "HttpTool.h"
#import "AccountTool.h"
#import "AFNetworking.h"

@interface Login ()
@end

@implementation Login

+ (void)autoLoginSuccess:(Success)success failure:(Failure)failure {
    AccountTool *accountTool = [[AccountTool alloc] init];
    if (accountTool.account.MOBILENUM.length > 0 && accountTool.account.PASSWORD.length > 0) {
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        manager.requestSerializer= [AFJSONRequestSerializer serializer];
        manager.responseSerializer= [AFJSONResponseSerializer serializer];
//        请求超时时间设置
        manager.requestSerializer.timeoutInterval = 15;
        [manager POST:[NSString stringWithFormat:@"%@%@", nil, nil] parameters:@{@"mobileNum":accountTool.account.MOBILENUM, @"password":accountTool.account.PASSWORD}
             progress:^(NSProgress * _Nonnull uploadProgress){} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"result"] integerValue] == 1) {
                NSLog(@"登录成功");
                AccountTool *accountTool = [[AccountTool alloc] init];
                NSString *temp = accountTool.account.PASSWORD;
                Account *account = [[Account alloc] initWithDict:responseObject];
                account.PASSWORD = temp;
                [accountTool saveAccount:account];
                
                success(@"1");
            } else {
                success(@"0");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    } else {
        success(@"0");
        
      }
}

@end
