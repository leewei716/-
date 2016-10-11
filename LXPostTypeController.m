//
//  LXPostTypeController.m
//   一起留学
//
//  Created by will on 16/8/11.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXPostTypeController.h"
#import "LXpostTypeCell.h"

@interface LXPostTypeController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain)NSArray *arr;
@end

@implementation LXPostTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
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
  
    LXpostTypeCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cellone"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"LXpostTypeCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.countryPostLab.text=_arr[indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    LXpostTypeCell *cell = [self.tableView cellForRowAtIndexPath:index];
    NSLog(@"=====%@++++++++%ld------%ld",cell.countryPostLab.text,(long)cell.countryPostLab.tag,indexPath.row);
    if (cell.postImg.highlighted==YES) {
      
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
