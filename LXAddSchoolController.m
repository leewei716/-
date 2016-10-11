//
//  LXAddSchoolController.m
//   一起留学
//
//  Created by will on 16/8/12.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXAddSchoolController.h"
#import "LXAddTwoTableViewCell.h"
@interface LXAddSchoolController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain)NSArray *arr;


@end

@implementation LXAddSchoolController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=BackColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    _arr=@[@"澳大利亚学校",@"新西兰学校",@"英国学校",@"美国学校",@"法国学校",@"德国学校",@"新加坡学校",@"日本学校",@"香港学校",@"澳门学校",@"巴西学校"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LXAddTwoTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cellone"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"LXAddTwoTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.SchoolLable.text=_arr[indexPath.row];
        cell.SchoolLable.tag=indexPath.row;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    LXAddTwoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    if (cell.wantSchoolImg.highlighted==YES) {
        NSDictionary * dic = @{@"School":cell.SchoolLable.text};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SchoolLableText" object:nil userInfo:dic];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
