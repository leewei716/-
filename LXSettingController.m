//
//  LXSettingController.m
//   一起留学
//
//  Created by will on 16/7/20.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXSettingController.h"
#import "ViewSingleSelectMenu.h"
#import "LXNotificationController.h"
#import "LXHelpVIewController.h"

@interface LXSettingController ()<UIImagePickerControllerDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *setHeadImg;

@end

@implementation LXSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _scrollView.contentSize=CGSizeMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(480)*1.5);
    _scrollView.backgroundColor=BackColor;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.delegate=self;
    _setHeadImg.layer.borderWidth = 3;
    _setHeadImg.layer.borderColor = [UIColor whiteColor].CGColor;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (IBAction)backBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
   }
- (IBAction)changeHeadImg:(id)sender {
    [ViewSingleSelectMenu showWithBlock:^(ViewSingleSelectMenu *sender, NSInteger selectedIndex) {
        switch (selectedIndex) {
            case 0:
            {
                [self performSelector:@selector(takePhoto) withObject:nil afterDelay:0.3];
            }
                break;
            case 1:
            {
                [self LocalPhoto];
            }
                break;
                
            default:
                break;
        }
        
    } title:@"设置头像" cancelButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
}
//开始拍照

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:picker animated:YES completion:nil];
        picker =nil;
    }else
    {
//                [WaitingHUD showToastError:@"无法打开照相机!"];
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:picker animated:YES completion:nil];
    picker =nil;
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        // 关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        // 修改头像
        //        [[OSSHelper Instance] uploadHeaderImg:UIImagePNGRepresentation(image)
        //                                             :^(int64_t currentSize, int64_t totalSize) {
        //
        //                                             } :^(NSString *fileName) {
        //                                                 // 上传并设置头像
        //                                                 dispatch_sync(dispatch_get_main_queue(), ^{
        //                                                     [[WzkjWebApi Instance] updateAvatar:self.view
        //                                                                                   image:fileName
        //                                                                                 Success:^(NSArray *resultlist) {
        //                                                                                     [_bt_Head setImage:image forState:UIControlStateNormal];
        //                                                                                 } Failed:nil];
        //                                                 });
        //
        //                                             } :^(NSString *errcode, NSError *errorMsg) {
        //
        //                                             }];
    }
}

//点击取消键调用该代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//通知设置
- (IBAction)NotificationClick:(id)sender {
    LXNotificationController *not=[[LXNotificationController alloc]init];
    [self.navigationController pushViewController:not animated:YES];
}
//帮助与反馈
- (IBAction)helpBtnClick:(id)sender {
    LXHelpVIewController *help=[[LXHelpVIewController alloc]init];
    [self.navigationController pushViewController:help animated:YES];
}
//清理缓存
- (IBAction)cleanClick:(id)sender {
}
//退出账号
- (IBAction)exitBtnClick:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
