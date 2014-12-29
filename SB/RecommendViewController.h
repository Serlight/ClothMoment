//
//  RecommendViewController.h
//  SB
//
//  Created by serlight on 11/9/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendViewController : UIViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *clothSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *supplyButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UICollectionView *supplyCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *buyCollectionView;

@end
