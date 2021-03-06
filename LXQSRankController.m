//
//  LXQSRankController.m
//   一起留学
//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXQSRankController.h"
#import "LXSchoolTableCell.h"
#import "LXSchllodetailedController.h"
@interface LXQSRankController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LXQSRankController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackColor;
    
    UITableView *table=[[UITableView alloc]init];
    if (ScreenHeight==480) {
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(20), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(380));
    } else  if (ScreenHeight==568) {
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(10), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(390));
    } else {
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(400));
    }
    table.showsVerticalScrollIndicator=NO;
//    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate=self;
    table.dataSource=self;
    [self.view addSubview:table];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 20;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXSchoolTableCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CellOne"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"LXSchoolTableCell" owner:nil options:nil];
        cell = [nibs lastObject];
        //        取消选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.School.text=@"澳大利亚国立大学";
        cell.SchoolName.text=@"The University of Melbourne";
        cell.SchoolImage.image=[UIImage imageNamed:@"guoli.png"];
        cell.SchoolAddress.text=@"新南威尔士的首府悉尼市中心西南";
        cell.rank.text=@"138";
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LXSchllodetailedController *de=[[LXSchllodetailedController alloc]init];
    [self.navigationController pushViewController:de animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
