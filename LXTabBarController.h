//
//  LXTabBarController.h
//  一起留学
//
//  Created by will on 16/7/8.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXTabBarController : UIViewController
/**
 *  子视图控制器个数
 */
- (NSUInteger)viewControllerCount;

/**
 *  视图切换完成是调用
 */
- (void)viewBrowserDidScroll:(NSInteger)index;

/**
 *  切换视图控制器
 *  @param index 下标
 */
- (void)transitionToViewControllerIndex:(NSUInteger)index;

/**
 *  获取子视图控制器
 *
 *  @return 返回获取到的子视图控制器数组
 */
- (NSArray *)getChildViewController;
@end
