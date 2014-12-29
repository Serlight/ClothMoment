//
//  AddFriendViewController.m
//  SB
//
//  Created by serlight on 12/26/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "AddFriendViewController.h"
#import "User.h"
#import "FriendTableViewCell.h"

@interface AddFriendViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, FriendCellDelegate> {
    NSMutableArray *userList;
}

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userList = [NSMutableArray array];
    [_searchBar becomeFirstResponder];
    UINib *nib = [UINib nibWithNibName:@"FriendTableViewCell" bundle:nil];
    [_friendList registerNib:nib forCellReuseIdentifier:@"cell"];
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    _friendList.nxEV_emptyView = view;
    _friendList.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (![NSString bNoEmpty:searchBar.text]) {
        return;
    }
    [self showHudInView:self.view hint:@"搜索好友"];
    [User searchUser:searchBar.text
               block:^(ResponseType responseType, id responseObj) {
                   [self hideHud];
                   userList = responseObj[@"allData"];
                   [_friendList reloadData];
               }];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return userList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.userInfo = userList[indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;
    [cell setNeedsDisplay];
    return cell;
}

- (void)removeCell:(NSInteger)index {
    [userList removeObjectAtIndex:index];
    [_friendList reloadData];
}

@end
