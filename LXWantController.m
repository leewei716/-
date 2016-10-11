//
//  LXWantController.m
//   一起留学
//
//  Created by will on 16/7/20.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXWantController.h"
#import "LXWantViewCell.h"
#import "LXAddViewController.h"
#import "LXAddSchoolController.h"
#import "LXAddProfessionController.h"

@interface LXWantController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *arr;
    NSMutableArray *arrCountry;
    NSMutableArray *arrSchool;
    NSMutableArray *arrmajor;
    
}

@property(nonatomic,strong)UITableView *table;
@end
@implementation LXWantController
//接收通知
-(instancetype)init{
    self = [super init];
    
    if (self ) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCountryText:) name:@"CountreyLableText" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addSchoolText:) name:@"SchoolLableText" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addMajorText:) name:@"MajorLableText" object:nil];
    }
    return self;
}
//销毁通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    UITableView *table=[[UITableView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(480)*12)];
    
    table.delegate=self;
    table.dataSource=self;
    table.scrollEnabled=NO;
//    隐藏没有内容的cell
    [self setExtraCellLineHidden:table];
    _table=table;
    [self.view addSubview:table];
   
    arr=@[@"想去的国家",@"想去的学校",@"想去的专业"];

    arrCountry=[[NSMutableArray alloc]initWithObjects:@"英国",@"澳大利亚",@"新西兰", nil];
    arrSchool=[[NSMutableArray alloc]initWithObjects:@"牛津大学",@"墨尔本大学",@"剑桥大学", nil];
    arrmajor=[[NSMutableArray alloc]initWithObjects:@"工商管理",@"计算机工程",@"会计专业", nil];

}
-(void)addCountryText:(NSNotification *)info{
        
    [arrCountry addObject:info.userInfo[@"Country"]];
    [_table reloadData];
    
}
-(void)addSchoolText:(NSNotification *)info{
    [arrSchool addObject:info.userInfo[@"School"]];
    [_table reloadData];
    
}
-(void)addMajorText:(NSNotification *)info{
    
    [arrmajor addObject:info.userInfo[@"Major"]];
    [_table reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return arrCountry.count;
    }if (section==1) {
        return arrSchool.count;
    }else {
  return arrmajor.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    UILabel *want=[[UILabel alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(15), FLEXIBLE_NUMY(10), FLEXIBLE_NUMX(100), FLEXIBLE_NUMY(30))];
    view.backgroundColor=BackColor;
    
    if (section==0) {
        want.text=@"    想去的国家";
        want.font=[UIFont systemFontOfSize:14];
        want.textColor=TextColor;
        UIButton *add=[UIButton buttonWithType:UIButtonTypeSystem];
        add.frame=CGRectMake(FLEXIBLE_NUMX(275), FLEXIBLE_NUMY(10), FLEXIBLE_NUMX(40), FLEXIBLE_NUMY(30));
        [add setTitle:@"添加" forState:UIControlStateNormal];
        [add addTarget:self action:@selector(addCountry:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:add];
        
    }if (section==1) {
        want.text=@"    想去的学校";
        want.font=[UIFont systemFontOfSize:14];
        want.textColor=TextColor;
       
        UIButton *add=[UIButton buttonWithType:UIButtonTypeSystem];
        add.frame=CGRectMake(FLEXIBLE_NUMX(275), FLEXIBLE_NUMY(10), FLEXIBLE_NUMX(40), FLEXIBLE_NUMY(30));
        [add setTitle:@"添加" forState:UIControlStateNormal];
        [add addTarget:self action:@selector(addSchool:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:add];
    }if (section==2) {
        want.text=@"    想去的专业";
        want.font=[UIFont systemFontOfSize:14];
        want.textColor=TextColor;
        
        UIButton *add=[UIButton buttonWithType:UIButtonTypeSystem];
        add.frame=CGRectMake(FLEXIBLE_NUMX(275), FLEXIBLE_NUMY(10), FLEXIBLE_NUMX(40), FLEXIBLE_NUMY(30));
        [add setTitle:@"添加" forState:UIControlStateNormal];
        [add addTarget:self action:@selector(addMajor:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:add];
    }
    [view addSubview:want];
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LXWantViewCell *cell=nil;
    if (indexPath.section==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"WantViewCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"LXWantViewCell" owner:self options:nil][0] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.wantCountryLab.text=arrCountry[indexPath.row];
            cell.countryDelBtn.tag=indexPath.row+1;
            [cell.countryDelBtn addTarget:self action:@selector(countryDel:) forControlEvents:UIControlEventTouchUpInside];
    }
        
    }else if (indexPath.section==1){
        cell=[tableView dequeueReusableCellWithIdentifier:@"WantSchoollCell"];
        if (!cell) {
           
            cell=[[NSBundle mainBundle]loadNibNamed:@"LXWantViewCell" owner:nil options:nil][1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.wantSchoolLab.text=arrSchool[indexPath.row];
            cell.schoolDelBtn.tag=indexPath.row+1;
            [cell.schoolDelBtn addTarget:self action:@selector(schoolDel:) forControlEvents:UIControlEventTouchUpInside];
    }
        
    }else if (indexPath.section==2){
        cell=[tableView dequeueReusableCellWithIdentifier:@"WantProfessionalCell"];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"LXWantViewCell" owner:nil options:nil][2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.wantMajorLab.text=arrmajor[indexPath.row];
            cell.majorDelBtn.tag=indexPath.row+1;
            [cell.majorDelBtn addTarget:self action:@selector(majorDel:) forControlEvents:UIControlEventTouchUpInside];
            
        }

    }
     return cell;
}
-(void)countryDel:(UIButton *)btn{
    [arrCountry removeObjectAtIndex:btn.tag-1];
    [_table reloadData];
}

-(void)schoolDel:(UIButton *)btn{
    [arrSchool removeObjectAtIndex:btn.tag-1];
    [_table reloadData];

}
-(void)majorDel:(UIButton *)btn{
    [arrmajor removeObjectAtIndex:btn.tag-1];
    [_table reloadData];
}

- (void)addCountry:(UIButton*)btn{
    if (arrCountry.count>=3) {
         [SVProgressHUD showErrorWithStatus:@"最多选择3个国家"];
    }else{
        LXAddViewController *add1=[[LXAddViewController alloc]init];
        [self.navigationController pushViewController:add1 animated:YES];
 
    }
    }
- (void)addSchool:(UIButton*)btn{
    if (arrSchool.count>=3) {
        [SVProgressHUD showErrorWithStatus:@"最多选择3个学校"];
    }else{
    LXAddSchoolController *add2=[[LXAddSchoolController alloc]init];
    [self.navigationController pushViewController:add2 animated:YES];
    }
}
- (void)addMajor:(UIButton*)btn{
    if (arrmajor.count>=3) {
        [SVProgressHUD showErrorWithStatus:@"最多选择3个专业"];

    }else{
    LXAddProfessionController *add3=[[LXAddProfessionController alloc]init];
    [self.navigationController pushViewController:add3 animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}

@end
