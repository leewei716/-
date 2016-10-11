//
//  LXDDChannelLabel.h
//   一起留学
//
//  Created by will on 16/8/15.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXDDChannelLabel : UILabel
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat textWidth;
+ (instancetype)channelLabelWithTitle:(NSString *)title;

@end
