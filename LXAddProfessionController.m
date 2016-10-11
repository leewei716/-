//
//  LXAddProfessionController.m
//   一起留学
//
//  Created by will on 16/8/12.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXAddProfessionController.h"
#import "LXAddThreeTableCell.h"
@interface LXAddProfessionController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain)NSArray *arr;

@end

@implementation LXAddProfessionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=BackColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    _arr=@[@"澳大利亚专业",@"新西兰专业",@"英国专业",@"美国专业",@"法国专业",@"德国专业",@"新加坡专业",@"日本专业",@"香港专业",@"澳门专业",@"巴西专业"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LXAddThreeTableCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cellone"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"LXAddThreeTableCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.MajorLable.text=_arr[indexPath.row];
        cell.MajorLable.tag=indexPath.row;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    LXAddThreeTableCell *cell = [self.tableView cellForRowAtIndexPath:index];
    if (cell.wantMajorImg.highlighted==YES) {
        NSDictionary * dic = @{@"Major":cell.MajorLable.text};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MajorLableText" object:nil userInfo:dic];
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
