//
//  LXOtherWantController.m
//   一起留学
//
//  Created by will on 16/7/25.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXOtherWantController.h"
#import "LXOtherSetingCell.h"

@interface LXOtherWantController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LXOtherWantController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    //    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *table=[[UITableView alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(480)*12)];
    table.delegate=self;
    table.dataSource=self;
    table.scrollEnabled=NO;
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
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //    NSArray *arr=@[@"想去的国家",@"想去的学校",@"想去的专业"];
    UILabel *want=[[UILabel alloc]initWithFrame:CGRectMake(FLEXIBLE_NUMX(15), FLEXIBLE_NUMY(55), FLEXIBLE_NUMX(250), FLEXIBLE_NUMY(55))];
    
    want.backgroundColor=BackColor;
    if (section==0) {
        want.text=@"    想去的国家";
        want.font=[UIFont systemFontOfSize:14];
        want.textColor=TextColor;
       
        
    }if (section==1) {
        want.text=@"    想去的学校";
        want.font=[UIFont systemFontOfSize:14];
        want.textColor=TextColor;
    }if (section==2) {
        want.text=@"    想去的专业";
        want.font=[UIFont systemFontOfSize:14];
        want.textColor=TextColor;
    }
    return want;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    LXOtherSetingCell *cell=nil;
    if (indexPath.section==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"WantViewCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"LXOtherSetingCell" owner:self options:nil][0] ;
            //            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }if (indexPath.section==1){
        cell=[tableView dequeueReusableCellWithIdentifier:@"WantSchoollCell"];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"LXOtherSetingCell" owner:nil options:nil][1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
    }if (indexPath.section==2){
        cell=[tableView dequeueReusableCellWithIdentifier:@"WantProfessionalCell"];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"LXOtherSetingCell" owner:nil options:nil][2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }
        
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
