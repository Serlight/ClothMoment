//
//  UILabel+SB.h
//  SB
//
//  Created by serlight on 11/30/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SB)

+ (UILabel*)buildLabel:(id)text
             textColor:(UIColor *)color
                  font:(UIFont *)font
            startPoint:(CGPoint)point
            parentView:(UIView*)parentView;

+ (UILabel *)buildNetWorkStatusLabel:(NSString *)text;
@end
