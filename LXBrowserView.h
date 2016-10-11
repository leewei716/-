//
//  LXBrowserView.h
//  一起留学
//
//  Created by will on 16/7/8.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMG_BROWSER_TAG (10)    //imageBrowser的tag

@interface LXBrowserView : UIScrollView
//图片之间的间隔
@property (assign , nonatomic) CGFloat image_dx;
//图片下标
@property (assign , nonatomic) NSUInteger index;


/**
 *  创建浏览
 *
 *  @param frame frame
 *
 *  @return 返回当前视图实例
 */
+ (instancetype)browserViewWithFrame:(CGRect)frame;

/**
 *  设置页数
 *
 *  @param pageNumber 有多少页
 */
- (void)setPageNumber:(NSUInteger)pageNumber;


/**
 *  切换到该索引
 *
 *  @param idx 要切换的索引
 */
- (void)transitionToIndex:(NSInteger)idx;

/**
 *  添加视图控制器到该索引
 *
 *  @param index           当前索引
 *  @param placeholderView 占位视图
 */
- (void)addChildControllerToIndex:(NSUInteger)index container:(void (^)(UIView *containerView))containerView;

/**
 *  获取页数  必须在代理方法scrollViewDidScroll:中计算
 *
 *  @param scrollView 当前ScrollView
 *
 *  @return 返回页数
 */
+ (NSInteger)getCurrentPageIndex:(UIScrollView *)scrollView;


@end
