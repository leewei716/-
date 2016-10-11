//
//  ViewPopButtons.m
//  QuHuWai
//
//  Created by wzkj on 15/3/11.
//  Copyright (c) 2015年 Wzkj. All rights reserved.
//

#import "newViewPopButtons.h"
#import <math.h>
@implementation newViewPopButtons
{
    NSMutableArray *buttonViews;
    NSArray *buttonArr;
    UIButton *atButton;
    UIButton *newAtButton;
    UIDynamicAnimator *theAnimator;
    ExpansionDirection Direction;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+(void)showButtons:(NSArray *) buttons
          atButton:(UIButton *) atButton
         Direction:(ExpansionDirection)direction
             Block:(ViewPopButtonsBlock) block{
    newViewPopButtons *view=[[newViewPopButtons alloc] init];
    view.block=[block copy];
    [view showButtons:buttons atButton:atButton Direction:direction];
    
}

-(id)init
{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        theAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return self;
}
-(void)showButtons:(NSArray *) _buttonArr
          atButton:(UIButton *)_atButton
         Direction:(ExpansionDirection)direction{
    self.userInteractionEnabled=false;
    atButton=_atButton;
    buttonArr=_buttonArr;
    Direction=direction;
    
    UIWindow *windows = [[[UIApplication sharedApplication] windows] lastObject];
    
    self.frame=windows.frame;
    [windows addSubview:self];
    
    newAtButton=[UIButton buttonWithType:atButton.buttonType];
    CGRect rect_button=[atButton.superview convertRect:atButton.frame toView:self.superview];
    newAtButton.frame=rect_button;
    newAtButton.tag=-1;
    [newAtButton setImage:[atButton imageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [newAtButton setImage:[atButton imageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [newAtButton addTarget:self action:@selector(OnClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:newAtButton];
    
    
    CGRect rect_view=rect_button;
    if (direction==DirectionDown) {
        rect_view.origin.y+=rect_view.size.height+10;
    }
    rect_view.size.height+=30;
    int idx=0;
    buttonViews=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in buttonArr) {
        if (direction==DirectionUp){
            rect_view.origin.y-=rect_view.size.height;
        }
        CGRect frame=rect_button;
        frame.size.height+=30;
        UIView *button_back=[[UIView alloc] initWithFrame:frame];
        [buttonViews addObject:button_back];
        [self addSubview:button_back];
        
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:button_back snapToPoint:[self frameCenter:rect_view]];
        // 随机振幅
        snap.damping = arc4random_uniform(5) / 10.0 + 0.5;
        // 添加仿真行为
        [theAnimator addBehavior:snap];
        
        UIImage *image0=[dic objectForKey:KeyNormalImage];
        UIImage *image1=[dic objectForKey:KeyHighlightedImage];
        NSString *title=[dic objectForKey:KeyButtonTitle];
        
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, rect_button.size.width, rect_button.size.height)];
        button.tag=idx;
        [button addTarget:self action:@selector(OnClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image0 forState:UIControlStateNormal];
        [button setImage:image1 forState:UIControlStateHighlighted];
        [button_back addSubview:button];
        
        UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake(2, title.length>2?rect_button.size.height+2:rect_button.size.height+10, rect_button.size.width-4, 20)];
        titleLable.text=title;
        titleLable.textColor=[UIColor whiteColor];
        titleLable.font=[UIFont systemFontOfSize:12];
        titleLable.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        titleLable.layer.cornerRadius=10;
        titleLable.layer.masksToBounds=true;
        titleLable.textAlignment=NSTextAlignmentCenter;
        [button_back addSubview:titleLable];
        
        if (direction==DirectionDown) {
            rect_view.origin.y+=rect_view.size.height;
        }
        idx++;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    } completion:^(BOOL finished) {
        self.userInteractionEnabled=true;
    }];
}
-(void)OnClickButton:(UIButton *)sender{
    [self disMissAtButtonIdx:sender.tag];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch");
    [self disMissAtButtonIdx:-1];
}
-(CGPoint)frameCenter:(CGRect) frame{
    return CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
}
-(void) disMissAtButtonIdx:(int) index{
    BOOL handled=false;
    if (_block && index!=-1) {
        handled=_block(index);
    }
    CGRect rect_button=[atButton.superview convertRect:atButton.frame toView:self.superview];
    newAtButton.frame=rect_button;
    
    if (index==-1 || !handled) {
        [self bringSubviewToFront:newAtButton];
    }else{
        [self bringSubviewToFront:buttonViews[index]];
    }
    
    [theAnimator removeAllBehaviors];
    for (UIView *button_back in buttonViews) {
        CGPoint center=newAtButton.center;
        switch (Direction) {
            case DirectionDown:
                center.y-=15;
                break;
            case DirectionUp:
                center.y+=15;
                break;
                
            default:
                break;
        }
        
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:button_back snapToPoint:center];
        // 随机振幅
        snap.damping = arc4random_uniform(5) / 10.0 + 0.5;
        // 添加仿真行为
        [theAnimator addBehavior:snap];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
