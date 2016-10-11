//
//  UIPlaceHolderTextView.m
//  一起留学
//
//  Created by will on 16/6/15.
//  Copyright © 2016年 leewei. All rights reserved.
//


#import "UIPlaceHolderTextView.h"
#import "UIPlaceHolderTextView.h"
@implementation UIPlaceHolderTextView
{
    UILabel *_placeHolderLabel;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    [self placeHolderLabel].textColor=placeholderColor;
    
}
-(void)setPlaceholder:(NSString *)placeholder{
    [self placeHolderLabel].text=placeholder;
}
-(UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,6,self.bounds.size.width - 16,21)];
        _placeHolderLabel.lineBreakMode =UILineBreakModeWordWrap;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor=[UIColor lightGrayColor];
        [self addSubview:_placeHolderLabel];
    }
    return _placeHolderLabel;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
}
- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if ([self.text isEqualToString:@""]) {
        _placeHolderLabel.hidden=false;
    }else{
        _placeHolderLabel.hidden=true;
        
    }
}
- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}


@end

