//
//  ClothTypeViewController.h
//  SB
//
//  Created by serlight on 12/2/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClothTypeDelegate <NSObject>
- (void)getClothType:(NSDictionary *)typeInfo;

@end

@interface ClothTypeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *typeTableView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) id<ClothTypeDelegate> delegate;

@end
