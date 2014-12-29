//
//  UserProfileViewController.h
//  SB
//
//  Created by serlight on 11/17/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
@class MHTextField;

@interface UserProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet  UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet MHTextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet MHTextField *nameTextField;
@property (weak, nonatomic) IBOutlet MHTextField *idCardTextField;
@property (weak, nonatomic) IBOutlet MHTextField *companyNumTextField;
@property (weak, nonatomic) IBOutlet MHTextField *companyAddressTextField;
@property (weak, nonatomic) IBOutlet RadioButton *buyRadioButton;
@property (weak, nonatomic) IBOutlet RadioButton *sellRadioButton;

@end
