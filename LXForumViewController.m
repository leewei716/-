//
//  LXForumViewController.m
//   一起留学
//
//  Created by will on 16/8/13.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXForumViewController.h"
#import "LXCountryForumController.h"
#import "LXCollegeForumController.h"
#import "LXPublishViewController.h"
#import "YLSearchViewController.h"

#import "DDChannelModel.h"
#import "LXDDChannelModel.h"

#import "DDChannelLabel.h"
#import "LXDDChannelLabel.h"

#import "DDChannelCell.h"
#import "LXDDChannelCell.h"

#import "DDSortView.h"
#import "LXDDSortView.h"

#import "UIView+Extension.h"

//////////////////

#define AppColor [UIColor colorWithRed:0.00392 green:0.576 blue:0.871 alpha:1]
static NSString * const reuseID  = @"DDChannelCell";
static NSString * const reuseID2  = @"LXDDChannelCell";

@interface LXForumViewController ()<UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource,SearchResultDelegate>

/*模型 */
@property (nonatomic, strong) NSArray *channelList;

@property (nonatomic, strong) NSArray *channelList2;
/** 当前要展示频道 */
@property (nonatomic, strong) NSMutableArray *list_now; // 功能待完善

@property (nonatomic, strong) NSMutableArray *list_now2; // 功能待完善
/** 已经删除的频道 */
@property (nonatomic, strong) NSMutableArray *list_del; // 功能待完善
/** 频道列表 */
@property (nonatomic, strong) UIScrollView *smallScrollView;
/** 新闻视图 */
@property (nonatomic, strong) UICollectionView *bigCollectionView;
/** 下划线 */
@property (nonatomic, strong) UIView *underline;
/** 右侧添加删除排序按钮 */
@property (nonatomic, strong) UIButton *sortButton;
/** 分类排序界面 */
@property (nonatomic, strong) DDSortView *sortView;

@property (nonatomic, strong) LXDDSortView *sortView2;
/** 频道列表 */
@property (nonatomic, strong) UIScrollView *smallScrollView2;
/** 新闻视图 */
@property (nonatomic, strong) UICollectionView *bigCollectionView2;
/** 下划线 */
@property (nonatomic, strong) UIView *underline2;
/** 右侧添加删除排序按钮 */
@property (nonatomic, strong) UIButton *sortButton2;

@property(nonnull,strong)UISegmentedControl *segmentedControl;

@property(nonatomic,strong)UIButton *searchBtn;

@end

@implementation LXForumViewController


