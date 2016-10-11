//
//  PictureAddCell.m
//  一起留学
//
//  Created by will on 16/6/16.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "PictureAddCell.h"

@implementation PictureAddCell
{
    UIImageView *addImageView;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    addImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:addImageView];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    addImageView.frame = CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMY(75), FLEXIBLE_NUMY(75));
    addImageView.image = [UIImage imageNamed:@"添加图片"];
    
    
}


@end