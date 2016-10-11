//
//  LXDDSortView.m
//   一起留学
//
//  Created by will on 16/8/13.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXDDSortView.h"
#import "LXDDChannelModel.h"
#import "LXDDSortCell.h"
#import "LXDDSortCell_first.h"

#import "LXReorderableCollectionViewFlowLayout.h"
#import "UIView+Extension.h"

static NSString * const reuseID1 = @"ShouYeCell";
static NSString * const reuseID2 = @"OthersCell";

@interface LXDDSortView () <LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *channelList2;
@end

@implementation LXDDSortView

- (instancetype)initWithFrames:(CGRect)frame channelLists:(NSMutableArray *)channelLists
{
    _channelList2 = channelLists.mutableCopy;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 上面高度44的描述栏(覆盖smallScrollView)
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 0, 0)];
        label.text = @"点击进入，长按拖动";
        label.font = [UIFont systemFontOfSize:15];
        [label sizeToFit];
        [self addSubview:label];
        // 右上角加个XX
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScrW-44, 0, 44, 44)];
        [closeBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(arrowButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        // 中间的排序collectionView,
        LXReorderableCollectionViewFlowLayout *flowLayout = [LXReorderableCollectionViewFlowLayout new];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44,
                                                                                              frame.size.width,
                                                                                              frame.size.height - 44 - 49)
                                                              collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[LXDDSortCell_first class] forCellWithReuseIdentifier:reuseID1];
        [collectionView registerClass:[LXDDSortCell class] forCellWithReuseIdentifier:reuseID2];
        [self addSubview:collectionView];
        
        // 设置cell的大小和细节,每排4个
        CGFloat margin = 20.0;
        CGFloat width  = ([UIScreen mainScreen].bounds.size.width - margin * 5) / 4.f;
        CGFloat height = width * 3.f / 7.f; // 按图片比例来的
        flowLayout.sectionInset = UIEdgeInsetsMake(5, margin, 10, margin);
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.minimumLineSpacing = 20;
        
        // 下面49高度的箭头（覆盖tabbar）
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(collectionView.frame),
                                                                      frame.size.width, 49)];
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:[UIImage imageNamed:@"up_arrow"] forState:UIControlStateNormal];
        button.layer.shadowColor = [UIColor whiteColor].CGColor;
        button.layer.shadowRadius = 5;
        button.layer.shadowOffset = CGSizeMake(0, -10);
        button.layer.shadowOpacity = 1;
        [button addTarget:self action:@selector(arrowButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _channelList2.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LXDDSortCell_first *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID1 forIndexPath:indexPath];
        LXDDChannelModel *first = _channelList2[0];
        [cell.button setTitle:first.tname2 forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        LXDDSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID2 forIndexPath:indexPath];
        [cell.button setTitle:[_channelList2[indexPath.row] valueForKey:@"tname2"] forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 在每个cell下面生成一个虚线的框框
        UIButton *placeholderBtn = [[UIButton alloc] initWithFrame:cell.frame];
        [placeholderBtn setBackgroundImage:[UIImage imageNamed:@"channel_sort_placeholder"] forState:UIControlStateNormal];
        placeholderBtn.width  -= 1;		placeholderBtn.centerX = cell.centerX;
        placeholderBtn.height -= 1;		placeholderBtn.centerY = cell.centerY;
        [collectionView insertSubview:placeholderBtn atIndex:0];
        
        return cell;
    }
}

#pragma mark LXReorderableCollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    LXDDChannelModel *model = _channelList2[fromIndexPath.item];
    [_channelList2 removeObjectAtIndex:fromIndexPath.item];
    [_channelList2 insertObject:model atIndex:toIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (self.sortCompletedBlock) {
        self.sortCompletedBlock(_channelList2);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {return NO;}
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.row == 0 || toIndexPath.row == 0) {return NO;}
    return YES;
}

#pragma mark 点击事件
/** 箭头按钮点击事件 */
- (void)arrowButtonClick
{
    self.arrowBtnClickBlock();
}

/** cell按钮点击事件 */
- (void)cellButtonClick:(UIButton *)button
{
    if (self.cellButtonClick) {
        self.cellButtonClick(button);
    }
}

@end
