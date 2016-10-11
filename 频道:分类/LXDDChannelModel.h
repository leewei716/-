//
//  LXDDChannelModel.h
//   一起留学
//
//  Created by will on 16/8/13.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXDDChannelModel : NSObject
@property (nonatomic, copy) NSString *tname2;
@property (nonatomic, copy) NSString *tid2;
@property (nonatomic, copy, readonly) NSString *urlString2;
+ (instancetype)channelWithDict2:(NSDictionary *)dict2;
+ (NSArray *)channel2;
@end
