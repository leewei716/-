//
//  SegmentedControl.m
//  一起留学
//
//  Created by will on 16/7/8.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "SegmentedControl.h"

//检测block是否可用
#define OBJC_BLOCK_EXEC(block, ...) if(block){block(__VA_ARGS__);}else{NSLog(@"block未实现:%p",block);}

//高亮条高度
#define HIGHLIGHT_BAR_HEIGHT    (2)
//下划线高度
#define UNDERLINE_HEIGHT    (1.0f)

#define LeftMargin   (3.0f)
#define TopMargin    (3.0f)
#define RightMargin  (3.0f)
#define BottomMargin (3.0f)
#define LineMargin   (3.0f)

@interface SegmentedControl()
@property (strong , nonatomic) void (^valueChanged)(NSUInteger segment);    //值发生改变时候执行
@property (strong , nonatomic) NSMutableArray *segments;    //所有分段
@property (strong , nonatomic) UIView *HighlightBar;        //点击之后的高亮条
@property (assign , nonatomic) NSUInteger segmentIndex;     //分段值
@property (assign , nonatomic) SegmentedControlStyle segmentStyle;


@end

@implementation SegmentedControl


- (NSMutableArray *)segments
{
    if (!_segments)
    {
        _segments = [NSMutableArray new];
    }
    
    return _segments;
}

- (UIColor *)normalColor
{
    if(!_normalColor)
    {
        _normalColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1];
    }
    
    return _normalColor;
}

- (UIColor *)highlightColor
{
    if(!_highlightColor)
    {
        _highlightColor = self.tintColor;
    }
    
    return _highlightColor;
}

- (NSUInteger)segmentedIndex
{
    return self.segmentIndex;
}

/**
 *  获取分段数
 */
- (NSUInteger)segmentedCount
{
    return self.segments.count;
}

/**
 *  添加分段(一组)
 */
