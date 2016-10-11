//
//  LXDDSortCell_first.m
//   一起留学
//
//  Created by will on 16/8/13.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXDDSortCell_first.h"

@implementation LXDDSortCell_first
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_button];
    }
    return self;
}
@end
