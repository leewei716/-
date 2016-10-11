//
//  LXSchllodetailedController.m
//   一起留学
//
//  Created by will on 16/7/18.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXSchllodetailedController.h"
#import "LXSameSchoolController.h"
#import "LXSchoolVideoViewController.h"
#import "LXRecommendController.h"
#import "LXSchoolIntroduceController.h"
#import "LXSchoolPostController.h"

#import "ViewShare.h"

@interface LXSchllodetailedController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *collegeCollectionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property(nonatomic,retain)UIView *vi;
//标签栏
@property (weak, nonatomic) IBOutlet UIView *titlesView;
//小红条
@property (nonatomic,strong) UIView *indicatorView;
//当前选中按钮
@property (nonatomic,strong) UIButton *selectedBtn;
/**内容视图*/
@property (nonatomic, strong)UIScrollView *contentView;

@end

@implementation LXSchllodetailedController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(436), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(44))];
    view.backgroundColor=[UIColor whiteColor];
    _vi=view;
    [self.view addSubview:view];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(FLEXIBLE_NUMX(10), FLEXIBLE_NUMY(5), FLEXIBLE_NUMX(300), FLEXIBLE_NUMY(34));
    btn.backgroundColor=[UIColor colorWithRed:25.0/255 green:109.0/255 blue:230.0/255 alpha:1];
    [btn setTitle:@"查看适合你的学校" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    btn.layer.cornerRadius=5;
    btn.layer.masksToBounds=YES;    
    [view addSubview:btn];
    [self setUpChildVcs];
    [self setUptitlesView];
    [self setUpContentView];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
//顶部标签视图
-(void)setUptitlesView{
    _titlesView.backgroundColor = [UIColor whiteColor];
    _titlesView.width=[UIScreen mainScreen].bounds.size.width;
    [self.view addSubview:_titlesView];
    NSArray *titles = @[@"大学简介",@"专业推荐",@"视频资料",@"同类学校"];
        //    小红条设置
    CGFloat width = _titlesView.width/titles.count;
    CGFloat height = _titlesView.height;
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = TitleColor;
    indicatorView.height = 2;
    indicatorView.y = _titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    // 添加内部的button
    NSInteger count = titles.count;
    for (NSInteger i = 0; i < count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.width = width;
        btn.height = height;
        btn.x = width*i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:TitleColor forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titlesView addSubview:btn];
        if (i == 0) {
            btn.enabled = NO;
            self.selectedBtn = btn;
            [btn.titleLabel sizeToFit];
            self.indicatorView.centerX =btn.centerX-btn.titleLabel.centerX;
            self.indicatorView.width = btn.titleLabel.width;
        }
    }
    [_titlesView addSubview:indicatorView];
}
// 配置内容
- (void)setUpContentView{
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), _titlesView.y+_titlesView.height-FLEXIBLE_NUMY(20),  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-_titlesView.y-_vi.height-_titlesView.height+FLEXIBLE_NUMY(20)+FLEXIBLE_NUMY(44))];
   //  NSLog(@"======%f======%f======%f======%f======%f",self.view.height,_titlesView.height,_backImg.height,_vi.height,contentView.height);
   //  NSLog(@"-----------contentView-------%f",[UIScreen mainScreen].bounds.size .height-_titlesView.height-_backImg.height-_vi.height);
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.contentSize = CGSizeMake(contentView.width*self.childViewControllers.count, 0);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    _contentView = contentView;
    //    添加第一个控制器
    [self scrollViewDidEndScrollingAnimation:contentView];
}
    // 标签点击方法
- (void)titleClick:(UIButton *)button{
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedBtn = button;
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag*self.contentView.width;
    self.contentView.contentOffset = offset;
    [self scrollViewDidEndScrollingAnimation:self.contentView];
    
}

//添加子控制器
- (void)setUpChildVcs{
    //  大学介绍
    LXSchoolIntroduceController *Introduce=[[LXSchoolIntroduceController alloc]init];
//    Introduce.view.bounds=[UIScreen mainScreen].bounds ;
    [self addChildViewController:Introduce];
    // 专业推荐
    LXRecommendController *Recommend=[[LXRecommendController alloc]init];
//    Recommend.view.bounds=[UIScreen mainScreen].bounds ;
    [self addChildViewController:Recommend];
    //  视频资料
    LXSchoolVideoViewController *Video=[[LXSchoolVideoViewController alloc]init];
//    Video.view.bounds=[UIScreen mainScreen].bounds ;
    [self addChildViewController:Video];
    // 同类学校
    LXSameSchoolController *Same=[[LXSameSchoolController alloc]init];
//    Same.view.bounds=[UIScreen mainScreen].bounds ;
    [self addChildViewController:Same];

}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    // 当前的自控制器view
    // 当前索引
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y =0;
    vc.view.width = [UIScreen mainScreen].bounds.size.width;
    vc.view.height = scrollView.height;
    NSLog(@"========-----%f",scrollView.height);
    [scrollView addSubview:vc.view];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
    
    
}


- (IBAction)backbtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ShareBtn:(id)sender {
    NSMutableArray *buttons= [NSMutableArray array];
    
    [buttons addObject:@{VIEWSHARE_IMG_N:[UIImage imageNamed:@"share_wechat_n"],VIEWSHARE_IMG_H:[UIImage imageNamed:@"share_wechat_h"],VIEWSHARE_TITLE:@"微信好友"}];
    
    [buttons addObject:@{VIEWSHARE_IMG_N:[UIImage imageNamed:@"share_circle_n"],VIEWSHARE_IMG_H:[UIImage imageNamed:@"share_circle_h"],VIEWSHARE_TITLE:@"朋友圈"}];
    
    [buttons addObject: @{VIEWSHARE_IMG_N:[UIImage imageNamed:@"share_sina_n"],VIEWSHARE_IMG_H:[UIImage imageNamed:@"share_sina_h"],VIEWSHARE_TITLE:@"新浪微博"}];
    
    [buttons addObject: @{VIEWSHARE_IMG_N:[UIImage imageNamed:@"share_qq_n"],VIEWSHARE_IMG_H:[UIImage imageNamed:@"share_qq_h"],VIEWSHARE_TITLE:@"QQ 好友"}];
    
    [buttons addObject: @{VIEWSHARE_IMG_N:[UIImage imageNamed:@"share_qzone_n"],VIEWSHARE_IMG_H:[UIImage imageNamed:@"share_qzone_h"],VIEWSHARE_TITLE:@"QQ 空间"}];
    
    
    __weak typeof(self) weakself=self;
    [[ViewShare Instance] showButtonArr:buttons WithBlock:^(int idx) {
        if (!weakself) {
            return;
        }
        //        [[ShareHelper instance] shareAction:weakself.detailInfo typeIdx:idx];
    }];
    


}
//大学收藏
static  int i=1;
- (IBAction)collegeCollectionBtn:(id)sender {
    i++;
    if (i%2==1) {
        _collegeCollectionBtn.selected=YES;
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        
    }
    else if (i%2==0){
        _collegeCollectionBtn.selected=NO;
        [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
    }
   
}

//大学帖子
- (IBAction)collegePostBtn:(id)sender {
    self.hidesBottomBarWhenPushed=YES;
    LXSchoolPostController *sc=[[LXSchoolPostController alloc]init];
    [self.navigationController pushViewController:sc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
