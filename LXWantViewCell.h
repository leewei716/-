//
//  LXWantViewCell.h
//   一起留学
//
//  Created by will on 16/7/20.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXWantViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *countryDelBtn;
@property (weak, nonatomic) IBOutlet UIButton *schoolDelBtn;
@property (weak, nonatomic) IBOutlet UIButton *majorDelBtn;

@property (weak, nonatomic) IBOutlet UILabel *wantCountryLab;
@property (weak, nonatomic) IBOutlet UILabel *wantSchoolLab;

@property (weak, nonatomic) IBOutlet UILabel *wantMajorLab;


@end
