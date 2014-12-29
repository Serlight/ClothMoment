//
//  AppDelegate.m
//  SB
//
//  Created by serlight on 10/23/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "AppDelegate.h"
#import <EaseMob.h>
#import <Reachability.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate () <IChatManagerDelegate, CLLocationManagerDelegate>{
    Reachability *reach;
    UILabel *_netWorkExceptionLabel;
}
@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [Fabric with:@[CrashlyticsKit]];
    _storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _secondStoryboard = [UIStoryboard storyboardWithName:@"New" bundle:nil];
    UIColor *navColor = UIColorFromRGB(100, 200, 200);
    [[UINavigationBar appearance] setBackgroundColor:navColor];
    [[UINavigationBar appearance] setBarTintColor:navColor];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(245, 245, 245), NSForegroundColorAttributeName, [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    
    _tabbarController = (SBTabBarViewController *)self.window.rootViewController;
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"chatdemoui_dev";
#else
    apnsCertName = @"chatdemoui";
#endif
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"xienb#xienbwebim"
                                       apnsCertName:apnsCertName];
    [[EaseMob sharedInstance] application:application
            didFinishLaunchingWithOptions:launchOptions];
    
    reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStateChange:)
                                                 name:@"kReachabilityChangedNotification"
                                               object:reach];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    
#if DEBUG
    [[EaseMob sharedInstance] enableUncaughtExceptionHandler];
#endif
    [[[EaseMob sharedInstance] chatManager] setAutoFetchBuddyList:YES];
    [[EaseMob sharedInstance] application:application
            didFinishLaunchingWithOptions:launchOptions];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self
                                        delegateQueue:nil];
    [self loginStateChange:nil];
    [self setupLocationManager];
    return YES;
}

- (void)setupLocationManager {
    self.manager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        self.manager.delegate = self;
        self.manager.distanceFilter = 300;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.manager startUpdatingLocation];
    } else {
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _currentLocation = locations[0];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

+ (instancetype)sharedDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

- (void)networkStateChange:(NSNotification *) notification {
    [self showNetWorkExceptionLabel:bNotifyNetWorkException];
}

- (void)showNetWorkExceptionLabel:(BOOL)bShow
{
    if(!_netWorkExceptionLabel){
        _netWorkExceptionLabel = [UILabel buildNetWorkStatusLabel:NetWorkExceptionPrompt];
    }
    _netWorkExceptionLabel.hidden = !bShow;
}

- (void)loginStateChange:(NSNotification *)notification {
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (!isAutoLogin) {
        NSUserDefaults *standDefault = [NSUserDefaults standardUserDefaults];
        NSString *userName;
        if ([standDefault objectForKey:@"userInfo"]) {
            userName = [standDefault objectForKey:@"userInfo"][@"logid"];
        }
        NSString *password = [standDefault objectForKey:@"password"];
        if (userName && password) {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName
                                                                password:password
                                                              completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                  nil;
                                                              } onQueue:nil];
        }
    }
    
}

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error {
    
}

- (void)didLoginFromOtherDevice {
    
}

@end
