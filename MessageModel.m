//
//  MessageModel.m
//  一起留学
//
//  Created by will on 16/6/28.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "MessageModel.h"
#import "NSDate+LWExtension.h"
@implementation MessageModel
-(NSMutableArray *)commentModelArray{
    if (_commentModelArray==nil) {
        _commentModelArray = [NSMutableArray array];
    }
    return _commentModelArray;
}

-(NSMutableArray *)messageSmallPics{
    if (_messageSmallPics==nil) {
        _messageSmallPics = [NSMutableArray array];
    }
    return _messageSmallPics;
}

-(NSMutableArray *)messageBigPics{
    if (_messageBigPics==nil) {
        _messageBigPics = [NSMutableArray array];
    }
    return _messageBigPics;
}

-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cid                = dic[@"cid"];
        self.shouldUpdateCache  = NO;
        self.message_id         = dic[@"message_id"];
        self.message            = dic[@"message"];
        self.timeTag            = dic[@"timeTag"];
        self.message_type       = dic[@"message_type"];
        self.userId             = dic[@"userId"];
        self.userName           = dic[@"userName"];
        self.photo              = dic[@"photo"];
        self.messageSmallPics   = dic[@"messageSmallPics"];
        self.messageBigPics     = dic[@"messageBigPics"];
        self.commentNumber      = dic[@"commentNumber"];
        self.postTitle          = dic[@"postTitle"];
        self.lookNumber         = dic[@"lookNumber"];
        self.urlstring                =dic[@"urlstring"];
        for (NSDictionary *eachDic in dic[@"commentMessages"] ) {
            CommentModel *commentModel = [[CommentModel alloc] initWithDic:eachDic];
            [self.commentModelArray addObject:commentModel];
        }
    }
    return self;
}
- (NSString *)timeTag{
    /**
     时间格式
     *今年
     今天
     1分钟内 刚刚
     1小时内 xx分钟前
     xx小时前
     昨天
     昨天   xx：xx：xx
     其他
     xx月xx日 xx：xx：xx
     其他
     xxxx年xx月xx日 xx：xx：xx
     */
    // 当前时间
    NSDate *now = [NSDate date];
    //    服务器时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    // 设置日期格式(y:年 M：月 d：日 H：时 m：fen s：分)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 日历
    NSDate *created = [fmt dateFromString:_timeTag];
    if ([created isThisYear]) {
        // 是今年
        NSDateComponents *delta = [now deltaFrom:created];
        if ([created isThisDay]) {
            // 是今天
            if (delta.hour >= 1) {// 时间差距>= 1小时
                return [NSString stringWithFormat:@"%zd小时前",delta.hour];
            }else if (delta.minute >= 1){// 1分钟<= 时间差距 <1小时
                return [NSString stringWithFormat:@"%zd分钟前",delta.minute];
            }else{
                return @"刚刚";
            }
        }else if ([created isThisYesterday]){
            // 是昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:created];
        }else{
            // 今年其他
            fmt.dateFormat = @"MM月dd日 HH:mm:ss";
            return [fmt stringFromDate:created];
        }
    }else{
        // 往年其他
        fmt.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
        return [fmt stringFromDate:created];
    }
    
}

@end
