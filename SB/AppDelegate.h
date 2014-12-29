//
//  AppDelegate.h
//  SB
//
//  Created by serlight on 10/23/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTabBarViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) UIStoryboard *secondStoryboard;
@property (strong, nonatomic) SBTabBarViewController *tabbarController;
@property (strong, nonatomic) CLLocation *currentLocation;

+ (instancetype)sharedDelegate;

@end

