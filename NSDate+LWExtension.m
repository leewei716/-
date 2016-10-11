//
//  NSDate+LWExtension.m
//   一起留学
//
//  Created by will on 16/8/9.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "NSDate+LWExtension.h"

@implementation NSDate (LWExtension)
+ (NSDate *)currentDate:(NSDate *)date{
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; //获得系统的时区
    NSTimeInterval time = [zone secondsFromGMTForDate:date];//以秒为单位返回当前时间与系统格林尼治时间的差
    NSDate *dateNow = [date dateByAddingTimeInterval:time];//然后把差的时间加上,就是当前系统准确的时间
    return dateNow;
}
// 比较self和from的时间差
- (NSDateComponents *)deltaFrom:(NSDate *)from{
    
    //    // 获取NSData的每一个元素
    //    NSInteger year = [calendar component:NSCalendarUnitYear fromDate:created];
    //    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:created];
    //    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:created];
    //    GHLog(@"%zd,%zd,%zd",year,month,day);
    // NSDateComponents获取NSData的元素集合
    //    NSDateComponents *cpt = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    //        GHLog(@"%zd,%zd,%zd",cpt.year,cpt.month,cpt.day);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *delta = [calendar components:unit fromDate:from toDate:self options:NSCalendarWrapComponents];
    return delta;
}
// 是否是今年
- (BOOL)isThisYear{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    return nowYear == selfYear;
}
// 是否是今天
// 第一种办法
- (BOOL)isThisDay{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    return [nowString isEqualToString:selfString];
}
// 第二种办法
//-(BOOL)isThisDay{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//    return (nowCmps.year == selfCmps.year &&
//            nowCmps.month == selfCmps.month &&
//            nowCmps.day == selfCmps.day);
//}
// 是否是昨天
- (BOOL)isThisYesterday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    // 转换时间格式
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    // 用日历比较时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *delta = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    return delta.year == 0 && delta.month == 0 && delta.day == 1;
}

@end
