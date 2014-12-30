//
//  FavoriateViewController.m
//  SB
//
//  Created by serlight on 12/27/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "FavoriateViewController.h"
#import "ShopTableViewCell.h"
#import "PostDetialViewController.h"
#import "Moments.h"

@interface FavoriateViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSArray *supplyInfo;
    NSArray *buyInfo;
    BOOL bFirst;
}

@end

@implementation FavoriateViewController

- (void)viewDidLoad {
    supplyInfo = [NSArray array];
    buyInfo = [NSArray array];
    UINib *nib = [UINib nibWithNibName:@"ShopTableViewCell" bundle:nil];
    [_supplyTableView registerNib:nib forCellReuseIdentifier:@"shopCell"];
    [_buyTableView registerNib:nib forCellReuseIdentifier:@"shopCell"];
    UIView *emptyView = [UIView buildEmptyTableView:@"没有相关信息" withFrame:_supplyTableView.frame];
    [_buyTableView removeFromSuperview];
    _supplyTableView.nxEV_emptyView = emptyView;
    _supplyTableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
    
    _buyTableView.nxEV_emptyView = emptyView;
    _buyTableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
    [super viewDidLoad];
    bFirst = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    if (bFirst) {
        [self showHudInView:_bottomScrollView hint:@"获取数据"];
        [Moments getFavoriateList:^(ResponseType responseType, id responseObj) {
            [self hideHud];
            if (responseType == RequestSucceed) {
                bFirst = NO;
                supplyInfo = responseObj[@"supplyList"];
                buyInfo = responseObj[@"purchaseList"];
                [_supplyTableView reloadData];
                [_buyTableView reloadData];
            }
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != _bottomScrollView) {
        return;
    }
    NSInteger x = scrollView.contentOffset.x / ScreenWidth;
    if (x == 0) {
        _underLine.centerX = ScreenWidth / 4;
        [_supplyButton setTitleColor:UIColorFromRGB(0, 200, 200) forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    } else {
        _underLine.centerX = ScreenWidth / 4 * 3;
        [_supplyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buyButton setTitleColor:UIColorFromRGB(0, 200, 200) forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    if (point.x < 0 || point.x > ScreenWidth || scrollView != _bottomScrollView) {
        return;
    }
    _underLine.centerX = ScreenWidth / 4 + point.x / 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _supplyTableView) {
        return supplyInfo.count;
    } else {
        return buyInfo.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopTableViewCell *cell = (ShopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"shopCell" forIndexPath:indexPath];
    if (tableView == _supplyTableView) {
        cell.clothInfo = supplyInfo[indexPath.row];
        return cell;
    } else {
        cell.clothInfo = buyInfo[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [NSDictionary dictionary];
    PostDetialViewController *detailViewController = [[PostDetialViewController alloc] initWithNibName:@"PostDetialViewController" bundle:nil];
    if (tableView == _supplyTableView) {
        item = supplyInfo[indexPath.row];
        detailViewController.postType = @"sell";
    } else {
        item = buyInfo[indexPath.row];
        detailViewController.postType = @"buy";
    }
    detailViewController.postId = item[@"id"];
    [self.navigationController hidesBottomBarWhenPushed];
    [self.navigationController pushViewController:detailViewController animated:YES];
}



- (IBAction)typeTouch:(UIButton *)sender {
    if (sender == _supplyButton) {
        [_supplyButton setTitleColor:UIColorFromRGB(0, 200, 200) forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _underLine.centerX = ScreenWidth / 4;
        _bottomScrollView.contentOffset = CGPointMake(0, 0);
    } else {
        [_bottomScrollView addSubview:_buyTableView];
        [_buyTableView reloadData];
        [_buyButton setTitleColor:UIColorFromRGB(0, 200, 200) forState:UIControlStateNormal];
        [_supplyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _underLine.centerX = ScreenWidth / 4 * 3;
        _bottomScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    }
}


@end
