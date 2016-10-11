//
//  CommentModel.h
//  一起留学
//
//  Created by will on 16/6/28.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property (nonatomic, copy) NSString *uid;//
@property (nonatomic, assign) BOOL isExpand;//
@property(nonatomic,copy)NSString *commentId;//评论ID
@property(nonatomic,copy)NSString *commentUserId;//
@property(nonatomic,copy)NSString *commentUserName;//评论者
@property(nonatomic,copy)NSString *commentPhoto;//
@property(nonatomic,copy)NSString *commentText;//评论内容
@property(nonatomic,copy)NSString *commentByUserId;//回复者ID
@property(nonatomic,copy)NSString *commentByUserName;//回复者名字
@property(nonatomic,copy)NSString *commentByPhoto;//
@property(nonatomic,copy)NSString *createDateStr;//创建时间
@property(nonatomic,copy)NSString *checkStatus;//
///评论大图
@property(nonatomic,copy)NSMutableArray *messageBigPicArray;

// 评论数据源
@property (nonatomic,copy) NSMutableArray *commentModelArray;

@property (nonatomic, assign) BOOL shouldUpdateCache;

-(instancetype)initWithDic:(NSDictionary *)dic;


@end
