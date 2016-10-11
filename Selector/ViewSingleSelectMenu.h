//
//  ViewSingleSelectMenu.h
//  QuHuWai
//
//  Created by wzkj on 14-10-15.
//  Copyright (c) 2014年 Wzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewSingleSelectMenu;
#ifdef __BLOCKS__
typedef void (^ViewSingleSelectMenuBlock)(ViewSingleSelectMenu *sender,
                                          NSInteger selectedIndex);
#endif

@interface ViewSingleSelectMenu : UIView

+(void) showWithBlock:(ViewSingleSelectMenuBlock )block
                title:title
    cancelButtonTitle:(NSString *)cancel
  otherButtonTitlesArr:(NSArray *)argsArray;

+(void)showWithBlock:(ViewSingleSelectMenuBlock )block
               title:title
   cancelButtonTitle:(NSString *)cancel
   otherButtonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;
@property(nonatomic,copy) ViewSingleSelectMenuBlock block;
@end
