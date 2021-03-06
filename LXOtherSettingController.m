//
//  LXOtherSettingController.m
//   一起留学
//
//  Created by will on 16/7/23.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXOtherSettingController.h"
#import "LXOtherWantController.h"
#import "LXOtherPostController.h"
#import "LXOtherCollectionController.h"
#import "LXOtherSetingCell.h"

@interface LXOtherSettingController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UILabel *wantLab;
@property (weak, nonatomic) IBOutlet UILabel *PostLab;
@property (weak, nonatomic) IBOutlet UILabel *collectionLab;
@property (weak, nonatomic) IBOutlet UIImageView *uesrImg;
@property(nonatomic,strong)UILabel *lab;
//小红条
@property (nonatomic,strong) UIView *indicatorView;
//当前选中按钮
@property (nonatomic,strong) UIButton *selectedBtn;
/**内容视图*/
@property (nonatomic, strong)UIScrollView *contentView;
@end

@implementation LXOtherSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackColor;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBarHidden=YES;
    _ScrollView.contentSize=CGSizeMake(FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(480)*13);
    _ScrollView.showsVerticalScrollIndicator=NO;
    _ScrollView.keyboardDismissMode=UIScrollViewKeyboardDismissModeNone;
    _uesrImg.layer.borderWidth = 3;
    _uesrImg.layer.borderColor = [UIColor whiteColor].CGColor;
    [self setUpChildVcs];
    [self setUptitlesView];
    [self setUpContentView];
   
}
//顶部标签视图
-(void)setUptitlesView{
    UIView *titlesView = [[UIView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(30))];
    titlesView.backgroundColor = [UIColor whiteColor];
    //    titlesView.alpha = 0.5;
    [_titleView addSubview:titlesView];
    NSArray *titles = @[@"Ta想去",@"Ta的发布",@"Ta的收藏"];
    //    小红条设置
    CGFloat width = titlesView.width/titles.count;
    CGFloat height = titlesView.height;
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor =TitleColor;
    _lab.backgroundColor=TitleColor;
    indicatorView.height = 2;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.titleView = titlesView;
    self.indicatorView = indicatorView;
    // 添加内部的button
    NSInteger count =titles.count;
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
            _wantLab.textColor=TitleColor;
            _PostLab.textColor=TextColor;
            _collectionLab.textColor=TextColor;
            [btn.titleLabel sizeToFit];
            self.indicatorView.centerX=btn.centerX-btn.titleLabel.centerX;
            self.indicatorView.width = btn.titleLabel.width;
        }
    }
    [titlesView addSubview:indicatorView];
}
// 配置内容
- (void)setUpContentView{
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), _wantLab.y+_titleView.height+12,  [UIScreen mainScreen].bounds.size.width, FLEXIBLE_NUMY(480)*12)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.contentSize = CGSizeMake(contentView.width*self.childViewControllers.count, 0);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [_ScrollView insertSubview:contentView atIndex:0];
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
    if (button.tag==0) {
        _wantLab.textColor=TitleColor;
        _PostLab.textColor=TextColor;
        _collectionLab.textColor=TextColor;
    }if (button.tag==1) {
        _wantLab.textColor=TextColor;
        _PostLab.textColor=TitleColor;
        _collectionLab.textColor=TextColor;
    }if (button.tag==2) {
        _wantLab.textColor=TextColor;
        _PostLab.textColor=TextColor;
        _collectionLab.textColor=TitleColor;
    }
    
    
    
}

//添加子控制器
- (void)setUpChildVcs{
    LXOtherWantController *want=[[LXOtherWantController alloc]init];
    [self addChildViewController:want];
    
    LXOtherPostController  *post=[[LXOtherPostController alloc]init];
    [self addChildViewController:post];
    
    LXOtherCollectionController *Collection=[[LXOtherCollectionController alloc]init];
    [self addChildViewController:Collection];
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
    [self titleClick:self.titleView.subviews[index]];
}
- (IBAction)backBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
