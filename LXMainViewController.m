//
//  LXMainViewController.m
//   
//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXMainViewController.h"
#import "LXCustormbutton.h"
#import "LXPublishViewController.h"
#import "LXLoginController.h"
#import "LXRegisterViewController.h"
#import "LXOtherSettingController.h"
#import "LXFreeController.h"
#import "LXHeaderView.h"
//帖子
#import "MessageCell.h"
#import "MessageModel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
//键盘
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceThemeModel.h"
//
#import "LXPostDetailsController.h"
#import "MHActionSheet.h"
#import "LX3DScrollerView.h"

#define WDWScreenW [UIScreen mainScreen].bounds.size.width

@interface LXMainViewController ()<ChatKeyBoardDelegate, ChatKeyBoardDataSource,UITableViewDelegate, UITableViewDataSource, ReloadMessageCellHightDelegate>
@property(nonatomic,strong)UITableView *Posttable;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,copy)NSIndexPath *currentIndexPath;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, assign) CGFloat history_Y_offset;
@property(nonatomic,strong) UIButton *btn;
@end

@implementation LXMainViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册键盘出现NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(MainkeyboardWillShows:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        //注册键盘隐藏NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(MainkeyboardWillHides:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(MainImageDelegate)name:@"headImg" object:nil];
        
    }
    return self;
}
//- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
//{
//    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
//    
//    //        ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
//    //
//    //        ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
//    //
//    //        ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
//    return @[item1];
//    
//    //        return @[item1, item2, item3, item4];
//}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}
-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = YES;
//        _chatKeyBoard.allowMore = YES;
//        _chatKeyBoard.allowSwitchBar = YES;
        _chatKeyBoard.placeHolder = @"评论";
        [self.view addSubview:_chatKeyBoard];
        [self.view bringSubviewToFront:_chatKeyBoard];
    }
    return _chatKeyBoard;
}
//commentUserName发布说说者名字
//commentByUserName 评论者名字
- (void)chatKeyBoardSendText:(NSString *)text{
    MessageModel *messageModel = [self.dataSource objectAtIndex:self.currentIndexPath.row];
    CommentModel *model = [[CommentModel alloc] init];
    model.commentUserName = messageModel.userName;
    /******************进行评论*********************/
//  model.commentUserName = @"文明";
    model.commentByUserName =@"";
    model.commentText = text;
    model.uid = [NSString stringWithFormat:@"commonModel%ld",  messageModel.commentModelArray.count + 1];
    [messageModel.commentModelArray addObject:model];
    messageModel.shouldUpdateCache = YES;
    [self reloadCellHeightForModel:messageModel atIndexPath:self.currentIndexPath];
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
 
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   self.navigationController.navigationBarHidden=NO;
 

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.navigationItem.title=@"主页";
    self.navigationItem.hidesBackButton=YES;
  
    UIButton *post=[UIButton buttonWithType:UIButtonTypeCustom];
    post.size=CGSizeMake(FLEXIBLE_NUMX(35), FLEXIBLE_NUMY(35));
    [post addTarget:self action:@selector(postClick) forControlEvents:UIControlEventTouchUpInside];
    [post setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:post];
    
    UIButton *chooes=[UIButton buttonWithType:UIButtonTypeCustom];
    chooes.size=CGSizeMake(FLEXIBLE_NUMX(65), FLEXIBLE_NUMY(35));
      [chooes setTitle:@"澳洲" forState:UIControlStateNormal];
    [chooes setTitleColor:TitleColor forState:UIControlStateNormal];
    [chooes setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    chooes.titleLabel.font=[UIFont systemFontOfSize:15];
   [chooes addTarget:self action:@selector(chooseCountry:) forControlEvents:UIControlEventTouchUpInside];
    _btn=chooes;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:chooes];
//
    _Posttable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-FLEXIBLE_NUMY(8)) style:UITableViewStyleGrouped];
    _Posttable.backgroundColor=BackColor;
    _Posttable.delegate=self;
    _Posttable.dataSource=self;
    _Posttable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_Posttable];
    
    [self setUpRefresh];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [_Posttable.mj_header beginRefreshing];
}

