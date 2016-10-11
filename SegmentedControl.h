//
//  SegmentedControl.h
//  一起留学
//
//  Created by will on 16/7/8.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SegmentedControlStyle)
{
    SegmentedControlStylePlain,         //无风格
    SegmentedControlStyleRoundedRect    //圆角矩形
};

@interface SegmentedControl : UIView
@property (strong , nonatomic) UIColor *tintColor;      //主色
//文字颜色
@property (strong , nonatomic) UIColor *highlightColor; //高亮色
@property (strong , nonatomic) UIColor *normalColor;    //正常色


/**
 *  创建分段控制器
 */
+ (instancetype)segmentControlWithFrame:(CGRect)frame style:(SegmentedControlStyle)style valueChanged:(void (^)(NSUInteger segmentIndex))valueChanged;

/**
 *  添加分段(一组),添加分段的标题即可
 */
- (void)addSegmentsFromArray:(NSArray *)segments;

/**
 *  移动到该索引，移动到某一个分段上面
 */
- (void)moveToSegmentIndex:(NSUInteger)segmentIndex;

/**
 *  获得当前分段值
 */
- (NSUInteger)segmentedIndex;

/**
 *  获取总的分段数
 */
- (NSUInteger)segmentedCount;


@end
