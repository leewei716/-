//
//  ViewPopButtons.h
//  QuHuWai
//
//  Created by wzkj on 15/3/11.
//  Copyright (c) 2015年 Wzkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KeyNormalImage @"KeyNormalImage"
#define KeyHighlightedImage @"KeyHighlightedImage"
#define KeyButtonTitle @"KeyButtonTitle"

typedef NS_ENUM(NSUInteger, ExpansionDirection) {
    DirectionUp=0,
    DirectionDown
};
#ifdef __BLOCKS__
typedef BOOL (^ViewPopButtonsBlock)(int idx);
#endif

@interface newViewPopButtons : UIView
+(void)showButtons:(NSArray *) buttons
          atButton:(UIButton *) atButton
         Direction:(ExpansionDirection)direction
             Block:(ViewPopButtonsBlock) block;

@property(nonatomic,copy)ViewPopButtonsBlock block;
-(void)showButtons:(NSArray *) buttons
          atButton:(UIButton *) atButton
         Direction:(ExpansionDirection)direction;
-(void) disMissAtButtonIdx:(int) idx;
@end
