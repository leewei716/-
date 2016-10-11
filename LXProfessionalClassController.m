//
//  LXProfessionalClassController.m
//   一起留学
//
//  Created by will on 16/7/19.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXProfessionalClassController.h"
#import "LXProfessionalClassCell.h"

@interface LXProfessionalClassController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,strong)NSArray *arr1;

@end

@implementation LXProfessionalClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table=[[UITableView alloc]init];
    if (ScreenHeight==480) {
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(-20), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(268+20+24));
    }else if (ScreenHeight==568){
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(-8), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(228+20+24));
    }else if (ScreenHeight==667){
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(-13), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(188+20+24));
    }else{
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(-8), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(168+20+24));
    }
    table.delegate=self;
    table.dataSource=self;
//    courseTabel.scrollEnabled=NO;
    [self setExtraCellLineHidden:table];
    [self.view addSubview:table];
    _arr=@[@"第一学期",@"算法和复杂性",@"编程和软件开发",@"第二学期",@"软件建模和设计",@"跨学期选修课(选择12.5分1和2)",@"计算机系统",@"人工智能",@"第三学期",@"可用性工程",@"网络信息技术",@"第学四期",@"知识技术",@"计算5模型"];
    _arr1=@[@"SEMESTER 1",@"Engineering Computation",@"Algorithms and Complexity",@"SEMESTER 2",@"ELECTIVES (selec 12.5 POINTS ACROSS SEMESTERS 1 AND 2)",@"Computer Systems",@"Artificial Intelligence",@"Usability Engineering",@"SEMESTER 3",@"Web Information Technologies",@"Knowledge Technologie",@"SEMESTER 4",@"Models of Computation5",@"Internet Technologies"];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXProfessionalClassCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"LXProfessionalClassCell" owner:nil options:nil];
        cell = [nibs lastObject];
        
        //        取消选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.EnglishLab.text=_arr1[indexPath.row];
        cell.ChinaLab.text=_arr[indexPath.row];
        
        
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
