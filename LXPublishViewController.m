//
//  LXPublishViewController.m
//   一起留学
//
//  Created by will on 16/7/18.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXPublishViewController.h"
#import "PictureCollectionViewCell.h"
#import "PictureAddCell.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "LXPostTypeController.h"
#import "SVProgressHUD.h"
#define TextViewHeight  200  //textView的固定高度
#define kMaxLength 25     //25个字数限制

@interface LXPublishViewController ()<UITextViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDelegateFlowLayout,MJPhotoBrowserDelegate,ELCImagePickerControllerDelegate>

@property (strong , nonatomic) UITextView *textView;
@property(nonatomic,strong)UIScrollView *sc;
@property(nonatomic,strong)UITextField *field;
@property(nonatomic,strong)NSMutableArray *itemsSectionPictureArray;
@property(nonatomic,strong)UICollectionView *pictureCollectonView;
@property(nonatomic,strong)UILabel *lab;
@end

@implementation LXPublishViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title=@"发帖";
    self.view.backgroundColor=[UIColor whiteColor];
    // 初始化ScrollerView
    _sc=[[UIScrollView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(44), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(436))];
    _sc.contentSize=CGSizeMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(436)*1.5);
    _sc.backgroundColor=[UIColor whiteColor];
    _sc.showsHorizontalScrollIndicator = false;
    _sc.showsVerticalScrollIndicator = false;
    [self.view addSubview:_sc];
 
    //    初始化标题框
    _field=[[UITextField alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(30))];
    _field.delegate = self;
    _field.placeholder = @"输入标题(不超过25字)";
    _field.font=[UIFont systemFontOfSize:14];
    _field.tintColor=[UIColor blackColor];
    //    field.layer.cornerRadius=5;
    _field.borderStyle= UITextBorderStyleBezel;
    _field.textColor = [UIColor blackColor];
    
    // 监听长度变化
    [_field addTarget:self action:@selector(textFiledValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _field.returnKeyType = UIReturnKeyDone;
    [_sc addSubview:_field];

    
    //文本内容
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(31), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(150))];
    // _textView.scrollEnabled = false;
    _textView.backgroundColor=[UIColor whiteColor];
    _textView.font=[UIFont systemFontOfSize:14];
    _textView.delegate=self;
    _textView.layer.borderWidth=0.5;
    _textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _textView.tintColor=[UIColor blackColor];
    [_sc addSubview:_textView];
    
    _lab=[[UILabel alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(3), FLEXIBLE_NUMY(1.5), FLEXIBLE_NUMX(100), FLEXIBLE_NUMY(20))];
    _lab.text = @"请输入内容...";
    _lab.textColor=[UIColor lightTextColor];
    _lab.font=[UIFont systemFontOfSize:13];
    _lab.backgroundColor=[UIColor clearColor];
    _lab.enabled=NO;
    [_textView addSubview:_lab];
    
    //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
        UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FLEXIBLE_NUMY(30))];
        [topView setBarStyle:UIBarStyleDefault];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dealWithContent)];
          [doneButton setTintColor:[UIColor blackColor]];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
        [topView setItems:buttonsArray];
        [self.textView setInputAccessoryView:topView];
    
    self.itemsSectionPictureArray = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(FLEXIBLE_NUMY(75), FLEXIBLE_NUMY(75));
    layout.minimumInteritemSpacing =0;
    layout.minimumLineSpacing = 5; //上下的间距
    layout.sectionInset = UIEdgeInsetsMake(0.f, 5, 5.f, 5);
    
    //创建 UICollectionView
    self.pictureCollectonView = [[UICollectionView alloc] initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(181), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(75) )collectionViewLayout:layout];
    [self.pictureCollectonView registerClass:[PictureCollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
    [self.pictureCollectonView registerClass:[PictureAddCell class] forCellWithReuseIdentifier:@"addItemCell"];
    self.pictureCollectonView.backgroundColor = [UIColor whiteColor];
    self.pictureCollectonView.delegate = self;
    self.pictureCollectonView.dataSource = self;
        [_sc addSubview:self.pictureCollectonView];

}
//实现UITextView的代理
-(void)textViewDidChange:(UITextView *)textView
{

    if (_textView.text.length == 0) {
        _lab.text = @"请输入内容...";
    }else{
        _lab.text = @"";
    } 
}
// 限制输入框的输入长度
- (void)textFiledValueChanged:(UITextField*)textField {
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                [SVProgressHUD showErrorWithStatus:@"标题不超过25个字"];
            }
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
            [SVProgressHUD showErrorWithStatus:@"标题不超过25个字"];
        }
    }
}
#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemsSectionPictureArray.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.itemsSectionPictureArray.count) {
        static NSString *addItem = @"addItemCell";
        
        UICollectionViewCell *addItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:addItem forIndexPath:indexPath];
        
        return addItemCell;
    }else
    {
        static NSString *identify = @"cell";
        PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        cell.imageView.image = self.itemsSectionPictureArray[indexPath.row];
        
        return cell;
    }
}
//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.itemsSectionPictureArray.count) {
        if (self.itemsSectionPictureArray.count > 8) {
            return;
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择", @"拍照", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet showInView:self.view];
    }else
    {
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        for (int i = 0;i< self.itemsSectionPictureArray.count; i ++) {
            UIImage *image = self.itemsSectionPictureArray[i];
            
            MJPhoto *photo = [MJPhoto new];
            photo.image = image;
            PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            photo.srcImageView = cell.imageView;
            [photoArray addObject:photo];
        }
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = indexPath.row;
        browser.photos = photoArray;
        [browser show];
        
    }
}
-(void)deletedPictures:(NSSet *)set
{
    NSMutableArray *cellArray = [NSMutableArray array];
    
    for (NSString *index1 in set) {
        [cellArray addObject:index1];
    }
    if (cellArray.count == 0) {
        
    }else if (cellArray.count == 1 && self.itemsSectionPictureArray.count == 1) {
        NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.itemsSectionPictureArray removeObjectAtIndex:indexPathTwo.row];
        [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPathTwo]];
    }else{
        
        for (int i = 0; i<cellArray.count-1; i++) {
            for (int j = 0; j<cellArray.count-1-i; j++) {
                if ([cellArray[j] intValue]<[cellArray[j+1] intValue]) {
                    NSString *temp = cellArray[j];
                    cellArray[j] = cellArray[j+1];
                    cellArray[j+1] = temp;
                }
            }
        }
        for (int b = 0; b<cellArray.count; b++) {
            int idexx = [cellArray[b] intValue]-1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idexx inSection:0];
            [self.itemsSectionPictureArray removeObjectAtIndex:indexPath.row];
            [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
    if (self.itemsSectionPictureArray.count <4) {
        self.pictureCollectonView.frame = CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(181), self.view.frame.size.width, FLEXIBLE_NUMY(75));
    }else if (self.itemsSectionPictureArray.count <8)
    {
        self.pictureCollectonView.frame = CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(181), self.view.frame.size.width, FLEXIBLE_NUMY(160));
    }else
    {
        self.pictureCollectonView.frame = CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(181), self.view.frame.size.width, FLEXIBLE_NUMY(240));
    }
}
#pragma mark - 相册、相机调用方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"点击了从手机选择");
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.maximumImagesCount = 9 - self.itemsSectionPictureArray.count;
        elcPicker.returnsOriginalImage = YES;
        elcPicker.returnsImage = YES;
        elcPicker.onOrder = NO;
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
        elcPicker.imagePickerDelegate = self;
        //    elcPicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//过渡特效
        [self presentViewController:elcPicker animated:YES completion:nil];
        
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"点击了拍照");
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            NSLog(@"模拟无效,请真机测试");
        }
    }
}
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    __weak LXPublishViewController *wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        BOOL hasVideo = NO;
        
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
                if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                    UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                    [images addObject:image];
                } else {
                    NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
                }
            } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
                if (!hasVideo) {
                    hasVideo = YES;
                }
            } else {
                NSLog(@"Uknown asset type");
            }
        }
        NSMutableArray *indexPathes = [NSMutableArray array];
        for (unsigned long i = wself.itemsSectionPictureArray.count; i < wself.itemsSectionPictureArray.count + images.count; i++) {
            [indexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [wself.itemsSectionPictureArray addObjectsFromArray:images];
        // 调整集合视图的高度
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
            if (wself.itemsSectionPictureArray.count <4) {
                wself.pictureCollectonView.frame = CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(181), wself.view.frame.size.width, FLEXIBLE_NUMY(75));
            }else if (wself.itemsSectionPictureArray.count <8)
            {
                wself.pictureCollectonView.frame = CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(181), wself.view.frame.size.width, FLEXIBLE_NUMY(160));
            }else
            {
                wself.pictureCollectonView.frame = CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(181), wself.view.frame.size.width, FLEXIBLE_NUMY(240));
            }
            
            [wself.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            // 添加新选择的图片
            [wself.pictureCollectonView performBatchUpdates:^{
                [wself.pictureCollectonView insertItemsAtIndexPaths:indexPathes];
            } completion:^(BOOL finished) {
                if (hasVideo) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂不支持视频发布" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                }
            }];
        }];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [self.itemsSectionPictureArray addObject:image];
    __weak LXPublishViewController *wself = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
            if (wself.itemsSectionPictureArray.count <4) {
                wself.pictureCollectonView.frame = CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(181), wself.view.frame.size.width, FLEXIBLE_NUMY(75));
            }else if (wself.itemsSectionPictureArray.count <8)
            {
                wself.pictureCollectonView.frame = CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(181), wself.view.frame.size.width, FLEXIBLE_NUMY(160));
            }else
            {
                wself.pictureCollectonView.frame = CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(181), wself.view.frame.size.width, FLEXIBLE_NUMY(240));
            }
            
            [wself.view layoutIfNeeded];
        } completion:nil];
        
        [self.pictureCollectonView performBatchUpdates:^{
            [wself.pictureCollectonView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:wself.itemsSectionPictureArray.count - 1 inSection:0]]];
        } completion:nil];
    }];
    
}

- (IBAction)publishBtn:(id)sender {
    
    if (_textView.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请填写内容"];
    }else if(_field.text.length==0){
        
        [SVProgressHUD showErrorWithStatus:@"请填写标题"];
    }else{
    LXPostTypeController *postType=[[LXPostTypeController alloc]init];
    [self.navigationController pushViewController:postType animated:YES];
}
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 点击输入完成后让键盘失去第一响应
- (void)dealWithContent
{
    [_textView resignFirstResponder];
}
//点击空白处，键盘收缩的处理
- (void)touchesBegan:(NSSet<UITouch * > *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