-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBarHidden=YES;
    [self setUpView];
}
-(void)setUpView{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"国家论坛",@"大学论坛",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(FLEXIBLE_NUMX(60), FLEXIBLE_NUMY(20), FLEXIBLE_NUMX(200), FLEXIBLE_NUMY(25));
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor grayColor];
    //有基本四种样式
    segmentedControl.segmentedControlStyle = UISegmentedControlSegmentCenter;//设置样式
    segmentedControl.momentary = NO;//设置在点击后是否恢复原样
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    _segmentedControl=segmentedControl;
    [self.view  addSubview:segmentedControl];
    [self.view addSubview:self.smallScrollView];
    [self.view addSubview:self.bigCollectionView];
    [self.view addSubview:self.sortButton];
    //    搜索
    UIButton *search=[UIButton  buttonWithType:UIButtonTypeCustom];
    search.frame=CGRectMake(FLEXIBLE_NUMX(15), FLEXIBLE_NUMY(23), FLEXIBLE_NUMX(20), FLEXIBLE_NUMY(20));
    [search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    //    search=_searchBtn;
    [self.view addSubview:search];
    //  发帖
    UIButton *postBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame=CGRectMake(FLEXIBLE_NUMX(285), FLEXIBLE_NUMY(21), FLEXIBLE_NUMX(20), FLEXIBLE_NUMY(20));
    [postBtn setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(postClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postBtn];
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %li", (long)Index);
    
    switch (Index) {
        case 0:
            [self selectmyView1];
            break;
        case 1:
            [self selectmyView2];
            break;
    }
}
-(void)selectmyView1{
    [self.smallScrollView2 removeFromSuperview];
    [self.bigCollectionView2 removeFromSuperview];
    [self.sortButton2 removeFromSuperview];
    
    [self.view addSubview:self.smallScrollView];
    [self.view addSubview:self.bigCollectionView];
    [self.view addSubview:self.sortButton];
    
}
-(void)selectmyView2{
    
    [self.smallScrollView removeFromSuperview];
    [self.bigCollectionView removeFromSuperview];
    [self.sortButton removeFromSuperview];
    
    [self.view addSubview:self.smallScrollView2];
    [self.view addSubview:self.bigCollectionView2];
    [self.view addSubview:self.sortButton2];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_segmentedControl.selectedSegmentIndex==0) {
        return _list_now.count;
    }else{
        return _list_now2.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (_segmentedControl.selectedSegmentIndex==0) {
         DDChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
        DDChannelModel *channel = _list_now[indexPath.row];
        cell.urlString = channel.urlString;
        // 如果不加入响应者链，则无法利用NavController进行Push/Pop等操作。
        [self addChildViewController:(UIViewController *)cell.CountryForum];

        return cell;

    }else{
         LXDDChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID2 forIndexPath:indexPath];
        LXDDChannelModel *channel = _list_now2[indexPath.row];
        cell.urlString2 = channel.urlString2;
        [self addChildViewController:(UIViewController *)cell.CollegeForum];

        return cell;
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
    {
        if (_segmentedControl.selectedSegmentIndex==0) {
        CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (value < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。e < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
        
        NSUInteger leftIndex = (int)value;
        NSUInteger rightIndex = leftIndex + 1;
        if (rightIndex >= [self getLabelArrayFromSubviews].count) {  // 防止滑到最右，再滑，数组越界，从而崩溃
            rightIndex = [self getLabelArrayFromSubviews].count - 1;
        }
        
        CGFloat scaleRight = value - leftIndex;
        CGFloat scaleLeft  = 1 - scaleRight;
        
        DDChannelLabel *labelLeft  = [self getLabelArrayFromSubviews][leftIndex];
        DDChannelLabel *labelRight = [self getLabelArrayFromSubviews][rightIndex];
        
        labelLeft.scale  = scaleLeft;
        labelRight.scale = scaleRight;
        
        //	 NSLog(@"value = %f leftIndex = %zd, rightIndex = %zd", value, leftIndex, rightIndex);
        //	 NSLog(@"左%f 右%f", scaleLeft, scaleRight);
        //	 NSLog(@"左：%@ 右：%@", labelLeft.text, labelRight.text);
        
        // 点击label会调用此方法1次，会导致【scrollViewDidEndScrollingAnimation】方法中的动画失效，这时直接return。
        if (scaleLeft == 1 && scaleRight == 0) {
            return;
        }
        
        // 下划线动态跟随滚动：马勒戈壁的可算让我算出来了
        _underline.centerX = labelLeft.centerX   + (labelRight.centerX   - labelLeft.centerX)   * scaleRight;
        _underline.width   = labelLeft.textWidth + (labelRight.textWidth - labelLeft.textWidth) * scaleRight;
    }else{
        
        CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (value < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
        
        NSUInteger leftIndex = (int)value;
        NSUInteger rightIndex = leftIndex + 1;
        if (rightIndex >= [self getLabelArrayFromSubviews2].count) {  // 防止滑到最右，再滑，数组越界，从而崩溃
            rightIndex = [self getLabelArrayFromSubviews2].count - 1;
        }
        
        CGFloat scaleRight = value - leftIndex;
        CGFloat scaleLeft  = 1 - scaleRight;
        
        LXDDChannelLabel *labelLeft  = [self getLabelArrayFromSubviews2][leftIndex];
        LXDDChannelLabel *labelRight = [self getLabelArrayFromSubviews2][rightIndex];
        
        labelLeft.scale  = scaleLeft;
        labelRight.scale = scaleRight;
        
        //	 NSLog(@"value = %f leftIndex = %zd, rightIndex = %zd", value, leftIndex, rightIndex);
        //	 NSLog(@"左%f 右%f", scaleLeft, scaleRight);
        //	 NSLog(@"左：%@ 右：%@", labelLeft.text, labelRight.text);
        
        // 点击label会调用此方法1次，会导致【scrollViewDidEndScrollingAnimation】方法中的动画失效，这时直接return。
        if (scaleLeft == 1 && scaleRight == 0) {
            return;
        }
        // 下划线动态跟随滚动：马勒戈壁的可算让我算出来了
        _underline2.centerX = labelLeft.centerX   + (labelRight.centerX   - labelLeft.centerX)   * scaleRight;
        _underline2.width   = labelLeft.textWidth + (labelRight.textWidth - labelLeft.textWidth) * scaleRight;
        
    }

}
/** 手指滑动BigCollectionView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_segmentedControl.selectedSegmentIndex==0&&[scrollView isEqual:self.bigCollectionView]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }else if(_segmentedControl.selectedSegmentIndex==1&&[scrollView isEqual:self.bigCollectionView2]){
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

/** 手指点击smallScrollView */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_segmentedControl.selectedSegmentIndex==0) {
        // 获得索引
        NSUInteger index = scrollView.contentOffset.x / self.bigCollectionView.width;
        // 滚动标题栏到中间位置
        DDChannelLabel *titleLable = [self getLabelArrayFromSubviews][index];
        CGFloat offsetx   =  titleLable.center.x - _smallScrollView.width * 0.5;
        CGFloat offsetMax = _smallScrollView.contentSize.width - _smallScrollView.width;
        // 在最左和最右时，标签没必要滚动到中间位置。
        if (offsetx < 0)		 {offsetx = 0;}
        if (offsetx > offsetMax) {offsetx = offsetMax;}
        [_smallScrollView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
        
        // 先把之前着色的去色：（快速滑动会导致有些文字颜色深浅不一，点击label会导致之前的标题不变回黑色）
        for (DDChannelLabel *label in [self getLabelArrayFromSubviews]) {
            label.textColor = [UIColor blackColor];
        }
        // 下划线滚动并着色
        [UIView animateWithDuration:0.5 animations:^{
            _underline.width = titleLable.textWidth;
            _underline.centerX = titleLable.centerX;
            titleLable.textColor = AppColor;
        }];

    }else if(_segmentedControl.selectedSegmentIndex==1){
        
        // 获得索引
        NSUInteger index = scrollView.contentOffset.x / self.bigCollectionView2.width;
        // 滚动标题栏到中间位置
        LXDDChannelLabel *titleLable = [self getLabelArrayFromSubviews2][index];
        CGFloat offsetx   =  titleLable.center.x - _smallScrollView2.width * 0.5;
        CGFloat offsetMax = _smallScrollView2.contentSize.width - _smallScrollView2.width;
        // 在最左和最右时，标签没必要滚动到中间位置。
        if (offsetx < 0)		 {offsetx = 0;}
        if (offsetx > offsetMax) {offsetx = offsetMax;}
        [_smallScrollView2 setContentOffset:CGPointMake(offsetx, 0) animated:YES];
        
        // 先把之前着色的去色：（快速滑动会导致有些文字颜色深浅不一，点击label会导致之前的标题不变回黑色）
        for (LXDDChannelLabel *label in [self getLabelArrayFromSubviews2]) {
            label.textColor = [UIColor blackColor];
        }
        // 下划线滚动并着色
        [UIView animateWithDuration:0.5 animations:^{
            _underline2.width = titleLable.textWidth;
            _underline2.centerX = titleLable.centerX;
            titleLable.textColor = AppColor;
        }];
    }
}



#pragma mark - getter
- (NSArray *)channelList
{
        if (_channelList == nil) {
            _channelList = [DDChannelModel channels];
                    NSLog(@"======%@",_channelList);
        }
    
    return _channelList;
}
#pragma mark - getter
- (NSArray *)channelList2
{
    if (_channelList2 == nil) {
        _channelList2 = [LXDDChannelModel channel2];
        NSLog(@"======%@",_channelList2);

    }
    return _channelList2;
}
- (UIScrollView *)smallScrollView
{
    if (_smallScrollView == nil) {
        _smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(45), ScrW, FLEXIBLE_NUMX(44))];
        _smallScrollView.backgroundColor = [UIColor whiteColor];
        _smallScrollView.showsHorizontalScrollIndicator = NO;
        // 设置频道
            _list_now = self.channelList.mutableCopy;
            [self setupChannelLabel];
        
        // 设置下划线
        [_smallScrollView addSubview:({
            DDChannelLabel *firstLabel = [self getLabelArrayFromSubviews][0];
            firstLabel.textColor = AppColor;
            // smallScrollView高度44，取下面4个点的高度为下划线的高度。
            _underline = [[UIView alloc] initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(40), firstLabel.textWidth, FLEXIBLE_NUMY(2))];
            _underline.centerX = firstLabel.centerX;
            _underline.backgroundColor = AppColor;
            _underline;
        })];
    }
    return _smallScrollView;
}
- (UIScrollView *)smallScrollView2
{
    if (_smallScrollView2 == nil) {
        _smallScrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(45), ScrW, FLEXIBLE_NUMX(44))];
        _smallScrollView2.backgroundColor = [UIColor whiteColor];
        _smallScrollView2.showsHorizontalScrollIndicator = NO;
        // 设置频道
        
            _list_now2 = self.channelList2.mutableCopy;
            [self setupChannelLabel2];
            
        
        // 设置下划线
        [_smallScrollView2 addSubview:({
            LXDDChannelLabel *firstLabel = [self getLabelArrayFromSubviews2][0];
            firstLabel.textColor = AppColor;
            // smallScrollView高度44，取下面4个点的高度为下划线的高度。
            _underline2 = [[UIView alloc] initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(40), firstLabel.textWidth, FLEXIBLE_NUMY(2))];
            _underline2.centerX = firstLabel.centerX;
            _underline2.backgroundColor = AppColor;
            _underline2;
        })];
    }
    return _smallScrollView2;
}
- (UICollectionView *)bigCollectionView
{
    if (_bigCollectionView == nil) {
        // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
        CGFloat h = ScrH - 64 - self.smallScrollView.height ;
        CGRect frame = CGRectMake(0, self.smallScrollView.maxY, ScrW, h);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _bigCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _bigCollectionView.backgroundColor = [UIColor whiteColor];
        _bigCollectionView.delegate = self;
        _bigCollectionView.dataSource = self;
        [_bigCollectionView registerClass:[DDChannelCell class] forCellWithReuseIdentifier:reuseID];
        
        // 设置cell的大小和细节
        flowLayout.itemSize = _bigCollectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _bigCollectionView.pagingEnabled = YES;
        _bigCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _bigCollectionView;
}
- (UICollectionView *)bigCollectionView2
{
    if (_bigCollectionView2 == nil) {
        // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
        CGFloat h = ScrH - 64 - self.smallScrollView2.height ;
        CGRect frame = CGRectMake(0, self.smallScrollView2.maxY, ScrW, h);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _bigCollectionView2 = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _bigCollectionView2.backgroundColor = [UIColor whiteColor];
        _bigCollectionView2.delegate = self;
        _bigCollectionView2.dataSource = self;
        [_bigCollectionView2 registerClass:[LXDDChannelCell class] forCellWithReuseIdentifier:reuseID2];
        // 设置cell的大小和细节
        flowLayout.itemSize = _bigCollectionView2.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _bigCollectionView2.pagingEnabled = YES;
        _bigCollectionView2.showsHorizontalScrollIndicator = NO;
    }
    return _bigCollectionView2;
}
- (UIButton *)sortButton
{
    if (_sortButton == nil) {
        _sortButton = [[UIButton alloc] initWithFrame:CGRectMake(ScrW-FLEXIBLE_NUMX(44), FLEXIBLE_NUMY(46), FLEXIBLE_NUMY(44), FLEXIBLE_NUMY(35))];
        [_sortButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        _sortButton.backgroundColor = [UIColor whiteColor];
        _sortButton.layer.shadowColor = [UIColor whiteColor].CGColor;
        _sortButton.layer.shadowOpacity = 1;
        _sortButton.layer.shadowRadius = 5;
        _sortButton.layer.shadowOffset = CGSizeMake(-10, 0);
        [_sortButton addTarget:self action:@selector(sortButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton;
}
- (UIButton *)sortButton2
{
    if (_sortButton2== nil) {
        _sortButton2 = [[UIButton alloc] initWithFrame:CGRectMake(ScrW-FLEXIBLE_NUMX(44), FLEXIBLE_NUMY(46), FLEXIBLE_NUMY(44), FLEXIBLE_NUMY(35))];
        [_sortButton2 setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        _sortButton2.backgroundColor = [UIColor whiteColor];
        _sortButton2.layer.shadowColor = [UIColor whiteColor].CGColor;
        _sortButton2.layer.shadowOpacity = 1;
        _sortButton2.layer.shadowRadius = 5;
        _sortButton2.layer.shadowOffset = CGSizeMake(-10, 0);
        [_sortButton2 addTarget:self action:@selector(sortButtonClick2) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton2;
}
- (DDSortView *)sortView
{
    if (_sortView == nil) {
        _sortView = [[DDSortView alloc] initWithFrame:CGRectMake(_smallScrollView.x,
                                                                 _smallScrollView.y,
                                                                 ScrW,
                                                                 _smallScrollView.height + _bigCollectionView.height)
                                          channelList:_list_now];
        __block typeof(self) weakSelf = self;
        // 箭头点击回调
        _sortView.arrowBtnClickBlock = ^{
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.sortView.y = -ScrH;
                //				weakSelf.tabBarController.tabBar.y -= 49;
                weakSelf.tabBarController.tabBar.y = ScrH - 49; // 这么写防止用户多次点击label和排序按钮，造成tabbar错乱
            } completion:^(BOOL finished) {
                [weakSelf.sortView removeFromSuperview];
            }];
        };
        // 排序完成回调
        _sortView.sortCompletedBlock = ^(NSMutableArray *channelList){
            weakSelf.list_now = channelList;
            // 去除旧的排序
            for (DDChannelLabel *label in [weakSelf getLabelArrayFromSubviews]) {
                [label removeFromSuperview];
            }
            // 加入新的排序
            [weakSelf setupChannelLabel];
            // 滚到第一个频道！offset、下划线、着色，都去第一个. 直接模拟第一个label被点击：
            DDChannelLabel *label = [weakSelf getLabelArrayFromSubviews][0];
            UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
            [tap setValue:label forKey:@"view"];
            [weakSelf labelClick:tap];
        };
        // cell按钮点击回调
        _sortView.cellButtonClick = ^(UIButton *button){
            // 模拟label被点击
            for (DDChannelLabel *label in [weakSelf getLabelArrayFromSubviews]) {
                if ([label.text isEqualToString:button.titleLabel.text]) {
                    weakSelf.sortView.arrowBtnClickBlock(); // 关闭sortView
                    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
                    [tap setValue:label forKey:@"view"];
                    [weakSelf labelClick:tap];
                }
            }
        };
    }
    return _sortView;
}

- (LXDDSortView *)sortView2
{
    if (_sortView2== nil) {
        _sortView2 = [[LXDDSortView alloc] initWithFrames:CGRectMake(_smallScrollView2.x,
                                                                 _smallScrollView2.y,
                                                                 ScrW,
                                                                 _smallScrollView2.height + _bigCollectionView2.height)
                                          channelLists:_list_now2];
        __block typeof(self) weakSelf = self;
        // 箭头点击回调
        _sortView2.arrowBtnClickBlock = ^{
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.sortView2.y = -ScrH;
                //				weakSelf.tabBarController.tabBar.y -= 49;
                weakSelf.tabBarController.tabBar.y = ScrH - 49; // 这么写防止用户多次点击label和排序按钮，造成tabbar错乱
            } completion:^(BOOL finished) {
                [weakSelf.sortView2 removeFromSuperview];
            }];
        };
        // 排序完成回调
        _sortView2.sortCompletedBlock = ^(NSMutableArray *channelList){
            weakSelf.list_now2 = channelList;
            // 去除旧的排序
            for (LXDDChannelLabel *label in [weakSelf getLabelArrayFromSubviews2]) {
                [label removeFromSuperview];
            }
            // 加入新的排序
            [weakSelf setupChannelLabel2];
            // 滚到第一个频道！offset、下划线、着色，都去第一个. 直接模拟第一个label被点击：
            LXDDChannelLabel *label = [weakSelf getLabelArrayFromSubviews2][0];
            UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
            [tap setValue:label forKey:@"view"];
            [weakSelf labelClick2:tap];
        };
        // cell按钮点击回调
        _sortView2.cellButtonClick = ^(UIButton *button){
            // 模拟label被点击
            for (LXDDChannelLabel *label in [weakSelf getLabelArrayFromSubviews2]) {
                if ([label.text isEqualToString:button.titleLabel.text]) {
                    weakSelf.sortView2.arrowBtnClickBlock(); // 关闭sortView
                    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
                    [tap setValue:label forKey:@"view"];
                    [weakSelf labelClick2:tap];
                }
            }
        };
    }
    return _sortView2;

}
#pragma mark -
/** 设置频道标题 */
- (void)setupChannelLabel
{
    CGFloat margin = 20.0;
    CGFloat x = 8;
    CGFloat h = _smallScrollView.bounds.size.height;
    int i = 0;
        for (DDChannelModel *channel in _list_now) {
            DDChannelLabel *label = [DDChannelLabel channelLabelWithTitle:channel.tname];
            label.frame = CGRectMake(x, 0, label.width + margin, h);
            [_smallScrollView addSubview:label];
            x += label.bounds.size.width;
            label.tag = i++;
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
        }
    _smallScrollView.contentSize = CGSizeMake(x + margin + self.sortButton.width, 0);
}
- (void)setupChannelLabel2
{
    CGFloat margin = 20.0;
    CGFloat x = 8;
    CGFloat h = _smallScrollView2.bounds.size.height;
    int i = 0;
    for (LXDDChannelModel *channel2 in _list_now2) {
        LXDDChannelLabel *label = [LXDDChannelLabel channelLabelWithTitle:channel2.tname2];
        label.frame = CGRectMake(x, 0, label.width + margin, h);
        [_smallScrollView2 addSubview:label];
        x += label.bounds.size.width;
        label.tag = i++;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick2:)]];
    }
     _smallScrollView2.contentSize = CGSizeMake(x + margin + self.sortButton2.width, 0);
}
/** 频道Label点击事件 */
- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    DDChannelLabel *label =(DDChannelLabel *)recognizer.view;
    // 点击label后，让bigCollectionView滚到对应位置。
    [_bigCollectionView setContentOffset:CGPointMake(label.tag * _bigCollectionView.frame.size.width, 0)];
    // 重新调用一下滚定停止方法，让label的着色和下划线到正确的位置。
    [self scrollViewDidEndScrollingAnimation:self.bigCollectionView];
}
- (void)labelClick2:(UITapGestureRecognizer *)recognizer
{
    LXDDChannelLabel *label = (LXDDChannelLabel *)recognizer.view;
    // 点击label后，让bigCollectionView滚到对应位置。
    [_bigCollectionView2 setContentOffset:CGPointMake(label.tag * _bigCollectionView2.frame.size.width, 0)];
    // 重新调用一下滚定停止方法，让label的着色和下划线到正确的位置。
    [self scrollViewDidEndScrollingAnimation:self.bigCollectionView2];
}
/** 获取smallScrollView中所有的DDChannelLabel，合成一个数组，因为smallScrollView.subViews中有其他非Label元素 */
- (NSArray *)getLabelArrayFromSubviews
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (DDChannelLabel *label in _smallScrollView.subviews) {
        if ([label isKindOfClass:[DDChannelLabel class]]) {
            [arrayM addObject:label];
        }
    }
    return arrayM.copy;
}
/** 获取smallScrollView中所有的DDChannelLabel，合成一个数组，因为smallScrollView.subViews中有其他非Label元素 */
- (NSArray *)getLabelArrayFromSubviews2
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (LXDDChannelLabel *label in _smallScrollView2.subviews) {
        if ([label isKindOfClass:[LXDDChannelLabel class]]) {
            [arrayM addObject:label];
        }
    }
    return arrayM.copy;
}
/** 排序按钮点击事件 */
- (void)sortButtonClick
{
        [self.view addSubview:self.sortView];
        _sortView.y = -ScrH;
        [UIView animateWithDuration:0.5 animations:^{
            self.tabBarController.tabBar.y += 49;
            _sortView.y = _smallScrollView.y;
        }];
}
- (void)sortButtonClick2{
    [self.view addSubview:self.sortView2];
    _sortView2.y = -ScrH;
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.y += 49;
        _sortView2.y = _smallScrollView2.y;
    }];
}
-(void)searchClick:(id)search{
    YLSearchViewController *vc = [[YLSearchViewController alloc] initWithNibName:@"YLSearchViewController" bundle:nil];
    if (_segmentedControl.selectedSegmentIndex==0) {
//        _list_now = self.channelList.mutableCopy;
//        vc.serchArray =[NSMutableArray arrayWithObject:_list_now];
//
//    vc.serchArray =_list_now;
    vc.serchArray=  [NSMutableArray arrayWithObjects:@"澳洲",@"日本",@"新西兰",@"英国",@"德国",@"新加坡", @"法国",nil];
        //设置代理
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
//        
    }if (_segmentedControl.selectedSegmentIndex==1) {
//        _list_now2 = self.channelList2.mutableCopy;
//        vc.serchArray =[NSMutableArray arrayWithObject:_list_now2];
//        NSLog(@"======%@",vc.serchArray);
        vc.serchArray=  [NSMutableArray arrayWithObjects:@"澳洲国立大学",@"墨尔本大学",@"新西兰大学",@"英国大学",@"剑桥大学",@"新加坡大学", @"澳洲大学",nil];
        //设置代理
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //把搜索数据传过去
 
}
#pragma mark -- SearchResultDelegate
- (void)searchResultData:(NSString *)value {
//    搜索结果的返回值
//    [self.searchBtn setTitle:value forState:UIControlStateNormal];
}
-(void)postClick:(id)post{
    LXPublishViewController *Post=[[LXPublishViewController alloc]init];
    UINavigationController *na=[[UINavigationController alloc]initWithRootViewController:Post];
    [self presentViewController:na animated:YES completion:nil ];
}
@end
