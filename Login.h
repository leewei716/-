//
//  Login.h
//  cbs
//
//  Created by 祝健 on 16/1/7.
//  Copyright © 2016年 cyb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Success)(id result);
typedef void (^Failure)(NSError *error);

@interface Login : NSObject

+ (void)autoLoginSuccess:(Success)success failure:(Failure)failure;

@end