//一进入界面进行刷新
- (void)setUpRefresh{
    _Posttable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    // 自动调节透明度
    _Posttable.mj_header.automaticallyChangeAlpha = YES;
    _Posttable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(laodMoreTopic)];
}
-(void)loadNewTopic{
    [self dealData];
}
-(void)laodMoreTopic{
    // 提示刷新
    [SVProgressHUD showErrorWithStatus:@"没有更多数据了..."];
    // 结束刷新
    [self.Posttable.mj_footer endRefreshing];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString * indentifier = @"header";
    LXHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:indentifier];
    if (!header) {
        header = [[LXHeaderView alloc]initWithReuseIdentifier:indentifier];
    }
    return header;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return FLEXIBLE_NUMY(262);
}
#pragma mark 处理测试数据
-(void)dealData{//到时候换网络请求数据

    self.dataSource = [[NSMutableArray alloc]init];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in JSONDic[@"data"][@"rows"]) {
        MessageModel *messageModel = [[MessageModel alloc] initWithDic:eachDic];
        [self.dataSource addObject:messageModel];
    }
    // 刷新表格
    [self.Posttable reloadData];
    // 结束刷新
    [_Posttable.mj_header endRefreshing];
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    [SVProgressHUD dismiss];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCell"];
        cell.delegate = self;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak __typeof(self) weakSelf= self;
    __weak __typeof(_Posttable) weakTable= _Posttable;
    __weak __typeof(cell) weakCell= cell;
    __weak __typeof(window) weakWindow= window;
    __block MessageModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configCellWithModel:model indexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    //评论
    cell.CommentBtnClickBlock = ^(UIButton *commentBtn,NSIndexPath * indexPath)
    {
        weakSelf.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"评论 %@",model.userName];
        weakSelf.history_Y_offset = [commentBtn convertRect:commentBtn.bounds toView:weakWindow].origin.y;
        weakSelf.currentIndexPath = indexPath;
        [weakSelf.chatKeyBoard keyboardUpforComment];
    };
    //更多
    cell.MoreBtnClickBlock = ^(UIButton *moreBtn,NSIndexPath * indexPath)
    {
        [weakSelf.chatKeyBoard keyboardDownForComment];
        weakSelf.chatKeyBoard.placeHolder = nil;
        model.isExpand = !model.isExpand;
        model.shouldUpdateCache = YES;
        [weakTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    //九宫格
    cell.tapBlock = ^(NSInteger index,NSArray *dataSource){
        [weakSelf.chatKeyBoard keyboardDownForComment];
        //1.创建图片浏览器
        MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
        NSMutableArray *photosArray = [NSMutableArray array];
        //2.告诉图片浏览器显示所有的图片
        for (int i = 0 ; i < dataSource.count; i++) {
            //传递数据给浏览器
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:dataSource[i]];
            photo.srcImageView = weakCell.jggView.subviews[i]; //设置来源哪一个UIImageView
            [photosArray addObject:photo];
        }
        brower.photos = photosArray;
        brower.currentPhotoIndex = index;
        [brower show];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    CGFloat h = [MessageCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        MessageCell *cell = (MessageCell *)sourceCell;
        [cell configCellWithModel:model indexPath:indexPath];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : model.cid,
                                kHYBCacheStateKey  : @"",
                                kHYBRecalculateForStateKey : @(model.shouldUpdateCache)};
        model.shouldUpdateCache = NO;
        return cache;
    }];
    return h;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *Index=[self.Posttable indexPathForSelectedRow];
    MessageCell *cell=[self.Posttable cellForRowAtIndexPath:Index];
    int intString=[cell.lookNumberLab.text intValue];
    intString ++;
    cell.lookNumberLab.text=[NSString stringWithFormat:@"%d",intString];
//  NSLog(@"======%@",cell.lookNumberLab.text);
    LXPostDetailsController *post=[[LXPostDetailsController alloc]init];
    [self.navigationController pushViewController:post animated:YES];
    
 }
#pragma mark - ReloadMessageCellHightDelegate
- (void)reloadCellHeightForModel:(MessageModel *)model atIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    [self.chatKeyBoard keyboardUpforComment];
//            CommentModel *commetModel = [[CommentModel alloc] init];
//            commetModel.commentUserName = model.userName;
//            commetModel.commentUserName = @"文明";
//            commetModel.commentByUserName = @"涨水";
//            commetModel.commentText = @"text";
//            commetModel.uid = [NSString stringWithFormat:@"commonModel%lu",  model.commentModelArray.count + 1];
//            [model.commentModelArray addObject:model];
//            [self reloadCellHeightForModel:model atIndexPath:self.currentIndexPath];
//            [self.chatKeyBoard keyboardDownForComment];
//            self.chatKeyBoard.placeHolder = nil;
    [_Posttable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark keyboardWillShow
- (void)MainkeyboardWillShows:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    __block  CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGFloat delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-85);
    
    CGPoint offset = _Posttable.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = -64;
    }
    [_Posttable setContentOffset:offset animated:YES];
}
#pragma mark keyboardWillHide
- (void)MainkeyboardWillHides:(NSNotification *)notification {
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
//                [self.chatKeyBoard keyboardDownForComment];
//                self.chatKeyBoard.placeHolder = nil;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"CommentViewController didReceiveMemoryWarning");
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"CommentViewController dealloc");
}
-(void)chooseCountry:(id)btn{
    MHActionSheet *actionSheet = [[MHActionSheet alloc] initSheetWithTitle:@"留学意向国家选择" style:MHSheetStyleDefault itemTitles:@[@"澳洲",@"新西兰",@"英国",@"美国",@"新加坡",@"香港",@"法国",@"德国"]];
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        NSString *text = [NSString stringWithFormat:@"%@", title];
        [_btn setTitle:text forState:UIControlStateNormal];
        NSLog(@"=========%ld",(long)index);
    }];
}
-(void)MainImageDelegate{
    LXOtherSettingController *set=[[LXOtherSettingController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
}
-(void)postClick{
    LXPublishViewController *publish=[[LXPublishViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:publish];
        [self presentViewController:nav animated:YES completion:nil];
//    LXLoginController *ll=[[LXLoginController alloc]init];
//    [self.navigationController pushViewController:ll animated:YES];
}
@end
