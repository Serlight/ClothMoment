//
//  MomentTableViewCell.h
//  SB
//
//  Created by serlight on 11/16/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *momentPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *MomentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;
@property (weak, nonatomic) IBOutlet UILabel *momentStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanTimeButton;
@property (weak, nonatomic) IBOutlet UILabel *postDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthConstraint;

@property (strong, nonatomic) NSDictionary *momentInfo;

@end
