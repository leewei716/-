//
//  MessagesCell.m
//   一起留学
//
//  Created by will on 16/8/4.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "MessagesCell.h"

#import "MessageModel.h"
#import "CommentCell.h"

#import "UIImageView+WebCache.h"


@interface MessagesCell () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) MessageModel *messageModel;

@property (nonatomic, strong) NSIndexPath *indexPath;


@property(nonatomic,strong)UILabel *commentLab;
@property(nonatomic,strong)UILabel *lookLab;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *commentNumberLab;
@property(nonatomic,strong)UILabel *timeLab;


@end

@implementation MessagesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headImageView = [[UIImageView alloc] init];
        self.headImageView.backgroundColor = [UIColor whiteColor];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(kGAP);
            make.width.height.mas_equalTo(kAvatar_Size);
        }];
        self.headImageView.clipsToBounds = YES;
        self.headImageView.layer.cornerRadius = kAvatar_Size/2;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        self.headImageView.userInteractionEnabled = YES;
        tapGesture.numberOfTapsRequired = 1;
        [self.headImageView addGestureRecognizer:tapGesture];
        
        
        //         nameLabel
        self.nameLabel = [UILabel new];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
        self.nameLabel.preferredMaxLayoutWidth = screenWidth - kGAP-kAvatar_Size - 2*kGAP;
        self.nameLabel.numberOfLines = 0;
        //        self.nameLabel.displaysAsynchronously = YES;
        self.nameLabel.font = [UIFont systemFontOfSize:14.0];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
            make.top.mas_equalTo(self.headImageView);
            make.right.mas_equalTo(-kGAP);
        }];
        
        
        self.timeLab = [UILabel new];
        [self.contentView addSubview:self.timeLab];
        self.timeLab.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
        self.timeLab.preferredMaxLayoutWidth = screenWidth - kGAP-kAvatar_Size - 2*kGAP;
//        self.timeLab.text=@"一小时前";
        self.timeLab.numberOfLines = 0;
        //self.nameLabel.displaysAsynchronously = YES;
        self.timeLab.font = [UIFont systemFontOfSize:9.0];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2);
            make.right.mas_equalTo(self.nameLabel.mas_right);
        }];
        
        
        self.titleLab = [UILabel new];
        [self.contentView addSubview:self.titleLab];
        self.titleLab.textColor = [UIColor blackColor];
        self.titleLab.preferredMaxLayoutWidth = screenWidth - kGAP-kAvatar_Size - 2*kGAP;
//        self.titleLab.text=@"2016年澳洲墨尔本大学工商及硕士录取标准";
        self.titleLab.numberOfLines = 0;
        //        self.nameLabel.displaysAsynchronously = YES;
        self.titleLab.font = [UIFont systemFontOfSize:15.0];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
            make.top.mas_equalTo(self.timeLab.mas_bottom).offset(2);
            make.right.mas_equalTo(self.nameLabel.mas_right);
        }];
        
        
        
        
        // desc
        self.descLabel = [UILabel new];
        //        self.descLabel.displaysAsynchronously = YES;
        self.descLabel.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.descLabel];
        self.descLabel.preferredMaxLayoutWidth =screenWidth - kGAP-kAvatar_Size-2*kGAP;
        self.descLabel.textColor=TextColor;
        self.descLabel.numberOfLines = 0;
        self.descLabel.font = [UIFont systemFontOfSize:14.0];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.top.mas_equalTo(self.headImageView.mas_bottom).offset(10);
        }];
        
        
        
        self.commentLab=[UILabel new];
        self.commentLab.backgroundColor = [UIColor whiteColor];
        self.commentLab.text=@"评论";
        self.commentLab.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.commentLab];
        self.commentLab.preferredMaxLayoutWidth =screenWidth - kGAP-kAvatar_Size - 2*kGAP;
        self.commentLab.numberOfLines = 0;
        self.commentLab.textAlignment=1;
        self.commentLab.font = [UIFont systemFontOfSize:10.0];
        [self.commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            //            make.top.mas_equalTo(self.contentView.mas_top).offset(2);
            make.bottom.mas_equalTo(self.timeLab.mas_top).offset(kGAP);
        }];
        //        评论数
        self.commentNumberLab=[UILabel new];
        self.commentNumberLab.backgroundColor = [UIColor whiteColor];
//      self.commentNumberLab.text=@"12";
        self.commentNumberLab.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.commentNumberLab];
        self.commentNumberLab.preferredMaxLayoutWidth =screenWidth - kGAP-kAvatar_Size - 2*kGAP;
        self.commentNumberLab.numberOfLines =0;
        self.commentNumberLab.textAlignment=1;
        self.commentNumberLab.font = [UIFont systemFontOfSize:12.0];
        [self.commentNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.commentLab.mas_right);
            make.top.mas_equalTo(self.nameLabel.mas_top).offset(-3);
        }];
        //
        self.lookLab=[UILabel new];
        self.lookLab.backgroundColor = [UIColor whiteColor];
        self.lookLab.text=@"浏览";
        self.lookLab.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.lookLab];
        self.lookLab.preferredMaxLayoutWidth =screenWidth - kGAP-kAvatar_Size - 2*kGAP;
        self.lookLab.numberOfLines = 0;
        self.lookLab.textAlignment=1;
        self.lookLab.font = [UIFont systemFontOfSize:10.0];
        [self.lookLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-50);
            make.bottom.mas_equalTo(self.timeLab.mas_top).offset(kGAP);
        }];
        //   浏览数
        self.lookNumberLab=[UILabel new];
        self.lookNumberLab.backgroundColor = [UIColor whiteColor];
