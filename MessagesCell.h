//
//  MessagesCell.h
//   一起留学
//
//  Created by will on 16/8/4.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGGView.h"
@class MessageModel;

@protocol ReloadMessageCellHightDelegate <NSObject>

- (void)reloadCellHeightForModel:(MessageModel *)model atIndexPath:(NSIndexPath *)indexPath;

@end


@interface MessagesCell : UITableViewCell

@property (nonatomic, strong) JGGView *jggView;
@property(nonatomic,strong)UILabel *lookNumberLab;

/**
 *  评论按钮的block
 */
@property (nonatomic, copy)void(^CommentBtnClickBlock)(UIButton *commentBtn,NSIndexPath * indexPath);

/**
 *  更多按钮的block
 */
//@property (nonatomic, copy)void(^MoreBtnClickBlock)(UIButton *moreBtn,NSIndexPath * indexPath);


/**
 *  浏览图片等block
 */
@property (nonatomic, copy)TapBlcok tapBlock;


@property (nonatomic, weak) id<ReloadMessageCellHightDelegate> delegate;

- (void)configCellWithModel:(MessageModel *)model indexPath:(NSIndexPath *)indexPath;


@end
