//
//  LXFreeViewController.m
//   一起留学
//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXFreeViewController.h"
#import "LXFreeViewCell.h"
#import "DMDropDownMenu.h"

@interface LXFreeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DMDropDownMenuDelegate>
@property(nonatomic,strong)UITextField *filed;

@property(nonatomic,assign)NSInteger  hight;

@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,strong)UITableView *table;
@end

@implementation LXFreeViewController
////接收通知
//-(instancetype)init{
//    self = [super init];
//    
//    if (self ) {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headerViewHigth:) name:@"openHight" object:nil];//展开高度
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headerViewHigthDown:) name:@"closeHight" object:nil];//收起高度
//    }
//    return self;
//}
////销毁通知
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"免费申请";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UITableView *table=[[UITableView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(480))];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator=NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;

    table.delegate=self;
    table.dataSource=self;
    _table=table;
    [self.view addSubview:table];
    
 

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 12;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        return 120;
    }else if (indexPath.row==4){
       return 100;
    }else if(indexPath.row==3){
       
    return self.hight +44;
            }
    else{
        return 44;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    
    LXFreeViewCell * cell=nil;
    if (indexPath.row==2) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"FreeViewCell1"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"LXFreeViewCell" owner:self options:nil][1] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.applyBtn.selected=NO;
            [cell.applyBtn addTarget:self action:@selector(applyBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
   else if (indexPath.row==3) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"FreeViewCell2"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"LXFreeViewCell" owner:self options:nil][2] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            
              NSArray * arrayData = [NSArray arrayWithObjects:@"我想申请该专业，可否告诉我详细入学要求？",@"我想询问该专业申请截止报名时间是多久？", @"我想联系该专业的招生官",@"我想了解该学校的招生简章，请发至我的邮箱",nil];
            DMDropDownMenu * dm2 = [[DMDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, FLEXIBLE_NUMX(243), FLEXIBLE_NUMY(23))];
            dm2.delegate = self;
            [dm2 setListArray:arrayData];
            [cell.backView addSubview:dm2];

    }
       
    } else if (indexPath.row==4) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"FreeViewCell3"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"LXFreeViewCell"owner:self options:nil][3] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textView.layer.borderColor = UIColor.grayColor.CGColor;
            cell.textView.layer.borderWidth = 0.5;
            cell.textView.layer.cornerRadius = 6;
            cell.textView.layer.masksToBounds = YES;
        }
        
    } else if (indexPath.row==11) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"FreeViewCell4"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"LXFreeViewCell" owner:self options:nil][4] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    }else{
        cell=[tableView dequeueReusableCellWithIdentifier:@"FreeViewCell1"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"LXFreeViewCell" owner:self options:nil][0] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (indexPath.row==0) {
                 cell.applyTitleLab.text=@"意向大学";
            }else if (indexPath.row==1){
                cell.applyTitleLab.text=@"意向专业";
            }else if (indexPath.row==5){
                cell.applyTitleLab.text=@"在读学校";
            }else if (indexPath.row==6){
                cell.applyTitleLab.text=@"在读年级";
            }else if (indexPath.row==7){
                cell.applyTitleLab.text=@"      均分";
            }else if (indexPath.row==8){
                cell.applyTitleLab.text=@"     *姓名";
            }else if (indexPath.row==9){
                cell.applyTitleLab.text=@"     *电话";
            }else if (indexPath.row==10){
                cell.applyTitleLab.text=@"      *QQ";
            }
        }

    }
    
    return cell;
}
-(void)applyBtn:(id)btn{
    LXFreeViewCell *cell=[[ LXFreeViewCell alloc]init];
    if (cell.applyBtn.selected==NO) {
        cell.applyBtn.selected=YES;
    }else{
        cell.applyBtn.selected=NO;
    }
    
}

- (void)selectIndex:(NSInteger)index AtDMDropDownMenu:(DMDropDownMenu *)dmDropDownMenu
{
    NSLog(@"dropDownMenu:%@ index:%ld",dmDropDownMenu,(long)index);
}
-(void)headerViewHigth:(NSNotification *)dic{

    self.hight = [dic.userInfo[@"hight"]intValue];
        [_table reloadData];
    
}
-(void)headerViewHigthDown:(NSNotification *)dic{

    self.hight=0;
    [_table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
