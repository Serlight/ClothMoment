//
//  ContactTableViewCell.m
//  SB
//
//  Created by serlight on 12/6/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "Photo.h"
#import "ChatViewController.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)sendMessage:(id)sender {
    [self.delegate pushToChatViewController:_contactInfo];
}

- (IBAction)callPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _contactInfo[@"logid"]]]];
}

- (IBAction)enterShop:(id)sender {
    [self.delegate pushToShopViewController:_contactInfo];
}

- (IBAction)deleteContact:(id)sender {
    [self.delegate deleContact:_indexPath];
}

- (void)setContactInfo:(NSDictionary *)contactInfo {
    _contactInfo = contactInfo;
    NSString *profileUrl = contactInfo[@"profile_url"];
    _nameLabel.text = [NSString stringWithFormat:@"%@(%@)", contactInfo[@"name"], contactInfo[@"logid"]];
    _shopLabel.text = contactInfo[@"companyName"];
    [Photo retrievePhoto:profileUrl
                callback:^(UIImage *image) {
                    if (image) {
                        _avatarImageView.image = image;
                    }
                }];
}



@end
