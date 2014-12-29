//
//  ResetPasswordTableViewController.m
//  SB
//
//  Created by serlight on 11/6/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "UpdateProfileTableViewController.h"
#import "ProfileTableViewCell.h"

@interface UpdateProfileTableViewController () {
    NSDictionary *userInfo;
    NSArray *keys;
}

@end

@implementation UpdateProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    keys = @[@"账号", @"注册身份", @"公司名称", @"姓名", @"身份证号", @"营业执照号", @"营业执照地址"];
    UINib *nib = [UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ProfileCell"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    if (section == 0) {
        label.text = @"基本信息";
    } else {
        label.text = @"其他信息";
    }
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    if (indexPath.section == 0) {
        cell.isNeed = YES;
    } else {
        cell.isNeed = NO;
    }
    cell.filed = keys[indexPath.section * 4 + indexPath.row];
    if (indexPath.section == 1) {
        cell.placehold = @"信用额度+5";
    }
    return cell;
}

@end