- (void)addSegmentsFromArray:(NSArray *)segments
{
    [self.segments addObjectsFromArray:segments];
    
    if(self.tintColor)  //必须要有tintColor才能够加载界面
    {
        //加载界面
        [self loadInterface];
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    
    if(self.segments.count) //必须要有分段才能加载界面
    {
        //加载界面
        [self loadInterface];
    }
}

/**
 *  创建分段控制器
 */
+ (instancetype)segmentControlWithFrame:(CGRect)frame style:(SegmentedControlStyle)style valueChanged:(void (^)(NSUInteger segmentIndex))valueChanged
{
    return [[[self class] alloc] initWithFrame:frame style:style valueChanged:valueChanged];
}

- (instancetype)initWithFrame:(CGRect)frame style:(SegmentedControlStyle)style valueChanged:(void (^)(NSUInteger segmentIndex))valueChanged
{
    if(self = [super initWithFrame:frame])
    {
        self.valueChanged = ^(NSUInteger segmentValue){
            //传值
            OBJC_BLOCK_EXEC(valueChanged, segmentValue);
        };
        self.segmentStyle = style;
        if(style == SegmentedControlStyleRoundedRect)
        {
            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = 5;
            self.layer.borderColor = [[UIColor redColor] CGColor];
            self.layer.borderWidth = .5;
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


/**
 *  加载UI
 */
- (void)loadInterface
{
    NSInteger count = 0;
    //初始化分段值
    self.segmentIndex = 0;
    //尺寸
    CGSize size = self.bounds.size;
    //分段的宽度
    CGFloat segmentWidth = size.width / (CGFloat)self.segments.count;
    //分段按钮
    for (NSString *text in self.segments)
    {
        //按钮
        UIButton *segmentButton = [[UIButton alloc] initWithFrame:CGRectMake(count*segmentWidth, 0, segmentWidth, size.height - (self.segmentStyle == SegmentedControlStylePlain? HIGHLIGHT_BAR_HEIGHT : 0))];
        segmentButton.backgroundColor = [UIColor clearColor];
        segmentButton.tag = count;  //tag
        //标题
        [segmentButton setTitle:text forState:UIControlStateNormal];
        if(size.width == 320)   //iPhone4/4s iPhone5/5s
        {
            segmentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        else
        {
            segmentButton.titleLabel.font = [UIFont systemFontOfSize:16];
        }
        
        //事件
        [segmentButton addTarget:self action:@selector(didClickSegment:) forControlEvents:UIControlEventTouchUpInside];
        if(!count)
        {
            //默认底一个分段被选中
            [segmentButton setTitleColor:self.highlightColor forState:UIControlStateNormal];
        }
        else
        {
            [segmentButton setTitleColor:self.normalColor forState:UIControlStateNormal];
        }
        //添加
        [self addSubview:segmentButton];
        
        count++;
    }
    
    //分段高亮条
    if(self.segmentStyle == SegmentedControlStylePlain)
    {
        self.HighlightBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, segmentWidth/* - segmentWidth/3*/, HIGHLIGHT_BAR_HEIGHT)];
        self.HighlightBar.backgroundColor = self.tintColor;
        self.HighlightBar.center = CGPointMake(segmentWidth*self.segmentIndex + segmentWidth / 2.0, size.height - HIGHLIGHT_BAR_HEIGHT/2.0);
    }
    else if (self.segmentStyle == SegmentedControlStyleRoundedRect)
    {
        self.HighlightBar = [[UIView alloc] initWithFrame:CGRectMake(LeftMargin, TopMargin, segmentWidth-LeftMargin-LineMargin, size.height - TopMargin - BottomMargin)];
        self.HighlightBar.layer.masksToBounds = YES;
        self.HighlightBar.layer.cornerRadius = 5;
        self.HighlightBar.backgroundColor = self.tintColor;
    }
    
    [self insertSubview:self.HighlightBar atIndex:0];
}


- (void)didClickSegment:(UIButton *)sender
{
    //判断当前点击的索引是否是何上一次一样,如果一样就结束事件
    if(self.segmentIndex == sender.tag)
    {
        return;
    }
    //不是上一次的索引
    [self moveToSegmentIndex:sender.tag];
    //传值
    OBJC_BLOCK_EXEC(self.valueChanged, self.segmentIndex);
}

/**
 *  移动到该索引
 */
- (void)moveToSegmentIndex:(NSUInteger)segmentIndex
{
    //判断需要移动的索引是否越界
    
    if(segmentIndex > self.segments.count - 1 || self.segmentIndex == segmentIndex)
    {
        return;
    }
    
    //没有越界
    self.segmentIndex = segmentIndex;
    //尺寸
    CGSize size = self.bounds.size;
    //分段的宽度
    CGFloat segmentWidth = size.width / (CGFloat)self.segments.count;
    //设置索引所在的文字颜色
    for (id v in self.subviews)
    {
        if([v isMemberOfClass:[UIButton class]])
        {
            //先设置正常颜色
            [(UIButton *)v setTitleColor:self.normalColor forState:UIControlStateNormal];
            //判断是否是选中的按钮，然后再设置颜色
            if(((UIButton *)v).tag == segmentIndex)
            {
                [(UIButton *)v setTitleColor:self.highlightColor forState:UIControlStateNormal];
            }
        }
    }
    
    [UIView animateWithDuration:.3 animations:^{
        //移动高亮条
        if(self.segmentStyle == SegmentedControlStylePlain)
        {
            self.HighlightBar.center = CGPointMake(segmentWidth*self.segmentIndex + segmentWidth / 2.0, size.height - HIGHLIGHT_BAR_HEIGHT/2.0);
        }
        else
        {
            self.HighlightBar.center = CGPointMake(segmentWidth*self.segmentIndex + segmentWidth / 2.0, size.height/2.0);
        }
    }];
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
#if 0
    //绘制下滑线
    if(self.segmentStyle == SegmentedControlStylePlain)
    {
        CGSize size = self.bounds.size;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, 0, size.height/* - UNDERLINE_HEIGHT*/);
        CGContextAddLineToPoint(context, size.width, size.height/* - UNDERLINE_HEIGHT*/);
        CGContextSetStrokeColorWithColor(context, [self.tintColor CGColor]);
        CGContextSetLineWidth(context, UNDERLINE_HEIGHT);
        CGContextStrokePath(context);
    }
#endif
}


@end

