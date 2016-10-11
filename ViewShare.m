//
//  ViewShare.m
//  QuHuWai
//
//  Created by wzkj on 15/5/11.
//  Copyright (c) 2015年 Wzkj. All rights reserved.
//

#import "ViewShare.h"
#define BUTTON_WIDTH 48
#define TITLE_HEIGHT 20
#define Y_CHINK 15
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define BUTTON_COLUMN 3
static ViewShare *instance=nil;

@implementation ViewShare
{
    UIView *bar;
    ViewShareBlock block;
    UIDynamicAnimator *Animator;
}
+(instancetype)Instance{
    if (instance==nil) {
        instance=[[ViewShare alloc] init];
        
    }
    return instance;
}
-(id)init{
    self=[super init];
    if (self) {
        self.frame=[UIScreen mainScreen].bounds;
        UITapGestureRecognizer *rec=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMiss)];
        [self addGestureRecognizer:rec];
    }
    return self;
}

-(void)showButtonArr:(NSArray *)buttons WithBlock:(ViewShareBlock)_block{
    block=_block;
    
    
    bar=[[UIView alloc] init];
    bar.backgroundColor=[UIColor clearColor];
    
    CGFloat x_chink=(SCREEN_WIDTH-BUTTON_COLUMN*BUTTON_WIDTH)/(BUTTON_COLUMN+1);
    int idx=0,column=0,row=0;
    for (NSDictionary *dic in buttons) {
        column=idx%BUTTON_COLUMN;
        if (column==0) {
            row=idx/BUTTON_COLUMN;
        }else{
            row=(idx-1)/BUTTON_COLUMN;
        }
        //NSLog(@"%d-%d",row,column);
        UIImage *imgN=[dic objectForKey:VIEWSHARE_IMG_N];
        UIImage *imgH=[dic objectForKey:VIEWSHARE_IMG_H];
        NSString *title=[dic objectForKey:VIEWSHARE_TITLE];
        
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_WIDTH)];
        button.tag=idx;
        [button setBackgroundImage:imgN forState:UIControlStateNormal];
        [button setBackgroundImage:imgH forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(click_button:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lb_title=[[UILabel alloc] initWithFrame:CGRectMake(-5, BUTTON_WIDTH, BUTTON_WIDTH+10, TITLE_HEIGHT)];
        lb_title.textAlignment=NSTextAlignmentCenter;
        lb_title.font=[UIFont systemFontOfSize:12];
        lb_title.textColor=[UIColor whiteColor];
        lb_title.text=title;
        
        UIView *buttonBack=[[UIView alloc] initWithFrame:CGRectMake(x_chink*(1+column)+BUTTON_WIDTH*column, Y_CHINK+(BUTTON_WIDTH+TITLE_HEIGHT+Y_CHINK)*row, BUTTON_WIDTH, BUTTON_WIDTH+TITLE_HEIGHT)];
        
        buttonBack.backgroundColor=[UIColor clearColor];
        [buttonBack addSubview:button];
        [buttonBack addSubview:lb_title];
        [bar addSubview:buttonBack];
        idx++;
    }
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(x_chink, Y_CHINK+(BUTTON_WIDTH+TITLE_HEIGHT+Y_CHINK)*(row+1),
                                                         BUTTON_COLUMN*BUTTON_WIDTH+(BUTTON_COLUMN-1)*x_chink, 1)];
    line.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    [bar addSubview:line];
    
    UIButton *bt_close=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-BUTTON_WIDTH)/2, (row+1)*(BUTTON_WIDTH+TITLE_HEIGHT+Y_CHINK)+Y_CHINK, BUTTON_WIDTH, BUTTON_WIDTH)];
    [bt_close setImage:[UIImage imageNamed:@"find_close_n"] forState:UIControlStateNormal];
    [bt_close setImage:[UIImage imageNamed:@"find_close_h"] forState:UIControlStateHighlighted];
    [bt_close addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:bt_close];
    
    CGRect frame=CGRectMake(0, 0, SCREEN_WIDTH, (row+1)*(BUTTON_WIDTH+TITLE_HEIGHT+Y_CHINK)+BUTTON_WIDTH+Y_CHINK);
    frame.origin.y=SCREEN_HEIGHT-frame.size.height;
    bar.frame=frame;
    [self addSubview:bar];
    
    UIWindow *win=[[UIApplication sharedApplication].windows lastObject];
    [win addSubview:self];
    
    Animator=[[UIDynamicAnimator alloc] initWithReferenceView:bar];
    for (UIView *buttonBack in bar.subviews) {
        if (buttonBack==line) {
            continue;
        }
        CGRect frame0=buttonBack.frame;
        CGRect frame1=buttonBack.frame;
        frame0.origin.y+=bar.frame.size.height;
        buttonBack.frame=frame0;
        
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:buttonBack snapToPoint:[self frameCenter:frame1]];
        // 随机振幅
        snap.damping = arc4random_uniform(3) / 10.0 + 0.5;
        // 添加仿真行为
        [Animator addBehavior:snap];
    }
    self.backgroundColor=[UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7];
    }];
}
-(CGPoint)frameCenter:(CGRect) frame{
    return CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
}
-(void)disMiss
{
    [Animator removeAllBehaviors];
    for (UIView *buttonBack in bar.subviews) {
        CGRect frame0=buttonBack.frame;
        frame0.origin.y+=bar.frame.size.height;
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:buttonBack snapToPoint:[self frameCenter:frame0]];
        // 随机振幅
        snap.damping = arc4random_uniform(3) / 10.0 + 0.5;
        // 添加仿真行为
        [Animator addBehavior:snap];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor=[UIColor clearColor];
    } completion:^(BOOL finished) {
        [bar removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}
-(void)click_button:(UIView *)bt
{
    if(block){
        block(bt.tag);
    }
    [self disMiss];
    
}
@end
