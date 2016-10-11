//
//  ViewSingleSelectMenu.m
//  QuHuWai
//
//  Created by wzkj on 14-10-15.
//  Copyright (c) 2014年 Wzkj. All rights reserved.
//

#import "ViewSingleSelectMenu.h"
#import "UIColor+expanded.h"
@implementation ViewSingleSelectMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
+(void)showWithBlock:(ViewSingleSelectMenuBlock )block
               title:title
   cancelButtonTitle:(NSString *)cancel
   otherButtonTitles:(NSString *)otherButtonTitles,... {
    ViewSingleSelectMenu *menu=[[ViewSingleSelectMenu alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-16, 0)];
    menu.block=block;
    
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    va_list varList;
    va_start(varList,otherButtonTitles);
    id arg=otherButtonTitles;
    while(arg){
        [argsArray addObject:arg];
        arg = va_arg(varList,id);
    }
    va_end(varList);
    [menu showWithTitle:title cancelButtonTitle:cancel otherButtonTitlesArr:argsArray];
}

+(void) showWithBlock:(ViewSingleSelectMenuBlock )block
                title:title
    cancelButtonTitle:(NSString *)cancel
 otherButtonTitlesArr:(NSArray *)argsArray{
    ViewSingleSelectMenu *menu=[[ViewSingleSelectMenu alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-16, 0)];
    menu.block=block;
    [menu showWithTitle:title cancelButtonTitle:cancel otherButtonTitlesArr:argsArray];
    
    
}
-(void) showWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancel otherButtonTitlesArr:(NSArray *)argsArray{
    CGFloat height=0;
    UIView *view_back=[[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:view_back];
    view_back.layer.cornerRadius=5;
    view_back.layer.masksToBounds=true;
    
    if (title!=nil && ![title isEqualToString:@""]) {
        UILabel *lb_title=[[UILabel alloc] initWithFrame:CGRectMake(0, height, self.frame.size.width, 44)];
        lb_title.backgroundColor=[UIColor clearColor];
        lb_title.font=[UIFont systemFontOfSize:14];
        lb_title.textColor=[UIColor colorWithWhite:0 alpha:0.5];
        lb_title.textAlignment=NSTextAlignmentCenter;
        lb_title.text=title;
        
        UIView *titleBar=[[UIToolbar alloc] initWithFrame:lb_title.frame];
        [view_back addSubview:titleBar];
        
        [view_back addSubview:lb_title];
        height+=lb_title.frame.size.height+0.5;
    }
    for (int i=0; i<argsArray.count; i++) {
        NSString *buttonTitle=[argsArray objectAtIndex:i];
        UIButton *bt=[[UIButton alloc] initWithFrame:CGRectZero];
        bt.tag=i;
        
        [bt addTarget:self
               action:@selector(OnClick:)
     forControlEvents:UIControlEventTouchUpInside];
        
        bt.backgroundColor=[UIColor clearColor];
        
        [bt setTitleColor:[UIColor colorWithRGBHex:0x414141]
                 forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorWithRGBHex:0x414141]
                 forState:UIControlStateHighlighted];
        
        [bt setTitle:buttonTitle
            forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageNamed:@"button_back"]
                      forState:UIControlStateHighlighted];
        
        bt.frame=CGRectMake(0, height, self.frame.size.width, 44);
        bt.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        
        UIView *buttonBar=[[UIToolbar alloc] initWithFrame:bt.frame];
        [view_back addSubview:buttonBar];
        [view_back addSubview:bt];
        
        height+=bt.frame.size.height+0.5;
        
    }
    view_back.frame=CGRectMake(0, 0, self.frame.size.width, height);
    
    height+=8;
    
    if (cancel==nil || [cancel isEqualToString:@""]) {
        cancel=@"取消";
    }
    UIButton *bt_cancel=[[UIButton alloc] initWithFrame:CGRectZero];
    bt_cancel.layer.cornerRadius=5;
    bt_cancel.layer.masksToBounds=true;
    bt_cancel.tag=-1;
    [bt_cancel addTarget:self
                  action:@selector(OnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    bt_cancel.backgroundColor=[UIColor clearColor];
    [bt_cancel setTitleColor:[UIColor colorWithRGBHex:0xFF7F85]
                    forState:UIControlStateNormal];
    [bt_cancel setTitleColor:[UIColor colorWithRGBHex:0xFF7F85]
                    forState:UIControlStateHighlighted];
    
    [bt_cancel setTitle:cancel
               forState:UIControlStateNormal];
    [bt_cancel setBackgroundImage:[UIImage imageNamed:@"button_back"]
                         forState:UIControlStateHighlighted];
    bt_cancel.frame=CGRectMake(0, height, self.frame.size.width, 40);
    bt_cancel.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    
    UIView *cancelBar=[[UIToolbar alloc] initWithFrame:bt_cancel.frame];
    cancelBar.layer.cornerRadius=5;
    cancelBar.layer.masksToBounds=true;
    [self addSubview:cancelBar];
    [self addSubview:bt_cancel];
    height+=bt_cancel.frame.size.height;
    
    
    
    CGRect ScreenRect=[UIScreen mainScreen].bounds;
    CGRect selfFrame=self.frame;
    selfFrame.origin.x=(CGRectGetWidth(ScreenRect)-CGRectGetWidth(selfFrame))/2,
    selfFrame.origin.y=CGRectGetHeight(ScreenRect);
    selfFrame.size.height=height;
    self.frame=selfFrame;
    
    UIView *back=[[UIView alloc] initWithFrame:ScreenRect];
    back.backgroundColor=[UIColor clearColor];
    [back addSubview:self];
    [[[UIApplication sharedApplication].windows lastObject] addSubview:back];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        back.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        CGRect frame=self.frame;
        frame.origin.y=frame.origin.y-frame.size.height-8;
        self.frame=frame;
    } completion:nil];
    UITapGestureRecognizer *rec=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTap)];
    [back addGestureRecognizer:rec];
}
- (void)OnTap{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.superview.backgroundColor=[UIColor clearColor];
        CGRect frame=self.frame;
        frame.origin.y=frame.origin.y+frame.size.height+8;
        self.frame=frame;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}
-(void)OnClick:(UIButton *)bt{
    [self OnTap];
    if (bt.tag==-1) {
        return;
    }
    if (_block) {
        _block(self,bt.tag);
    }
}
@end
