//
//  NearByViewController.h
//  SB
//
//  Created by serlight on 12/27/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *supplyButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIView *underLine;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *supplyCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *buyCollectionView;


@end
