//
//  FlexibleFrame.h
//  Vpin
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 Vpin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FlexibleFrame : NSObject

+ (CGFloat)ratioX;
+ (CGFloat)ratioY;

+ (CGFloat)flexibleFloatX:(CGFloat)num;
+ (CGFloat)flexibleFloatY:(CGFloat)num;

+ (CGRect)frameFromIPhone5Frame:(CGRect)frame;


@end
