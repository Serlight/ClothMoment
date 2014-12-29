//
//  ProfileTableViewCell.h
//  SB
//
//  Created by serlight on 11/6/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UILabel *keyTextField;
@property (copy, nonatomic) NSString *filed;
@property (copy, nonatomic) NSString *placehold;
@property BOOL isNeed;
@end
