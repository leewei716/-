//
//  UIPlaceHolderTextView.h
//  一起留学
//
//  Created by will on 16/6/15.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;
-(void)textChanged:(NSNotification*)notification;


@end
