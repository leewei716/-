//
//  LXCountryForumController.m
//   一起留学
//
//  Created by will on 16/8/15.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXCountryForumController.h"

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

@interface LXCountryForumController ()<ChatKeyBoardDelegate, ChatKeyBoardDataSource,UITableViewDelegate, UITableViewDataSource, ReloadMessageCellHightDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, assign) CGFloat history_Y_offset;
@property (nonatomic,copy)NSIndexPath *currentIndexPath;
@property(nonatomic,retain)UITableView *CountryTable;
@end

@implementation LXCountryForumController
- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册键盘出现NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(CountrykeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        //注册键盘隐藏NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(CountrykeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(ImageDelegate)name:@"headImg" object:nil];
    }
    return self;
}
//- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
//{
//    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
//    
//    //            ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
//    //
//    //            ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
//    //
//    //            ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
//    return @[item1];
//    
//    //            return @[item1, item2, item3, item4];
//}
//
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
                        _chatKeyBoard.allowMore = YES;
                  _chatKeyBoard.allowSwitchBar = YES;
        _chatKeyBoard.placeHolder = @"评论";
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_chatKeyBoard];
        [self.view bringSubviewToFront:_chatKeyBoard];
    }
    return _chatKeyBoard;
}
- (void)chatKeyBoardSendText:(NSString *)text{
    MessageModel *messageModel = [self.dataSource objectAtIndex:self.currentIndexPath.row];
    CommentModel *model = [[CommentModel alloc] init];
    model.commentUserName = messageModel.userName;
    /******************评论进行回复*********************/
    /******************评论进行回复*********************/
    model.commentUserName = @"文明";
    model.commentByUserName = @"李四";
    model.commentText = text;
    model.uid = [NSString stringWithFormat:@"commonModel%lu",  messageModel.commentModelArray.count + 1];
    [messageModel.commentModelArray addObject:model];
    messageModel.shouldUpdateCache = YES;
    [self reloadCellHeightForModel:messageModel atIndexPath:self.currentIndexPath];
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor=BackColor;
    self.CountryTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(361)) style:UITableViewStylePlain];
    self.CountryTable.backgroundColor=[UIColor whiteColor];
    self.CountryTable.delegate=self;
    self.CountryTable.dataSource=self;
    // 这句很重要 滑动隐藏键盘
    self.CountryTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.CountryTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    // 自动调节透明度
    self.CountryTable.mj_header.automaticallyChangeAlpha = YES;
    self.CountryTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self.CountryTable.mj_header beginRefreshing];
    
    // 去除刷新前的横线
    UIView *view = [UIView new];
    view.backgroundColor= [UIColor clearColor];
    [self.CountryTable setTableFooterView:view];
    [self.view addSubview:self.CountryTable];

//    // 通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(enterBackGround)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
}
//- (void)setUrlString:(NSString *)urlString{
//
//    _urlString = urlString;
//    
////    [MessageModel newsDataListWithUrlString:urlString complection:^(NSMutableArray *array) {
////        _dataSource = array;
//        [self.tableView reloadData]; // 不刷新的话，数据会显示复用的，而不是对应频道的。
////    }];
//    
//    // 投机取个巧
////    if ([[DDNewsCache sharedInstance] containsObject:urlString]) {
////        return;
////    } else{
////        [[DDNewsCache sharedInstance] addObject:urlString];
////        [self.tableView.mj_header beginRefreshing];
////    }
//    
//
//}


/** 下拉刷新 */
- (void)refreshData
{
    self.dataSource = [[NSMutableArray alloc]init];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]]];
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in JSONDic[@"data"][@"rows"]) {
        MessageModel *messageModel = [[MessageModel alloc] initWithDic:eachDic];
        [self.dataSource addObject:messageModel];
    }
    
    // 刷新表格
    [self.CountryTable reloadData];
    // 结束刷新
    [self.CountryTable.mj_header endRefreshing];
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    [SVProgressHUD dismiss];
    


}

/** 上拉加载 */
- (void)loadMoreData
{
    // 提示刷新
    [SVProgressHUD showErrorWithStatus:@"没有更多数据了..."];
    // 结束刷新
    [self.CountryTable.mj_footer endRefreshing];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCell"];
        cell.delegate = self;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak __typeof(self) weakSelf= self;
    __weak __typeof(_CountryTable) weakTable= _CountryTable;
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
#pragma mark - ReloadMessageCellHightDelegate
- (void)reloadCellHeightForModel:(MessageModel *)model atIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    [self.chatKeyBoard keyboardUpforComment];
    
    
    //
    //            CommentModel *commetModel = [[CommentModel alloc] init];
    //    //            model.commentUserName = messageModel.userName;
    //            commetModel.commentUserName = @"文明";
    //            commetModel.commentByUserName = @"涨水";
    //    //        commetModel.commentText = text;
    //            commetModel.uid = [NSString stringWithFormat:@"commonModel%lu",  model.commentModelArray.count + 1];
    //            [model.commentModelArray addObject:model];
    //
    //            [self reloadCellHeightForModel:model atIndexPath:self.currentIndexPath];
    //            [self.chatKeyBoard keyboardDownForComment];
    //            self.chatKeyBoard.placeHolder = nil;
    
    
    
    [_CountryTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark
#pragma mark keyboardWillShow
- (void)CountrykeyboardWillShow:(NSNotification *)notification
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
    
    
    CGPoint offset = _CountryTable.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = -64;
    }
    [_CountryTable setContentOffset:offset animated:YES];
}

#pragma mark
#pragma mark keyboardWillHide
- (void)CountrykeyboardWillHide:(NSNotification *)notification {
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        //     打开这句代码，“+”更多变为Done
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
-(void)ImageDelegate{
//    LXOtherSettingController *set=[[LXOtherSettingController alloc]init];
//    [self.navigationController pushViewController:set animated:YES];
}





@end
