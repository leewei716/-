//
//  DDChannelCell.m
//  DDNews
//
//  Created by Dvel on 16/4/7.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "DDChannelCell.h"
#import "LXCountryForumController.h"

#import "UIView+Extension.h"

@implementation DDChannelCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
//		NSLog(@"%s", __func__);
	}
	return self;
}

- (void)setUrlString:(NSString *)urlString
{
	_urlString = urlString;
    _CountryForum=[[LXCountryForumController alloc]init];
    _CountryForum.view.y = self.contentView.y;
    _CountryForum.view.x = self.contentView.x;
    _CountryForum.view.width = self.contentView.width;
    _CountryForum.view.height = self.contentView.height-kTabBarHeight;
    _CountryForum.urlString = urlString;
	[self addSubview:_CountryForum.view];
}

@end
