//
//  AccountTool.h
//  cbs
//
//  Created by 祝健 on 15/12/6.
//  Copyright © 2015年 cyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountTool : NSObject 

@property (nonatomic, readonly) Account *account;

+ (AccountTool *)sharedAccountTool;

- (void)saveAccount:(Account *)account;

@end
