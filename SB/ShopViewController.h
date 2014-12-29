//
//  ShopViewController.h
//  SB
//
//  Created by serlight on 11/6/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonButton;
@property (weak, nonatomic) IBOutlet UITableView *supplyTableView;
@property (weak, nonatomic) IBOutlet UITableView *buyTableView;
@property (weak, nonatomic) IBOutlet UIButton *supplyButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIView *underLine;
@property (weak, nonatomic) IBOutlet UIScrollView *buttonScrollView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *operationView;


@property (copy, nonatomic) NSString *userId;

@end
