//
//  LoginViewController.h
//  SB
//
//  Created by serlight on 10/23/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *getPassword;
@property (strong, nonatomic) void(^callback)(void);

- (IBAction)touchUpInsideLoginButton:(id)sender;
- (IBAction)signupTouchUpInside:(id)sender;
- (IBAction)resetPasswordTouchUpInside:(id)sender;
@end
