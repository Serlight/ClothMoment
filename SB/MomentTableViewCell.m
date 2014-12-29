//
//  MomentTableViewCell.m
//  SB
//
//  Created by serlight on 11/16/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "MomentTableViewCell.h"
#import "Photo.h"

@implementation MomentTableViewCell

- (void)awakeFromNib {
    
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    _viewWidthConstraint.constant = ScreenWidth -  48;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMomentInfo:(NSDictionary *)momentInfo {
    _postDateLabel.text = momentInfo[@"createDate"];
    [Photo retrievePhoto:momentInfo[@"profile_url"]
                callback:^(UIImage *image) {
                    if (image) {
                        _avatarImageView.image = image;
                    }
                }];
    [Photo retrievePhoto:momentInfo[@"imageUrl"]
                callback:^(UIImage *image) {
                    if (image) {
                        _momentPicImageView.image = image;
                    }
                }];
    _momentStatusLabel.text = momentInfo[@"states"];
    _MomentTitleLabel.text = momentInfo[@"title"];
    _materialLabel.text = momentInfo[@"typeName"];
    _nameLabel.text = momentInfo[@"name"];
    [_scanTimeButton setTitle:[momentInfo[@"views"] stringValue] forState:UIControlStateNormal];
    [self setNeedsDisplay];
}



@end
