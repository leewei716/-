//
//  CheckStringClass.h
//  一起留学
//
//  Created by will on 16/7/6.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckStringClass : NSObject
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isPwdNumber:(NSString *)password;
+ (NSString *)md5:(NSString *)str;
+ (NSString *)getIPAddress;
+ (NSString *)getCurrentTime;

@end
