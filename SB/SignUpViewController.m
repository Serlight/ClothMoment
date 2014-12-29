//
//  SignUpViewController.m
//  SB
//
//  Created by serlight on 10/23/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "SignUpViewController.h"
#import "User.h"
#import <MBProgressHUD.h>
#import <EaseMob.h>
#import "LoginViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SignUpViewController () {
    MBProgressHUD *commitHud;
    CLLocation *currentLocation;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_phoneTextField setRequired:YES];
    [_passwordTextField setRequired:YES];
    [_confirmPasswordTextField setRequired:YES];
    [_companyNameTextField setRequired:YES];
    [_registerTextField setRequired:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)signUpTouchUpInside:(id)sender {
    NSNumber *longi = [NSNumber numberWithDouble:[currentLocation coordinate].longitude];
    NSNumber *lati = [NSNumber numberWithDouble:[currentLocation coordinate].latitude];
    NSDictionary *userInfo = @{
                               @"logid":self.phoneTextField.text,
                               @"pwd": self.passwordTextField.text,
                               @"authStatus": @"0",
                               @"companyName":self.companyNameTextField.text,
                               @"name":self.registerTextField.text,
                               @"idCard": self.iDCardTextField.text,
                               @"licenseId":self.registerIDTextField.text,
                               @"licenseAddr":self.registerAddressTextField.text,
                               @"inviter":self.invitePhoneNumberTextField.text,
                               @"longitude": longi,
                               @"latitude": lati};
    [User signUp:userInfo
           block:^(ResponseType responseType, NSDictionary *dict) {
               if (responseType == RequestSucceed) {
                   [[EaseMob sharedInstance].chatManager  asyncLoginWithUsername:self.phoneTextField.text
                                                                        password:self.passwordTextField.text
                                                                      completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                          if (error) {
                                                                              NSLog(@"login failed");
                                                                          } else {
                                                                              NSLog(@"login success");
                                                                          }
                                                                      } onQueue:nil];
                   [self dismissViewControllerAnimated:YES completion:nil];
               }
           }];
}


- (IBAction)signInTouch:(id)sender {
     LoginViewController *loginViewController = (LoginViewController *)[[AppDelegate sharedDelegate].storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:loginViewController
                       animated:YES completion:^{
                           [self.view removeFromSuperview];
                       }];
}

@end
