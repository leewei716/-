//
//  LXFreeViewCell.h
//   一起留学
//
//  Created by will on 16/8/5.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXFreeViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *applyTitleLab;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextFld;
@property (weak, nonatomic) IBOutlet UITextField *commonTextFld;
@end
