//
//  Account.m
//  cbs
//
//  Created by 祝健 on 15/12/6.
//  Copyright © 2015年 cyb. All rights reserved.
//

#import "Account.h"

@implementation Account

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.HEADPIC         = dict[@"headPic"] ? dict[@"headPic"]:[NSString stringWithFormat:@"null"];
        self.TRUENAME        = dict[@"trueName"] ? dict[@"trueName"]:[NSString stringWithFormat:@"未设置"];
        self.MEMBERID        = [dict[@"memberId"] stringValue];
        self.MOBILENUM       = dict[@"mobileNum"];
          }
    return self;
}

+ (id)accountWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_HEADPIC forKey:@"headPic"];
    [aCoder encodeObject:_MEMBERID forKey:@"memberId"];
    [aCoder encodeObject:_PASSWORD forKey:@"passWord"];
    [aCoder encodeObject:_MOBILENUM forKey:@"mobileNum"];
    [aCoder encodeObject:_TRUENAME forKey:@"trueName"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.HEADPIC           = [aDecoder decodeObjectForKey:@"headPic"];
        self.MEMBERID          = [aDecoder decodeObjectForKey:@"memberId"];
        self.MOBILENUM         = [aDecoder decodeObjectForKey:@"mobileNum"];
        self.PASSWORD          = [aDecoder decodeObjectForKey:@"passWord"];
        
    }
    return self;
}

@end
