//
//  ShopViewController.m
//  SB
//
//  Created by serlight on 11/6/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "ShopNViewController.h"
#import "ShopTableViewCell.h"
#import "PostViewController.h"
#import "Shop.h"
#import "Photo.h"
#import "PostDetialViewController.h"
#import "User.h"
#import "ChatViewController.h"


@interface ShopNViewController () {
    NSArray *supplyArray;
    NSArray *buyArray;
    NSDictionary *userInfo;
    BOOL isCurrentUser;
}

@property (strong, nonatomic) UITableView *supplyTableView;
@property (strong, nonatomic) UITableView *buyTableView;

@end

@implementation ShopNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userId = @"15888888888";
    supplyArray = [NSArray array];
    buyArray = [NSArray array];
    [self configTableView];
    if ([[User getUserInfo][@"logid"] isEqualToString:_userId]) {
        _operationView.hidden = YES;
        isCurrentUser = YES;
    } else {
        _bottomButton.hidden = YES;
        isCurrentUser = NO;
    }
    [self retrivalData];
}

- (void)configTableView {
    _supplyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 195)];
    _supplyTableView.backgroundColor = [UIColor grayColor];
    _supplyTableView.dataSource = self;
    _supplyTableView.delegate = self;
    
    _buyTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 195)];
    _buyTableView.backgroundColor = [UIColor blackColor];
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth * 2, 100);
    
    [_bottomScrollView addSubview:_supplyTableView];
    [_bottomScrollView addSubview:_buyTableView];
    _bottomScrollView.backgroundColor = [UIColor redColor];
    UINib *nib = [UINib nibWithNibName:@"ShopTableViewCell" bundle:nil];
    [_supplyTableView registerNib:nib forCellReuseIdentifier:@"shopCell"];
    [_buyTableView registerNib:nib forCellReuseIdentifier:@"shopCell"];
    UIView *emptyView = [UIView buildEmptyTableView:@"没有相关信息" withFrame:_supplyTableView.frame];
    _supplyTableView.nxEV_emptyView = emptyView;
    _buyTableView.nxEV_emptyView = emptyView;
    _supplyTableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
    _buyTableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:YES];
    [self showHudInView:self.view hint:@"加载数据"];
        [Shop getShopInfo:_userId
                    block:^(ResponseType responseType, id responseObj) {
                        [self hideHud];
                        _nameLabel.text = responseObj[@"name"];
                        _companyLabel.text = responseObj[@"companyName"];
                        supplyArray = responseObj[@"supplyList"];
                        buyArray = responseObj[@"purchaseList"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_supplyTableView reloadData];
                        });
                        
//                        [_buyTableView reloadData];
//                        [Photo retrievePhoto:responseObj[@"profile_url"]
//                                    callback:^(UIImage *image) {
//                                        if (image) {
//                                            _avatarImageView.image = image;
//                                        }
//                                    }];
                    }];
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
    if (scrollView != _bottomScrollView) {
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
    if (point.x < 0 || point.x > ScreenWidth || scrollView != _bottomScrollView) {
        return;
    }
    
    _underLine.centerX = ScreenWidth / 4 + point.x / 2;
}

- (IBAction)buyTouch:(id)sender {
    [_supplyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
    _underLine.centerX = ScreenWidth/ 4 * 3;
    _bottomScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
}

- (IBAction)supplyTouch:(id)sender {
    _underLine.centerX = ScreenWidth/ 4 ;
    [_supplyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
    [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _bottomScrollView.contentOffset = CGPointMake(0, 0);
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
