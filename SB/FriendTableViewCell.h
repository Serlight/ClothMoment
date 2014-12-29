//
//  FriendTableViewCell.h
//  SB
//
//  Created by serlight on 12/26/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendCellDelegate <NSObject>

- (void)removeCell:(NSInteger)cell;

@end

@interface FriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) id <FriendCellDelegate> delegate;
@property (strong, nonatomic) NSDictionary *userInfo;
@property NSInteger index;


@end
