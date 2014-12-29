//
//  ProfileTableViewCell.m
//  SB
//
//  Created by serlight on 11/6/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    [_infoTextField setLeftViewMode:UITextFieldViewModeAlways];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setFiled:(NSString *)filed {
    filed = [NSString stringWithFormat:@"%@:", filed];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:filed attributes:@{NSFontAttributeName:self.keyTextField.font}];
    CGSize size = CGSizeMake(1000, 44);
    CGSize labelSize = [attrStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    UIView *indentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, labelSize.width + 23)];
    indentView.backgroundColor= [UIColor clearColor];
    _keyTextField.text = filed;
    [_infoTextField setLeftView:indentView];
}

- (void)setIsNeed:(BOOL)isNeed {
    _markImageView.hidden = !isNeed;
}

- (void)setPlacehold:(NSString *)placehold {
    _infoTextField.placeholder = placehold;
}

@end
