//
//  ResetPasswordViewController.m
//  SB
//
//  Created by serlight on 11/6/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "User.h"
#import <MBProgressHUD.h>
#import "LoginViewController.h"

@interface ResetPasswordViewController () {
    MBProgressHUD *commitHud;
}

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_oldPassword setRequired:YES];
    [_password setRequired:YES];
    [_confirmPassword setRequired:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)commitChange:(id)sender {
    NSDictionary *passwordInfo = @{@"oldpwd":_oldPassword.text, @"newpwd":_password.text};
    [self showWaitHud];
    [User resetPassword:passwordInfo
                  block:^(ResponseType responseType, id responseObj) {
                      [self removeWaitHud];
                      if (responseType == RequestSucceed) {
                          [User logOut:nil];
                          LoginViewController *loginViewController = (LoginViewController *)[[AppDelegate sharedDelegate].storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                          [self addChildViewController:loginViewController];
                          [self.view addSubview:loginViewController.view];
                      }
                  }];
}

-(void)showWaitHud
{
    commitHud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:commitHud];
    commitHud.labelText = @"请稍候";
    [commitHud show:YES];
}

-(void)removeWaitHud
{
    if(commitHud){
        [commitHud removeFromSuperview];
        commitHud = nil;
    }
}


@end
