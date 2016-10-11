//
//  LXMajorViewController.m
//   一起留学
//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXMajorViewController.h"
#import "LXTopProfessionalController.h"
#import "LXProfessionalFeesController.h"
#import "LXProfessionalQSController.h"
#import "LXFilterViewController.h"
@interface LXMajorViewController ()<UIScrollViewDelegate>
{
}
//小红条
@property (nonatomic,strong) UIView *indicatorView;
//当前选中按钮
@property (nonatomic,strong) UIButton *selectedBtn;
/**内容视图*/
@property (nonatomic, strong)UIScrollView *contentView;
/**标签栏*/
@property (nonatomic, strong)UIView *titlesView;

@end

@implementation LXMajorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"找专业";
    self.view.backgroundColor= BackColor;
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:0.5];//
    //    关闭导航自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *filter=[UIButton buttonWithType:UIButtonTypeCustom];
    filter.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(35), FLEXIBLE_NUMY(35));
    [filter addTarget:self action:@selector(filterClick) forControlEvents:UIControlEventTouchUpInside];
    [filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:filter];
    
    [self setUpChildVcs];
    [self setUptitlesView];
    [self setUpContentView];
}

//顶部标签视图
-(void)setUptitlesView{
    UIView *titlesView = [[UIView alloc]init];
    if (ScreenHeight==480) {
        titlesView.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(64), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(35));
    }else if (ScreenHeight==568) {
        titlesView.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(54), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(35));
    }
    else {
        titlesView.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(44), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(35));
    }

    titlesView.backgroundColor = [UIColor whiteColor];
    //    titlesView.alpha = 0.5;
    [self.view addSubview:titlesView];
    NSArray *titles = @[@"热门申请",@"学费排名",@"QS排名"];
    //    小红条设置
    CGFloat width = titlesView.width/titles.count;
    CGFloat height = titlesView.height;
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor =TitleColor;
    indicatorView.height = 2;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.titlesView = titlesView;
    self.indicatorView = indicatorView;
    // 添加内部的button
    NSInteger count =3;
    for (NSInteger i = 0; i < count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.width = width;
        btn.height = height;
        btn.x = width*i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:TextColor forState:UIControlStateNormal];
        [btn setTitleColor:TitleColor forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:btn];
        if (i == 0) {
            btn.enabled = NO;
            self.selectedBtn = btn;
            [btn.titleLabel sizeToFit];
            self.indicatorView.centerX =btn.centerX-btn.titleLabel.centerX;
            self.indicatorView.width = btn.titleLabel.width;
        }
    }
    [titlesView addSubview:indicatorView];
}
// 配置内容
- (void)setUpContentView{
    
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(80), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(400))];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.contentSize = CGSizeMake(contentView.width*self.childViewControllers.count, 0);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    self.contentView = contentView;
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
    LXTopProfessionalController *hot=[[LXTopProfessionalController alloc]init];
    [self addChildViewController:hot];
    
    LXProfessionalFeesController  *Tuition=[[LXProfessionalFeesController alloc]init];
    [self addChildViewController:Tuition];
    
    LXProfessionalQSController *QS=[[LXProfessionalQSController alloc]init];
    [self addChildViewController:QS];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 当前的子控制器view
    // 当前索引
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y =0;
    
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}
-(void)filterClick{
    
    LXFilterViewController *filter=[[LXFilterViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:filter];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
