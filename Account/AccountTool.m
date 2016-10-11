//
//  AccountTool.m
//  cbs
//
//  Created by 祝健 on 15/12/6.
//  Copyright © 2015年 cyb. All rights reserved.
//

#import "AccountTool.h"
#define kAccountFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0] stringByAppendingString:@"/account.data"]

@implementation AccountTool

// 单例创建三个条件
// 1、全局实例
static AccountTool *_instance;

// 2、类创建方法
+ (AccountTool *)sharedAccountTool {
    if (_instance) {
        _instance = [[self alloc] init];
    }
    return  [[self alloc] init];
}
// 3、重写alloc方法
+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)init {
    if (self = [super init]) {
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:kAccountFile];
    }
    return self;
}

- (void)saveAccount:(Account *)account {
    _account = account;
    [NSKeyedArchiver archiveRootObject:account toFile:kAccountFile];
}

@end
