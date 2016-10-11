//
//  LXNEWViewController.m
//   一起留学
//
//  Created by will on 16/7/17.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXNEWViewController.h"
#import "LXClassViewCell.h"
@interface LXNEWViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LXNEWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BackColor;
    UITableView *table=[[UITableView alloc]init];
    if (ScreenHeight==480) {
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(20), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(380));
    } else  if (ScreenHeight==568) {
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(10), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(390));
    }
    else {
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(400));
    }
    table.delegate=self;
    table.dataSource=self;
//    table.showsVerticalScrollIndicator=NO;
//    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 20;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXClassViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellThree"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"LXClassViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        //        取消选中状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    LXDetailViewController *de=[[LXDetailViewController alloc]init];
    //    [self.navigationController pushViewController:de animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
