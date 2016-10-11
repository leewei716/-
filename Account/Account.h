//
//  Account.h
//  cbs
//
//  Created by 祝健 on 15/12/6.
//  Copyright © 2015年 cyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>
//头像
@property (nonatomic, copy) NSString    *HEADPIC;
@property (nonatomic, copy) NSString    *MEMBERID;
//电话号码
@property (nonatomic, copy) NSString    *MOBILENUM;
//密码
@property (nonatomic, copy) NSString    *PASSWORD;
//真实姓名
@property (nonatomic, copy) NSString    *TRUENAME;



- (id)initWithDict:(NSDictionary *)dict;

+ (id)accountWithDict:(NSDictionary *)dict;

@end
