//
//  UILabel+SB.m
//  SB
//
//  Created by serlight on 11/30/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "UILabel+SB.h"

@implementation UILabel (SB)

+ (CGSize)calculateLabelSize:(NSString *)text font:(UIFont *)font limit:(CGSize)limit {
    if (![NSString bNoEmpty:text]) {
        return CGSizeZero;
    }
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:limit options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size;
}

+ (UILabel*)buildLabel:(id)text
             textColor:(UIColor *)color
                  font:(UIFont *)font
            startPoint:(CGPoint)point
            parentView:(UIView*)parentView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    CGSize size = CGSizeMake(ScreenWidth, LargeHeight);
    CGSize labelSize;
    if ([[text class] isSubclassOfClass:[NSString class]]) {
        label.textColor = color;
        label.font = font;
        label.text = text;
        labelSize = [UILabel calculateLabelSize:text font:font limit:size];
    } else {
        label.attributedText = text;
        labelSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }
    label.frame = CGRectMake(point.x, point.y, labelSize.width, labelSize.height);
    [parentView addSubview:label];
    return label;
}

+ (UILabel *)buildNetWorkStatusLabel:(NSString *)text
{
    UILabel *reachabilityStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64.0f, ScreenWidth, 32.0f)];
    reachabilityStatusLabel.backgroundColor = [UIColor colorWithRGB:0xfffee0];
    reachabilityStatusLabel.layer.borderColor = [UIColor colorWithRGB:0xffa801].CGColor;
    reachabilityStatusLabel.layer.borderWidth = 1.0f;
    reachabilityStatusLabel.alpha = 0.8f;
    reachabilityStatusLabel.text = text;
    [reachabilityStatusLabel setTextAlignment:NSTextAlignmentCenter];
    [[AppDelegate sharedDelegate].window addSubview:reachabilityStatusLabel];
    return reachabilityStatusLabel;
}

@end
