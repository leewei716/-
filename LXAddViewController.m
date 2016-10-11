//
//  LXAddViewController.m
//   一起留学
//
//  Created by will on 16/8/11.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXAddViewController.h"
#import "LXADDTableCell.h"

@interface LXAddViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain)NSArray *arr;

@end

@implementation LXAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=BackColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    _arr=@[@"澳大利亚",@"新西兰",@"英国",@"美国",@"法国",@"德国",@"新加坡",@"日本",@"香港",@"澳门",@"巴西"];


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LXADDTableCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cellone"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"LXADDTableCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.countryLab.text=_arr[indexPath.row];
        cell.countryLab.tag=indexPath.row;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    LXADDTableCell *cell = [self.tableView cellForRowAtIndexPath:index];
    NSLog(@"=====%@++++++++%ld------%ld",cell.countryLab.text,(long)cell.countryLab.tag,(long)indexPath.row);
    if (cell.wantCountryImg.highlighted==YES) {
         NSDictionary * dic = @{@"Country":cell.countryLab.text};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CountreyLableText" object:nil userInfo:dic];
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
