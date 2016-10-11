//
//  LXDDSortView.h
//   一起留学
//
//  Created by will on 16/8/13.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXDDSortView : UIView
- (instancetype)initWithFrames:(CGRect)frame channelLists:(NSMutableArray *)channelLists;

/** 箭头按钮点击回调 */
@property (nonatomic, copy) void(^arrowBtnClickBlock)();
/** 排序完成回调 */
@property (nonatomic, copy) void(^sortCompletedBlock)(NSMutableArray *channelList);
/** cell按钮点击回调 */
@property (nonatomic, copy) void(^cellButtonClick)(UIButton *button);
@end