//        self.lookNumberLab.text=@"123";
        self.lookNumberLab.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.lookNumberLab];
        self.lookNumberLab.preferredMaxLayoutWidth =screenWidth - kGAP-kAvatar_Size - 2*kGAP;
        self.lookNumberLab.numberOfLines = 0;
        self.lookNumberLab.textAlignment=1;
        self.lookNumberLab.font = [UIFont systemFontOfSize:12.0];
        [self.lookNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.lookLab.mas_right);
            make.top.mas_equalTo(self.nameLabel.mas_top).offset(-3);}];
        
 
        
        self.jggView = [JGGView new];
        [self.contentView addSubview:self.jggView];
        [self.jggView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom).offset(kGAP);
        }];
        
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentBtn.backgroundColor = [UIColor whiteColor];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateSelected];
        [self.commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.commentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.commentBtn.layer.borderWidth = 1;
        self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateNormal];
        [self.commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateSelected];
        [self.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.commentBtn];
        self.commentBtn.layer.cornerRadius = 20/2;
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.jggView.mas_bottom).offset(kGAP);
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(20);
        }];
        
        
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.scrollEnabled = NO;
        [self.contentView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.jggView);
            make.top.mas_equalTo(self.commentBtn.mas_bottom).offset(kGAP);
            make.right.mas_equalTo(-kGAP);
        }];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.hyb_lastViewInCell = self.tableView;
        self.hyb_bottomOffsetToCell = 0.0;
    }
    
    return self;
}




-(void)commentAction:(UIButton *)sender{
    if (self.CommentBtnClickBlock) {
        self.CommentBtnClickBlock(sender,self.indexPath);
    }
}
- (void)configCellWithModel:(MessageModel *)model indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    self.nameLabel.text = model.userName;
    self.descLabel.text = model.message;
    self.lookNumberLab.text=model.lookNumber;
    self.commentNumberLab.text=model.commentNumber;
    self.titleLab.text=model.postTitle;
    self.timeLab.text=model.timeTag;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.messageModel = model;
    NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc]init];
    muStyle.lineSpacing = 2;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:muStyle};
    
    
    CGFloat h = [model.message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    
    
    CGFloat jjg_height = 0.0;
    CGFloat jjg_width = 0.0;
    if (model.messageBigPics.count>0&&model.messageBigPics.count<=3) {
        jjg_height = [JGGView imageHeight];
        jjg_width  = (model.messageBigPics.count)*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }else if (model.messageBigPics.count>3&&model.messageBigPics.count<=6){
        jjg_height = 2*([JGGView imageHeight]+kJGG_GAP)-kJGG_GAP;
        jjg_width  = 3*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }else  if (model.messageBigPics.count>6&&model.messageBigPics.count<=9){
        jjg_height = 3*([JGGView imageHeight]+kJGG_GAP)-kJGG_GAP;
        jjg_width  = 3*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
    }
    
    [self.jggView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.jggView JGGView:self.jggView DataSource:model.messageBigPics completeBlock:^(NSInteger index, NSArray *dataSource) {
        self.tapBlock(index,dataSource);
    }];
    [self.jggView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.descLabel);
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(kJGG_GAP);
        make.size.mas_equalTo(CGSizeMake(jjg_width, jjg_height));
    }];
    
    CGFloat tableViewHeight = 0;
    for (CommentModel *commentModel in model.commentModelArray) {
        CGFloat cellHeight = [CommentCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
            CommentCell *cell = (CommentCell *)sourceCell;
            [cell configCellWithModel:commentModel];
        } cache:^NSDictionary *{
            return @{kHYBCacheUniqueKey : commentModel.uid,
                     kHYBCacheStateKey : @"",
                     kHYBRecalculateForStateKey : @(NO)};
        }];
        tableViewHeight += cellHeight;
    }
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableViewHeight);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    CommentModel *model = [self.messageModel.commentModelArray objectAtIndex:indexPath.row];
    [cell configCellWithModel:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageModel.commentModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *model = [self.messageModel.commentModelArray objectAtIndex:indexPath.row];
    CGFloat cell_height = [CommentCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
        CommentCell *cell = (CommentCell *)sourceCell;
        [cell configCellWithModel:model];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : model.uid,
                                kHYBCacheStateKey : @"",
                                kHYBRecalculateForStateKey : @(NO)};
        //        model.shouldUpdateCache = NO;
        return cache;
    }];
    return cell_height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//     添加一条数据
        CommentModel *model = [[CommentModel alloc] init];
        model.commentUserName = @"小明";
        model.commentByUserName = @"帕瓦罗蒂";
        model.commentText = @"哈哈，我被点击后自动添加了一条数据的，不要在意我哈哈，我被点击后自动添加了一条数据的，不要在意我~哈哈，我被点击后自动添加了一条数据的，不要在意我~哈哈，我被点击后自动添加了一条数据的，不要在意我123456789";
        model.uid = [NSString stringWithFormat:@"commonModel%lu",  self.messageModel.commentModelArray.count + 1];
        [self.messageModel.commentModelArray addObject:model];
    
        if ([self.delegate respondsToSelector:@selector(reloadCellHeightForModel:atIndexPath:)]) {
            self.messageModel.shouldUpdateCache = YES;
            [self.delegate reloadCellHeightForModel:self.messageModel atIndexPath:self.indexPath];
        }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.messageModel.commentModelArray removeObjectAtIndex:indexPath.row];
        
        if ([self.delegate respondsToSelector:@selector(reloadCellHeightForModel:atIndexPath:)]) {
            self.messageModel.shouldUpdateCache = YES;
            [self.delegate reloadCellHeightForModel:self.messageModel atIndexPath:self.indexPath];
        }
    }
}
- (void) imageTap:(UITapGestureRecognizer *) tapGesture{
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"headImgs" object:nil];
    
    
}

@end
