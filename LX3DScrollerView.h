//
//  LX3DScrollerView.h
//   一起留学
//
//  Created by will on 16/8/6.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ClickImgDelegate <NSObject>//点击图片的协议

-(void)ClickImg:(int)index;//点击图片的方法

@end

@interface LX3DScrollerView : UIView
@property (nonatomic, assign)int currentIndex;//当前图片的下标

@property (nonatomic, strong)UIImageView *imageView;//图片

@property (nonatomic, strong)NSArray *imageArr;//图片数组

@property (assign, nonatomic) id <ClickImgDelegate> delegate;

//声明页码器的属性
@property(nonatomic,strong)UIPageControl *pageControl;

//动画模式
@property(nonatomic,strong)NSArray * animationModeArr;

//显示3D广告的方法
- (void)show3DBannerView;
@end
