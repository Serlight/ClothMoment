//
//  UIView+SB.m
//  SB
//
//  Created by serlight on 11/30/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "UIView+SB.h"

@implementation UIView (SB)

+ (UIView *)buildEmptyTableView:(NSString *)comment withFrame:(CGRect)frame {
    UIView *emptyView = [[UIView alloc] initWithFrame:frame];
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.center = emptyView.center;
    commentLabel.text = comment;
    commentLabel.font = [UIFont boldSystemFontOfSize:16];
    commentLabel.textColor = [UIColor grayColor];
    [emptyView addSubview:commentLabel];
    return emptyView;
}

@end
