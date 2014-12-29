//
//  FavoriateViewController.h
//  SB
//
//  Created by serlight on 12/27/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *supplyButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIView *underLine;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (weak, nonatomic) IBOutlet UITableView *supplyTableView;
@property (weak, nonatomic) IBOutlet UITableView *buyTableView;


@end
