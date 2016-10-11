//
//  LXDDChannelModel.m
//   一起留学
//
//  Created by will on 16/8/13.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXDDChannelModel.h"

@implementation LXDDChannelModel
+ (instancetype)channelWithDict2:(NSDictionary *)dict2
{
    id obj = [[self alloc] init];
    
    NSArray *array = @[@"tname2", @"tid2"];
    [array enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        if (dict2[key]) {
            [obj setValue:dict2[key] forKey:key];
        }
    }];
    return obj;
}
+ (NSArray *)channel2
{
    // 频道列表没从网上获取，直接用了网易新闻bundle里的这个文件。
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"topic_news111.json" withExtension:nil];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSArray *array = dict[@"tList"];
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayM addObject:[self channelWithDict2:obj]];
    }];
    
    return [arrayM sortedArrayUsingComparator:^NSComparisonResult(LXDDChannelModel *obj1, LXDDChannelModel *obj2) {
        return [obj1.tid2 compare:obj2.tid2];
    }];
}


- (void)setTid2:(NSString *)tid2 {
    _tid2 = tid2.copy;
    _urlString2 = [NSString stringWithFormat:@"article/headline/%@/0-20.html", tid2];
}


- (NSString *)description2 {
    NSDictionary *dict = [self dictionaryWithValuesForKeys:@[@"tname2", @"tid2"]];
    return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, dict];
}
@end
