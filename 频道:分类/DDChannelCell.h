//
//  DDChannelCell.h
//  DDNews
//
//  Created by Dvel on 16/4/7.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXCountryForumController;

@interface DDChannelCell : UICollectionViewCell
@property (nonatomic, strong) LXCountryForumController *CountryForum;
@property (nonatomic, copy  ) NSString  *urlString;

@end
