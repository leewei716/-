//
//  LXBrowserView.m
//  一起留学
//
//  Created by will on 16/7/8.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXBrowserView.h"

@interface LXBrowserView ()
//存放图片显示容器
@property (strong , nonatomic) NSMutableArray *images;
//保存已经加载的编号
@property (strong , nonatomic) NSMutableArray *pageNumbers;
//图片数
@property (assign , nonatomic) NSUInteger imageNum;
//已经翻页 (防爆) -[UIImage getFileSystemRepresentation:maxLength:]: unrecognized selector sent to instance 0x174483610
@property (assign , nonatomic) BOOL pageTurning;



@end




@implementation LXBrowserView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.images = [NSMutableArray array];
        self.pageNumbers = [NSMutableArray new];
        self.pageTurning = NO;
        //当前视图颜色
        self.backgroundColor = [UIColor clearColor];
        //设置UIScrollView可以整页滑动
        self.pagingEnabled = YES;
        //去掉水平滚动条
        self.showsHorizontalScrollIndicator = NO;
        //反弹
        self.bounces = NO;
    }
    return self;
}

+ (instancetype)browserViewWithFrame:(CGRect)frame
{
    return [[[self class] alloc] initWithFrame:frame];
}

- (void)setPageNumber:(NSUInteger)pageNumber
{
    if(!pageNumber)
    {
        NSLog(@"页面数不能为0!");
        return;
    }
    
    float itemWidth = _image_dx + self.bounds.size.width;
    
    //拼接底图
    for(int i = 0; i < pageNumber; i++)
    {
        UIView *v = [UIView new];
        //设置图片位置
        CGRect frame = CGRectMake(i * itemWidth, 0, itemWidth, self.bounds.size.height);
        v.frame = frame;
        
        //添加到当前视图控制器
        [self addSubview:v];
        [self.images addObject:v];
    }
    //设置滚动区域
    self.contentSize = CGSizeMake(itemWidth * pageNumber, self.bounds.size.height - 64);
    //当前视图向左移动 -_image_dx
    CGRect sc_frame = self.frame;
    sc_frame.size.width = itemWidth;
    self.frame = sc_frame;
}

- (void)addChildControllerToIndex:(NSUInteger)index container:(void (^)(UIView *containerView))containerView
{
    if(self.pageNumbers.count)
    {
        BOOL found = NO;
        for (NSNumber *number in self.pageNumbers)
        {
            if([number integerValue] == index)
            {
                found = YES; //退出 不添加
                break;
            }
        }
        
        if(found)
        {
            return;
        }
    }
    
    [self.pageNumbers addObject:@(index)];
    
    UIView *view = [self.images objectAtIndex:index];
    if(containerView)
    {
        containerView(view);
    }
}

//UIScrollView偏移到某一张图片,需传入图片编号
- (void)transitionToIndex:(NSInteger)idx
{
    CGPoint offset = self.contentOffset;
    offset.x = idx * self.bounds.size.width;
    self.contentOffset = offset;
}

+ (NSInteger)getCurrentPageIndex:(UIScrollView *)scrollView
{
    //得到视图划动时的偏移量
    CGPoint offset = scrollView.contentOffset;
    //NSLog(@"scrollView offset x:%f y:%f",offset.x,offset.y);
    //偏移量不足0时 当它为0
    if (offset.x <= 0)
    {
        offset.x = 0;
        scrollView.contentOffset = offset;
    }
    //得到当前界面的序号 四舍五入
    return round(offset.x / scrollView.frame.size.width);
}

@end
