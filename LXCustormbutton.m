//
//  LXCustormbutton.m
//   一起留学
//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXCustormbutton.h"

@implementation LXCustormbutton
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self setbutton];
        
    }
    return self;
}


-(void)setbutton{

    _img=[[UIImageView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(33), FLEXIBLE_NUMY(10),  FLEXIBLE_NUMX(40), FLEXIBLE_NUMY(40))];
      [self addSubview:_img];
    
    _title=[[UILabel alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(25),FLEXIBLE_NUMY(50), FLEXIBLE_NUMX(60), FLEXIBLE_NUMY(25))];
    _title.font=[UIFont systemFontOfSize:14];
    _title.textAlignment=1;
    [self addSubview:_title];
    
}
@end
