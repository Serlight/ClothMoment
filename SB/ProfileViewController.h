//
//  ProfileViewController.h
//  SB
//
//  Created by serlight on 11/2/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;

- (IBAction)shopTouchUpIndside:(id)sender;
- (IBAction)foucsTouchUpInside:(id)sender;
- (IBAction)creditTouchUpInside:(id)sender;
- (IBAction)responseTouch:(id)sender;
- (IBAction)suggestionTouch:(id)sender;


@end
