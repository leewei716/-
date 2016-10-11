//
//  LXVideoViewController.m
//   一起留学
//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXVideoViewController.h"
#import "LXSchoolVideoCell.h"

@interface LXVideoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LXVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"视频";
    self.view.backgroundColor=BackColor;
    
    UITableView *table=[[UITableView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(480))];
    
    table.delegate=self;
    table.dataSource=self;
//    table.showsVerticalScrollIndicator = NO;
//    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXSchoolVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SchoolVideoCell"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"LXSchoolVideoCell" owner:nil options:nil];
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
}


@end
