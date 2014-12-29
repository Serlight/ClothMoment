//
//  UIColor+SB.m
//  SB
//
//  Created by serlight on 11/30/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "UIColor+SB.h"

@implementation UIColor (SB)

+ (UIColor *)colorWithRGB:(int)HEX
{
    return [UIColor colorWithRGB:HEX Alpha:1.0];
}

+ (UIColor *)colorWithRGB:(int)HEX Alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((HEX & 0xFF0000) >> 16) / 255.0 green:((HEX & 0xFF00) >> 8) / 255.0 blue:(HEX & 0xFF) / 255.0 alpha:alpha];
}

+ (UIColor *)textColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRGB:0x222222];
    });
    return color;
}

@end
