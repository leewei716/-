//
//  LXPostViewController.m
//   一起留学
//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXPostViewController.h"
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
@interface LXPostViewController ()<ChatKeyBoardDelegate, ChatKeyBoardDataSource,UITableViewDelegate, UITableViewDataSource, ReloadMessageCellHightDelegate,UIScrollViewDelegate>


@property(nonatomic,retain)    UITableView *posttable;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, assign) CGFloat history_Y_offset;
@property (nonatomic,copy)NSIndexPath *currentIndexPath;

@end

@implementation LXPostViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册键盘出现NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        //注册键盘隐藏NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"帖子";
    self.view.backgroundColor=[UIColor whiteColor];
    
    _posttable=[[UITableView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(480))];
    //  这句很重要 滑动tableView隐藏键盘
    _posttable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    _posttable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _posttable.delegate=self;
    _posttable.dataSource=self;
    [self.view addSubview:_posttable];
    [self dealData];


}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
  
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
//            ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
//    
//            ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
//    
//            ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    return @[item1];
    
//            return @[item1, item2, item3, item4];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems{
      return [FaceSourceManager loadFaceSource];
}


-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
//        _chatKeyBoard.allowVoice = YES;
//                _chatKeyBoard.allowMore = YES;
//          _chatKeyBoard.allowSwitchBar = YES;
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
//    model.commentUserName = @"文明";
    model.commentByUserName = @"";
    model.commentText = text;
    model.uid = [NSString stringWithFormat:@"commonModel%lu",  messageModel.commentModelArray.count + 1];
    [messageModel.commentModelArray addObject:model];
    messageModel.shouldUpdateCache = YES;
    [self reloadCellHeightForModel:messageModel atIndexPath:self.currentIndexPath];
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
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
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCell"];
        cell.delegate = self;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak __typeof(self) weakSelf= self;
    __weak __typeof(_posttable) weakTable= _posttable;
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
    
    
    
    [_posttable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark
#pragma mark keyboardWillShow
- (void)keyboardWillShow:(NSNotification *)notification
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
    
    
    CGPoint offset = _posttable.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = -64;
    }
    [_posttable setContentOffset:offset animated:YES];
}

#pragma mark
#pragma mark keyboardWillHide
- (void)keyboardWillHide:(NSNotification *)notification {
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}


@end
