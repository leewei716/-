//
//  LX3DScrollerView.m
//   一起留学
//
//  Created by will on 16/8/6.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LX3DScrollerView.h"
#import "LXWebViewController.h"

@interface LX3DScrollerView()
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,strong)NSArray *Arrdata;
@end
@implementation LX3DScrollerView

//重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        //调用显示3D广告
        [self show3DBannerView];
        [self loadDataSource];
        //创建定时器
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeImageAction:) userInfo:nil repeats:YES];
    }
    
    return self;
}

-(void)loadDataSource{
//////////////添加数据
    _Arrdata=@[@"www.baidu.com",@"www.taobao.com",@"www.baidu.com",@"www.taobao.com",@"www.baidu.com",@"www.taobao.com"];
///////////////////
}
//创建页码器的方法
-(void)creatPageControl:(long)page
{
    //创建页码器，并设置位置和大小
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-25, self.frame.size.width, 25)];
    //设置中心点
    self.pageControl.center=CGPointMake(self.frame.size.width/2, self.pageControl.center.y);
    //设置页码
    self.pageControl.numberOfPages=page;
    //设置当前页点的颜色
    self.pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:1.000 green:0.000 blue:0.502 alpha:1.000];
    //设置其他页点的颜色
    self.pageControl.pageIndicatorTintColor=[UIColor colorWithWhite:0.600 alpha:1.000];
    //关闭用户交互
    self.pageControl.userInteractionEnabled=NO;
    //显示
    [self addSubview:self.pageControl];
}


//实现定时器的方法
-(void)changeImageAction:(NSTimer *)sender
{
    [self transitionAnimation:YES andAnimationMode:7];//andAnimationMode:7代表动画模式效果
}

- (void)show3DBannerView{
    
    
    //图片的名字存入数组中
    _imageArr = @[@"liuxue1.jpg",@"liuxue2.jpg",@"liuxue3.jpg",@"liuxue4.jpg",@"liuxue5.jpg",@"liuxue4.jpg"];
    
    //设置大小位置
    _imageView=[[UIImageView alloc]initWithFrame:self.bounds];
    
    //设置起始图片
    _imageView.image=[UIImage imageNamed:_imageArr[0]];//默认图片
    
        _imageView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
    //设置图片视图的tag
//    int i=0;
//    _imageView.tag =i;

    //添加图片
    [self addSubview:_imageView];
    
        //创建点击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doDoubleTap:)];//默认点击第一张
        //添加点击手势
        [_imageView addGestureRecognizer:doubleTap];
    
    //添加手势
        //创建滑动的手势（向左滑动）
    UISwipeGestureRecognizer *leftSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    
    //设置滑动的方向 （左）
    leftSwipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    //添加
    [self addGestureRecognizer:leftSwipeGesture];
    //创建滑动的手势（向右滑动）
    UISwipeGestureRecognizer *rightSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    
    //设置滑动的方向 （右）
    rightSwipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    
    //添加
    [self addGestureRecognizer:rightSwipeGesture];
    
    //创建pageControl
    [self creatPageControl:_imageArr.count];
}
#pragma mark 向左滑动浏览下一张图片
-(void)leftSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self transitionAnimation:YES andAnimationMode:4];
}

#pragma mark 向右滑动浏览上一张图片
-(void)rightSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self transitionAnimation:NO andAnimationMode:5];
}

#pragma mark 转场动画
-(void)transitionAnimation:(BOOL)isNext andAnimationMode:(int)mode
{
    //动画模式
    _animationModeArr=@[@"cube", @"moveIn", @"reveal", @"fade",@"pageCurl", @"pageUnCurl", @"suckEffect", @"rippleEffect", @"oglFlip"];
    
    
    //1.创建转场动画对象
    CATransition *transition=[[CATransition alloc]init];
    
    //2.设置动画类型,注意对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
    //@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"
    transition.type=_animationModeArr[mode];
    
    //设置子类型 （动画的方向）
    if (isNext) {
        transition.subtype=kCATransitionFromRight;  //右
    }else{
        transition.subtype=kCATransitionFromRight;   //左
    }
    //设置动画时间
    transition.duration=1.5f;
    
    //3.设置转场后的新视图添加转场动画
    _imageView.image=[self getImage:isNext];
    
    //加载动画
    [_imageView.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
}
#pragma mark 取得当前图片
-(UIImage *)getImage:(BOOL)isNext
{
    if (isNext) {
        _currentIndex=(_currentIndex+1)%_imageArr.count; //0，1，2，3，4，5，0，1
        self.pageControl.currentPage=_currentIndex;
    }else{
        _currentIndex=(_currentIndex-1+_imageArr.count)%(int)_imageArr.count;//0,5,4,3,2,1,5
        self.pageControl.currentPage=_currentIndex;
    }
    //获取的图片名字
    NSString *imageName = _imageArr[_currentIndex];
    //返回获取的图片
    return [UIImage imageNamed:imageName];
}

-(void)doDoubleTap:(id)tap{
    
            LXWebViewController *qw=[[LXWebViewController alloc]init];
            qw.stringurl=_Arrdata[_currentIndex];
//    if (_currentIndex==0) {
//        qw.stringurl=arr[0];
//    }else if(_currentIndex==1){
//        qw.stringurl=arr[1];
//    }else if(_currentIndex==2){
//        qw.stringurl=arr[2];
//    }else if(_currentIndex==3){
//        qw.stringurl=arr[3];
//    }else if(_currentIndex==4){
//        qw.stringurl=arr[4];
//    }else if(_currentIndex==5){
//        qw.stringurl=arr[5];
//    }
        [self.viewController.navigationController pushViewController:qw animated:YES];
}


@end
