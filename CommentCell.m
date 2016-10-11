//
//  CommentCell.m
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import "CommentCell.h"
#import "JGGView.h"
#import "CommentModel.h"
#import "MessageModel.h"
#import "MessageCell.h"


@interface CommentCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@end
@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // title
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP;
        
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:14.0];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).offset(0.0);
        }];
        
        
        self.hyb_lastViewInCell = self.contentLabel;
        self.hyb_bottomOffsetToCell = 5.0;

    }
    
    return self;
}
//判断是进行评论还是回复
- (void)configCellWithModel:(CommentModel *)model {
    NSString *str  = nil;
    if (![model.commentByUserName isEqualToString:@""]) {
        str= [NSString stringWithFormat:@"%@回复%@：%@",
              model.commentUserName, model.commentByUserName, model.commentText];
    }else{
        str= [NSString stringWithFormat:@"%@：%@",
              model.commentUserName, model.commentText];
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    [text addAttribute:NSForegroundColorAttributeName
                 value:TabBarColor
                 range:NSMakeRange(0, model.commentUserName.length)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:TabBarColor
                 range:NSMakeRange(model.commentUserName.length + 2, model.commentByUserName.length)];
    self.contentLabel.attributedText = text;
}

@end

