//
//  PostViewController.h
//  SB
//
//  Created by serlight on 11/18/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MHTextField.h>
#import "Cloth.h"


@interface PostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet MHTextField *titleField;
@property (weak, nonatomic) IBOutlet MHTextField *priceField;
@property (weak, nonatomic) IBOutlet UIButton *goodsButton;
@property (weak, nonatomic) IBOutlet UIButton *scheduleButton;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollection;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet MHTextField *clothTypeField;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;
@property (weak, nonatomic) IBOutlet MHTextField *connectName;
@property (weak, nonatomic) IBOutlet MHTextField *connectPhone;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (nonatomic) PostType type;

@end
