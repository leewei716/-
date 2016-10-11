//
//  LXHeaderView.m
//   一起留学
//
//  Created by will on 16/8/19.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXHeaderView.h"
#import "LXCustormbutton.h"
#import "LX3DScrollerView.h"

#import "LXSearchSchoolViewController.h"
#import "LXMajorViewController.h"
#import "LXFreeViewController.h"
#import "LXPostViewController.h"
#import "LXClassViewController.h"
#import "LXVideoViewController.h"
#import "LXFreeController.h"
#define WDWScreenW [UIScreen mainScreen].bounds.size.width

@implementation LXHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUserInterFace];
    }
    return self;
    
}

-(void)initUserInterFace{
    
    LX3DScrollerView *adAnimation = [self setupADScrollView];
    [self.contentView addSubview:adAnimation];
    
    _vi=[[UIView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(121), FLEXIBLE_NUMX(320), 2*FLEXIBLE_NUMY(70)+2)];
    _vi.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_vi];
    
    CGFloat width=1;
    CGFloat height=1;
    NSArray *arr=@[@"找学校",@"教程",@"免费申请",@"帖子",@"找专业",@"视频"];
    for (int i=0; i<6; i++) {
        LXCustormbutton *btn=[LXCustormbutton buttonWithType:UIButtonTypeSystem];
        btn.frame=CGRectMake((width+ButtonWidth)*(i%3)+width+1, (height+FLEXIBLE_NUMY(70))*(i%2)+height-1, ButtonWidth, FLEXIBLE_NUMY(70));
        btn.tag=i;
        [self setCustormbtn:btn setBackColor:[UIColor whiteColor] image:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]] title:arr[i] titlecolor:[UIColor blackColor]];
        [btn addTarget:self action:@selector(allClick:) forControlEvents:UIControlEventTouchUpInside];
        [_vi addSubview:btn];
    }
}
-(LX3DScrollerView*)setupADScrollView{
    
    LX3DScrollerView *adAnimation = [[LX3DScrollerView alloc] initWithFrame:CGRectMake(0,0, WDWScreenW, FLEXIBLE_NUMY(120))];
    
    return adAnimation;
}
-(void)setCustormbtn:(LXCustormbutton *)button
        setBackColor:(UIColor *)backcolor
               image:(UIImage *)image
               title:(NSString *)title
          titlecolor:(UIColor *)titlecolor{
    
    button.backgroundColor=[UIColor whiteColor];
    button.title.text=title;
    button.title.textColor=titlecolor;
    button.img.image=image;
}

-(void)allClick:(UIButton *)sender{
    
    UIButton *btn=sender;
    if(btn.tag==0){
        LXSearchSchoolViewController *search=[[LXSearchSchoolViewController alloc]init];
        [self.viewController.navigationController pushViewController:search animated:YES];
    }if(btn.tag==4){
        LXMajorViewController *major=[[LXMajorViewController alloc]init];
        [self.viewController.navigationController pushViewController:major animated:YES];

    }if(btn.tag==2){
        LXFreeController *free=[[LXFreeController alloc]init];
        [self.viewController.navigationController pushViewController:free animated:YES];

    }if(btn.tag==3){
        LXPostViewController *post=[[LXPostViewController alloc]init];
        [self.viewController.navigationController pushViewController:post animated:YES];

    }if(btn.tag==1){
        LXClassViewController *class=[[LXClassViewController alloc]init];
        [self.viewController.navigationController pushViewController:class animated:YES];

    }if(btn.tag==5){
        LXVideoViewController *video=[[LXVideoViewController alloc]init];
        [self.viewController.navigationController pushViewController:video animated:YES];

    }
    
}
@end
