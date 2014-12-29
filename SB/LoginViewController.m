//
//  LoginViewController.m
//  SB
//
//  Created by serlight on 10/23/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "User.h"
#import <EaseMob.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController () {
    CLLocation *currentLocation;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"账号 :";
    _usernameTextField.leftView = nameLabel;
    
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    passwordLabel.textColor = [UIColor blackColor];
    passwordLabel.font = [UIFont systemFontOfSize:14];
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    passwordLabel.text = @"密码 :";
    _passwordTextField.leftView = passwordLabel;
    
    [_usernameTextField becomeFirstResponder];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back_black"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonTouch:)];
    self.navigationItem.leftBarButtonItem = backButton;
    currentLocation = [AppDelegate sharedDelegate].currentLocation;
}

- (void)backButtonTouch:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"");
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"this ");
}

- (void)getCurrentLocation {
    
}

- (IBAction)touchUpInsideLoginButton:(id)sender {
    NSNumber *longi = [NSNumber numberWithDouble:[currentLocation coordinate].longitude];
    NSNumber *lati = [NSNumber numberWithDouble:[currentLocation coordinate].latitude];
    NSDictionary *userInfo = @{@"logid": self.usernameTextField.text,
                               @"pwd": self.passwordTextField.text,
                               @"longitude": longi,
                               @"latitude": lati};
    [self showHudInView:self.view hint:@"登录..."];
    [User login:userInfo
          block:^(ResponseType responseType, NSDictionary *dict) {
              if (responseType == RequestSucceed) {
                  [[EaseMob sharedInstance].chatManager  asyncLoginWithUsername:self.usernameTextField.text
                                                                       password:self.passwordTextField.text
                                                                     completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                         [self hideHud];
                                                                         if (error) {
                                                                             [Utils showCustomHud:@"网络错误"];
                                                                         } else {
                                                                             NSLog(@"login success");
                                                                             [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"password"];
                                                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                                                         }
                                                                     } onQueue:nil];
                  if (_callback) {
                      _callback();
                  }
                  [self dismissViewControllerAnimated:YES completion:nil];
                  [self.view removeFromSuperview];
              } else {
                  [self hideHud];
                  [Utils showCustomHud:@"密码或用户名错误"];
              }
          }];
}

- (IBAction)signupTouchUpInside:(id)sender {
    SignUpViewController *signUpViewController = (SignUpViewController *)[[AppDelegate sharedDelegate].storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self presentViewController:signUpViewController
                       animated:YES completion:^{
                           [self.view removeFromSuperview];
                       }];
}

- (IBAction)resetPasswordTouchUpInside:(id)sender {
    
}
@end
