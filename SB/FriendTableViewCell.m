//
//  FriendTableViewCell.m
//  SB
//
//  Created by serlight on 12/26/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "Photo.h"
#import "User.h"

@implementation FriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserInfo:(NSDictionary *)userInfo {
    _userInfo = userInfo;
    [Photo retrievePhoto:userInfo[@"profile_url"]
                callback:^(UIImage *image) {
                    if (image) {
                        _avatarImageView.image = image;
                    }
                }];
    _nameLabel.text = [NSString stringWithFormat:@"%@%@", userInfo[@"name"], userInfo[@"logid"]];
    _shopName.text = userInfo[@"companyName"];
    
}

- (IBAction)addFriend:(id)sender {
    [User addOneFriend:_userInfo[@"logid"]
                 block:^(ResponseType responseType, id responseObj) {
                     if (responseType == RequestSucceed) {
                         [self.delegate removeCell:_index];
                     }
                 }];
    
}


@end
