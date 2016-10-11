//
//  LXDDChannelCell.m
//   一起留学
//
//  Created by will on 16/8/13.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXDDChannelCell.h"
#import "LXCollegeForumController.h"

#import "UIView+Extension.h"

@implementation LXDDChannelCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //		NSLog(@"%s", __func__);
    }
    return self;
}

- (void)setUrlString2:(NSString *)urlString2
{
    _urlString2 = urlString2;
    _CollegeForum=[[LXCollegeForumController alloc]init];
    _CollegeForum.view.y = self.contentView.y;
    _CollegeForum.view.x = self.contentView.x;
    _CollegeForum.view.width = self.contentView.width;
    _CollegeForum.view.height = self.contentView.height-kTabBarHeight;
    _CollegeForum.urlString2 = urlString2;
    [self addSubview:_CollegeForum.view];
}

@end
