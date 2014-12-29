//
//  SBTabBarViewController.m
//  SB
//
//  Created by serlight on 10/30/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "SBTabBarViewController.h"
#import "LoginViewController.h"
#import "User.h"

@interface SBTabBarViewController () <UITabBarDelegate, UITabBarControllerDelegate>

@end

@implementation SBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if (![User isLogined]) {
//        LoginViewController *loginViewController = (LoginViewController *)[[AppDelegate sharedDelegate].storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        [self addChildViewController:loginViewController];
//        [self.view addSubview:loginViewController.view];
////        [self.selectedViewController presentViewController:loginViewController animated:NO completion:nil];
//    }
    
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [User checkLogin:^{
        nil;
    } loginedCallback:^{
        nil;
    }];
}


@end
