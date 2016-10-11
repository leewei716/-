//
//  LXRecommendController.m
//   一起留学
//
//  Created by will on 16/7/18.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXRecommendController.h"
#import "LXRecommendCell.h"
#import "LXSchllodetailedController.h"

@interface LXRecommendController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LXRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *table=[[UITableView alloc]init];
    if (ScreenHeight==480) {
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(3), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(280+20+24));
    }else if (ScreenHeight==568){
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(3), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(240+20+24));
    }else if (ScreenHeight==667){
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(3), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(200+20+24));
    }else{
        table.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(3), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(160+20+24));
    }
    NSLog(@"-----------tableview======---%F,-------%F",table.height,self.view.height);
    
   
//    table.scrollEnabled=NO;
    table.delegate=self;
    table.dataSource=self;
      [self setExtraCellLineHidden:table];
    [self.view addSubview:table];
    
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     LXRecommendCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Recommend Cell"];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"LXRecommendCell" owner:nil options:nil];
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
