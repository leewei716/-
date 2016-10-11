//
//  LXSchoolLocationController.m
//   一起留学
//
//  Created by will on 16/7/21.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXSchoolLocationController.h"
#import "LXChooseViewCell.h"
#import "LXLikeMajorController.h"


@interface LXSchoolLocationController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  UITableView *table;
@end

@implementation LXSchoolLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=BackColor;
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    
    UITableView *table=[[UITableView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(74), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(406))];
    table.delegate=self;
    table.dataSource=self;
    _table=table;
    table.showsVerticalScrollIndicator=NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXChooseViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ChooseCell"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"LXChooseViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        //        取消选中状态
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.accessoryType = UITableViewCellAccessoryNone;


    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *index = [self.table indexPathForSelectedRow];
        LXChooseViewCell *cell = [self.table cellForRowAtIndexPath:index];
    
    if (cell.selectImg.highlighted==YES) {
        
//        [self.navigationController popViewControllerAnimated:YES];
//        发送请求
        LXLikeMajorController *like=[[LXLikeMajorController alloc]init];
        [self.navigationController pushViewController:like animated:YES];
    }
}

- (IBAction)backBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
