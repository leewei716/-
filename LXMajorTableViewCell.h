//
//  LXMajorTableViewCell.h
//   一起留学
//
//  Created by will on 16/7/17.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXMajorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *SchoolMajorImage;
@property (weak, nonatomic) IBOutlet UILabel *MajorName;
@property (weak, nonatomic) IBOutlet UILabel *Master;//硕士
@property (weak, nonatomic) IBOutlet UILabel *Migrate;//移民
@property (weak, nonatomic) IBOutlet UILabel *Tuition;//xuefe
@property (weak, nonatomic) IBOutlet UILabel *IELTS;//雅思
@property (weak, nonatomic) IBOutlet UILabel *TOEFL;//托福
@property (weak, nonatomic) IBOutlet UILabel *SchoolSystem;//学制

@end
