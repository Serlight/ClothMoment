//
//  ShopTableViewCell.h
//  SB
//
//  Created by serlight on 11/9/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *clothPic;
@property (weak, nonatomic) IBOutlet UILabel *clothName;
@property (weak, nonatomic) IBOutlet UILabel *clothType;
@property (weak, nonatomic) IBOutlet UILabel *clothStatus;
@property (weak, nonatomic) IBOutlet UIButton *scanTime;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *creditNumber;

@property (strong, nonatomic) NSDictionary *clothInfo;
@property (strong, nonatomic) NSNumber *credit;

@end
