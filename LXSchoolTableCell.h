//
//  LXSchoolTableCell.h
//   一起留学
//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXSchoolTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *School;
@property (weak, nonatomic) IBOutlet UIImageView *SchoolImage;
@property (weak, nonatomic) IBOutlet UILabel *SchoolName;
@property (weak, nonatomic) IBOutlet UILabel *SchoolAddress;

@property (weak, nonatomic) IBOutlet UILabel *rank;
@end
