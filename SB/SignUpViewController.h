//
//  SignUpViewController.h
//  SB
//
//  Created by serlight on 10/23/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
#import <MHTextField.h>


@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet MHTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet MHTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet MHTextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet MHTextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet RadioButton *sellerRadioButton;
@property (weak, nonatomic) IBOutlet RadioButton *buyerRadioButton;
@property (weak, nonatomic) IBOutlet MHTextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet MHTextField *registerTextField;
@property (weak, nonatomic) IBOutlet MHTextField *registerIDTextField;
@property (weak, nonatomic) IBOutlet MHTextField *registerAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet MHTextField *iDCardTextField;
@property (weak, nonatomic) IBOutlet MHTextField *invitePhoneNumberTextField;

//- (IBAction)textFieldBeginEdit:(id)sender;
//- (IBAction)textFieldEndEdit:(id)sender;
- (IBAction)signUpTouchUpInside:(id)sender;

@end
