//
//  ShopViewController.m
//  SB
//
//  Created by serlight on 11/6/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopTableViewCell.h"
#import "PostViewController.h"
#import "Shop.h"
#import "Photo.h"
#import "PostDetialViewController.h"
#import "User.h"
#import "ChatViewController.h"

@interface ShopViewController () {
    NSArray *supplyArray;
    NSArray *buyArray;
    NSDictionary *userInfo;
    BOOL isCurrentUser;
}

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    supplyArray = [NSArray array];
    buyArray = [NSArray array];
    UINib *nib = [UINib nibWithNibName:@"ShopTableViewCell" bundle:nil];
    [_supplyTableView registerNib:nib forCellReuseIdentifier:@"shopCell"];
    [_buyTableView registerNib:nib forCellReuseIdentifier:@"shopCell"];
    UIView *emptyView = [UIView buildEmptyTableView:@"没有相关信息" withFrame:_supplyTableView.frame];
    _supplyTableView.nxEV_emptyView = emptyView;
    _buyTableView.nxEV_emptyView = emptyView;
    _supplyTableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
    _buyTableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
    if ([[User getUserInfo][@"logid"] isEqualToString:_userId]) {
        _operationView.hidden = YES;
        isCurrentUser = YES;
    } else {
        _buttonButton.hidden = YES;
        isCurrentUser = NO;
    }
    [self retrivalData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:YES];
    [self showHudInView:self.view hint:@"加载数据"];
//    [Shop getShopInfo:_userId
//                block:^(ResponseType responseType, id responseObj) {
//                    [self hideHud];
//                    _nameLabel.text = responseObj[@"name"];
//                    _companyLabel.text = responseObj[@"companyName"];
//                    supplyArray = responseObj[@"supplyList"];
//                    buyArray = responseObj[@"purchaseList"];
//                    [_supplyTableView reloadData];
//                    [_buyTableView reloadData];
//                    [Photo retrievePhoto:responseObj[@"profile_url"]
//                                callback:^(UIImage *image) {
//                                    if (image) {
//                                        _avatarImageView.image = image;
//                                    }
//                                }];
//                }];
}

- (void)viewWillLayoutSubviews {
//    _buyTableView.origin = CGPointMake(ScreenWidth, 0);
//    _supplyTableView.origin = CGPointMake(0, 0);
//     _buttonScrollView.contentSize = CGSizeMake(ScreenWidth * 2, _maskView.height);
//    _supplyTableView.size = _maskView.size;
//    _buyTableView.size = _maskView.size;
}

- (void)retrivalData {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _supplyTableView) {
        return supplyArray.count;
    }
    return buyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopTableViewCell *cell = (ShopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"shopCell" forIndexPath:indexPath];
    if (tableView == _supplyTableView) {
        cell.clothInfo = supplyArray[indexPath.row];
        return cell;
    } else {
        cell.clothInfo = buyArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [NSDictionary dictionary];
    PostDetialViewController *detailViewController = [[PostDetialViewController alloc] initWithNibName:@"PostDetialViewController" bundle:nil];
    if (tableView == _supplyTableView) {
        item = supplyArray[indexPath.row];
        detailViewController.postType = @"sell";
    } else {
        item = buyArray[indexPath.row];
        detailViewController.postType = @"buy";
    }
    detailViewController.postId = item[@"id"];
    [self.navigationController hidesBottomBarWhenPushed];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)bottomButton:(id)sender {
    PostViewController *postViewController = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
    UIButton *btn = (UIButton *)sender;
    if (btn == _supplyButton) {
        postViewController.type = Sell;
    } else {
        postViewController.type = Buy;
    }
    [self.navigationController pushViewController:postViewController animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != _buttonScrollView) {
        return;
    }
    NSInteger x = scrollView.contentOffset.x / ScreenWidth;
    if (x == 0) {
        _underLine.centerX = ScreenWidth / 4;
        [_supplyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    } else {
        _underLine.centerX = ScreenWidth / 4 * 3;
        [_supplyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    if (point.x < 0 || point.x > ScreenWidth || scrollView != _buttonScrollView) {
        return;
    }
    
    _underLine.centerX = ScreenWidth / 4 + point.x / 2;
}

- (IBAction)buyTouch:(id)sender {
    [_supplyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
    _underLine.centerX = ScreenWidth/ 4 * 3;
    _buttonScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
}

- (IBAction)supplyTouch:(id)sender {
    _underLine.centerX = ScreenWidth/ 4 ;
    [_supplyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
    [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _buttonScrollView.contentOffset = CGPointMake(0, 0);
//    [_underLine updateConstraints];
}

- (IBAction)callTouch:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _userId]]];
}

- (IBAction)addFriendTouch:(id)sender {
    [User addOneFriend:_userId
                 block:^(ResponseType responseType, id responseObj) {
                     [Utils showCustomHud:@"添加好友成功"];
                 }];
}

- (IBAction)sendMessageTouch:(id)sender {
    ChatViewController *chatView = [[ChatViewController alloc] initWithChatter:_userId isGroup:NO];
    [User getUserInfo:@[_userId]
                block:^(ResponseType responseType, id responseObj) {
                    NSDictionary *info = responseObj[1];
                    chatView.title = info[@"name"];
                    self.hidesBottomBarWhenPushed = YES;
                    UINavigationController *nav = (UINavigationController *)self.tabBarController.selectedViewController;
                    self.tabBarController.selectedViewController.hidesBottomBarWhenPushed = YES;
                    [nav pushViewController:chatView animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }];
}


@end
