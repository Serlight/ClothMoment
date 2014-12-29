//
//  ContactTableViewCell.h
//  SB
//
//  Created by serlight on 12/6/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactCellDelegate <NSObject>

- (void)pushToChatViewController:(NSDictionary *)contactInfo;
- (void)pushToShopViewController:(NSDictionary *)contactInfo;
- (void)deleContact:(NSIndexPath *)index;

@end

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopLabel;
@property (weak, nonatomic)id<ContactCellDelegate> delegate;

@property(strong, nonatomic) NSDictionary *contactInfo;
@property (strong, nonatomic) NSIndexPath *indexPath;


@end
