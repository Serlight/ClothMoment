//
//  SettingsTableViewController.m
//  SB
//
//  Created by serlight on 11/5/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "UserProfileViewController.h"
#import "User.h"
#import <EaseMob.h>

@interface SettingsTableViewController () {
    NSArray *titles;
}

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    titles = @[@"修改密码", @"修改个人资料"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = titles[indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"ChangePassword" sender:tableView];
    } else {
        UserProfileViewController *profileViewController = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
}

- (IBAction)logOutTouchUpInside:(id)sender {
    [self showHudInView:self.view hint:@"退出登录"];
    [User logOut:^(ResponseType responseType, id responseObj) {
        [self hideHud];
        if (responseType == RequestSucceed) {
            [[EaseMob sharedInstance].chatManager asyncLogoff];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self showHint:@"成功退出"];
            [self.tabBarController setSelectedIndex:0];
        }
    }];
}


@end
