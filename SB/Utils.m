//
//  Utils.m
//  SB
//
//  Created by serlight on 12/26/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "Utils.h"
#import <MBProgressHUD.h>
#import <CoreLocation/CoreLocation.h>

@interface Utils () <CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *localManager;

@end

@implementation Utils

static NSDictionary *localtionInfo;

+ (instancetype)sharedInstance {
    static Utils *utils;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!utils) {
            utils = [[Utils alloc] init];
        }
    });
    return utils;
}

- (id)init {
    self = [super init];
    return self;
}



+ (void)showCustomHud:(NSString *)text
{
    [self showCustomHudWithText:text hideAfter:1];
}

+ (void)showCustomHudWithText:(NSString *)text hideAfter:(NSUInteger)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedDelegate].window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = FONT(15);
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}

- (NSDictionary *)getCurrentLocation {
    _localManager = [[CLLocationManager alloc] init];
   
    if ([CLLocationManager locationServicesEnabled]) {
        _localManager.delegate = self;
        _localManager.desiredAccuracy = kCLLocationAccuracyBest;
        _localManager.distanceFilter = 200;
        [_localManager startUpdatingLocation];
    } else {
    }
    return localtionInfo;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D loc = [newLocation coordinate];
    localtionInfo = @{@"longitude": @(loc.longitude), @"latitude": @(loc.latitude)};
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocationCoordinate2D loc = [locations[0] coordinate];
    localtionInfo = @{@"longitude": @(loc.longitude), @"latitude": @(loc.latitude)};
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *errorMsg = nil;
    if ([error code] == kCLErrorDenied) {
        errorMsg = @"访问被拒绝";
    } else if ([error code] == kCLErrorLocationUnknown) {
        errorMsg = @"获取位置信息失败";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Location"
                                                      message:errorMsg delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil, nil];
    [alertView show];
}

@end
