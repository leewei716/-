//
//  LXProfessionalDetailsController.m
//   一起留学
//
//  Created by will on 16/7/19.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXProfessionalDetailsController.h"
#import "LXProfessionalIntroductionController.h"//专业介绍
#import "LXProfessionalRankController.h"//专业排名
#import "LXProfessionalClassController.h"//专业课
#import "LXRequireController.h"//入学要求
#import "LXMigrateController.h"//移民相关

#import "ViewShare.h"

@interface LXProfessionalDetailsController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *MajorCollectionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property(nonatomic,strong)UIView *vi;
//小红条
@property (nonatomic,strong) UIView *indicatorView;
//当前选中按钮
@property (nonatomic,strong) UIButton *selectedBtn;
/**内容视图*/
@property (nonatomic, strong)UIScrollView *contentView;
@end

@implementation LXProfessionalDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideTabBar];

    self.navigationController.navigationBarHidden=YES;
    UIView *vi=[[UIView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(436), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(44))];
    vi.backgroundColor=[UIColor whiteColor];
    _vi=vi;
    [self.view addSubview:vi];
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(FLEXIBLE_NUMX(5), FLEXIBLE_NUMY(5), FLEXIBLE_NUMX(145), FLEXIBLE_NUMY(34));
    btn.backgroundColor=[UIColor colorWithRed:25.0/255 green:109.0/255 blue:230.0/255 alpha:1];
    btn.layer.cornerRadius=10;
    btn.layer.masksToBounds=YES;
    [btn setTitle:@"招商简章" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vi addSubview:btn];
    
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(FLEXIBLE_NUMX(170), FLEXIBLE_NUMY(5), FLEXIBLE_NUMX(145), FLEXIBLE_NUMY(34));
    btn1.backgroundColor=[UIColor colorWithRed:55.0/255 green:184.0/255 blue:136.0/255 alpha:1];;
    btn1.layer.cornerRadius=10;
    btn1.layer.masksToBounds=YES;
    [btn1 setTitle:@"联系招生官" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vi addSubview:btn1];
    
    [self setUpChildVcs];
    [self setUptitlesView];
    [self setUpContentView];

}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
//顶部标签视图
-(void)setUptitlesView{
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.width=[UIScreen mainScreen].bounds.size.width;
    [self.view addSubview:_titleView];
    NSArray *titles = @[@"专业介绍",@"专业排名",@"专业课程",@"入学要求",@"移民相关"];
    //    小红条设置
    CGFloat width = _titleView.width/titles.count;
    CGFloat height = _titleView.height;
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = TitleColor;
    indicatorView.height = 2;
    indicatorView.y = _titleView.height - indicatorView.height;
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
        [_titleView addSubview:btn];
        if (i == 0) {
            btn.enabled = NO;
            self.selectedBtn = btn;
            [btn.titleLabel sizeToFit];
            self.indicatorView.centerX =btn.centerX-btn.titleLabel.centerX;
            self.indicatorView.width = btn.titleLabel.width;
        }
    }
    [_titleView addSubview:indicatorView];
}

// 配置内容
- (void)setUpContentView{
    
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), _titleView.height+_backImg.height-FLEXIBLE_NUMY(20),  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-_titleView.height-_titleView.y-_vi.height+FLEXIBLE_NUMY(64))];
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
    LXProfessionalIntroductionController *Introduce=[[LXProfessionalIntroductionController alloc]init];
    [self addChildViewController:Introduce];
    // 专业推荐
    LXProfessionalRankController *Rank=[[LXProfessionalRankController alloc]init];
    [self addChildViewController:Rank];
    //  视频资料
    LXProfessionalClassController *Class=[[LXProfessionalClassController alloc]init];
    [self addChildViewController:Class];
    // 同类学校
    LXRequireController *Require=[[LXRequireController alloc]init];
    [self addChildViewController:Require];
    
    LXMigrateController *mig=[[LXMigrateController alloc]init];
    [self addChildViewController:mig];
    
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
    [scrollView addSubview:vc.view];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    [self titleClick:self.titleView.subviews[index]];
    
    
}
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareBtn:(id)sender {
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
static int i=1;
- (IBAction)MajorCollectionBtnClick:(id)sender {
    i++;
    if (i%2==1) {
        _MajorCollectionBtn.selected=YES;
        [SVProgressHUD  showSuccessWithStatus:@"收藏成功"];
    }else if(i%2==0){
        _MajorCollectionBtn.selected=NO;
       [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
}
}

- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
