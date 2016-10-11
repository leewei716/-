//
//  NSDate+LWExtension.h
//   一起留学
//
//  Created by will on 16/8/9.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LWExtension)
//
+ (NSDate *)currentDate:(NSDate *)date;
// 比较self和from的时间差
- (NSDateComponents *)deltaFrom:(NSDate *)from;
// 是否是今年
- (BOOL)isThisYear;
// 是否是今天
- (BOOL)isThisDay;
// 是否是昨天
- (BOOL)isThisYesterday;
@end
