//
//  LXFreeController.m
//   一起留学
//
//  Created by will on 16/8/10.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXFreeController.h"
#import "DMDropDownMenu.h"
@interface LXFreeController ()<UITextFieldDelegate,DMDropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet  DMDropDownMenu *questionView;
@property (weak, nonatomic) IBOutlet UITextField *schoolTextFld;
@property (weak, nonatomic) IBOutlet UITextField *classTextFld;
@property (weak, nonatomic) IBOutlet UITextField *marksTextFld;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFld;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFld;
@property (weak, nonatomic) IBOutlet UITextField *QQTextFld;
@end

@implementation LXFreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"免费申请";
    _scrollView.contentSize=CGSizeMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(480)*1.3);
    _scrollView.showsVerticalScrollIndicator=NO;
    
    _textView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 3;
    _textView.layer.masksToBounds = YES;
    
    NSArray * arrayData = [NSArray arrayWithObjects:@"我想申请该专业，请告诉我详细入学要求？",@"我想询问该专业申请截止报名时间是多久？", @"我想联系该专业的招生官",@"我想了解该学校的招生简章，请发至我的邮箱",nil];

     _questionView.delegate = self;
    [_questionView setListArray:arrayData];
    _schoolTextFld.delegate=self;
    _classTextFld.delegate=self;
    _marksTextFld.delegate=self;
    _nameTextFld.delegate=self;
    _phoneTextFld.delegate=self;
    _QQTextFld.delegate=self;
    
    //在弹出的键盘上面加一个view来放置退出键盘的Done按钮
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FLEXIBLE_NUMY(30))];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dealWithContent)];
    [doneButton setTintColor:[UIColor blackColor]];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    [self.textView setInputAccessoryView:topView];
 
}

- (void)selectIndex:(NSInteger)index AtDMDropDownMenu:(DMDropDownMenu *)dmDropDownMenu
{
    NSLog(@"dropDownMenu:%@ index:%ld",dmDropDownMenu,(long)index);
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


//textfield随着键盘向上移动
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (ScreenWidth <=320) {
        CGRect frame = textField.frame;
        int offset = frame.origin.y +422 - (self.view.frame.size.height - 240);//键盘高度216
        NSLog(@"offset is %d",offset);
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        if(offset > 0)
        {
            CGRect rect = CGRectMake(0.0f, -250,width,height);
            self.view.frame = rect;
        }
        [UIView commitAnimations];
    }else{
        CGRect frame = textField.frame;
        int offset = frame.origin.y +422 - (self.view.frame.size.height - 240);//键盘高度216
        NSLog(@"offset is %d",offset);
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        if(offset > 0)
        {
            CGRect rect = CGRectMake(0.0f, -200,width,height);
            self.view.frame = rect;
        }
        [UIView commitAnimations];
    }
}

//点击return按钮键盘收缩
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
