//
//  MessageCell.h
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGGView.h"
@class MessageModel;

@protocol ReloadMessageCellHightDelegate <NSObject>

- (void)reloadCellHeightForModel:(MessageModel *)model atIndexPath:(NSIndexPath *)indexPath;

@end



@interface MessageCell : UITableViewCell

@property (nonatomic, strong) JGGView *jggView;
@property(nonatomic,strong)UILabel *lookNumberLab;//浏览数

/**
 *  评论按钮的block
 */
@property (nonatomic, copy)void(^CommentBtnClickBlock)(UIButton *commentBtn,NSIndexPath * indexPath);

/**
 *  更多按钮的block
 */
@property (nonatomic, copy)void(^MoreBtnClickBlock)(UIButton *moreBtn,NSIndexPath * indexPath);


/**
 *  浏览图片等block
 */
@property (nonatomic, copy)TapBlcok tapBlock;


@property (nonatomic, weak) id<ReloadMessageCellHightDelegate> delegate;

- (void)configCellWithModel:(MessageModel *)model indexPath:(NSIndexPath *)indexPath;


@end
