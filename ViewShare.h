//
//  ViewShare.h
//  QuHuWai
//
//  Created by wzkj on 15/5/11.
//  Copyright (c) 2015年 Wzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#define VIEWSHARE_IMG_N @"VIEWSHARE_IMG_N"
#define VIEWSHARE_IMG_H @"VIEWSHARE_IMG_H"
#define VIEWSHARE_TITLE @"VIEWSHARE_TITLE"

#ifdef __BLOCKS__
typedef void (^ViewShareBlock)(int idx);
#endif
@interface ViewShare : UIView
+(instancetype)Instance;
-(void)showButtonArr:(NSArray *)buttons WithBlock:(ViewShareBlock)_block;
@end
