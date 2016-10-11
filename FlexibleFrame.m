//
//  FlexibleFrame.m
//  Vpin
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 Vpin. All rights reserved.
//

#import "FlexibleFrame.h"
#import "PrefixHeader.pch"
@implementation FlexibleFrame

+ (CGFloat)ratioY
{
//    if ([UIScreen mainScreen].bounds.size.height == 480) {
//        return [UIScreen mainScreen].bounds.size.height/IPHONE6FRAME.height;
//    }
    return [UIScreen mainScreen].bounds.size.height/IPHONE4FRAME.height;//判断比例（适配最重要的一步）
    //当然也可以直接全部返回［UIScreen mainScreen].bounds.size.height/IPHONE5FRAME.height，就不用进行判断了
    
    
}

+ (CGFloat)ratioX
{
    
    return [UIScreen mainScreen].bounds.size.width/IPHONE4FRAME.width;//判断比例（适配最重要的一步）
}

+ (CGFloat)flexibleFloatX:(CGFloat)num
{
    return num*[self ratioX];
}


+ (CGFloat)flexibleFloatY:(CGFloat)num
{
    return num*[self ratioY];
}



+ (CGRect)frameFromIPhone5Frame:(CGRect)frame
{
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    if ([UIScreen mainScreen].bounds.size.height == 480) {//判断是否是4s尺寸
        y = [FlexibleFrame flexibleFloatY:frame.origin.y];
        height = [FlexibleFrame flexibleFloatY:frame.size.height];
        x = frame.origin.x;
        width = frame.size.width;
        // NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
    }else{//如果不是4s
        x = [self flexibleFloatX:frame.origin.x];
        y = [self flexibleFloatY:frame.origin.y];
        
        width = [self flexibleFloatX:frame.size.width];
        height = [self flexibleFloatY:frame.size.height];
    }
    return CGRectMake(x, y, width, height);
}
+ (void)flexibleFontSizeWithSuperView:(UIView *)superView
{
    for (UIView *subView in superView.subviews) {
        if (subView.subviews.count > 0) {
            [FlexibleFrame flexibleFontSizeWithSuperView:subView];
        }
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            label.font = [UIFont fontWithName:label.font.fontName size:[FlexibleFrame flexibleFloatX:label.font.pointSize]];
        }
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subView;
            textField.font = [UIFont fontWithName:textField.font.fontName size:[FlexibleFrame flexibleFloatX:textField.font.pointSize]];
        }
    }
}



@end
