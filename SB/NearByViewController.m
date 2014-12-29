//
//  MomentsViewController.m
//  SB
//
//  Created by serlight on 11/2/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "NearByViewController.h"
#import "MomentTableViewCell.h"
#import "Moments.h"
#import "PostDetialViewController.h"
#import <SVPullToRefresh.h>
#import "MomentCollectionViewCell.h"
#import "PostViewController.h"


@interface NearByViewController () <UIActionSheetDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *buyInfos;
    NSMutableArray *sellInfos;
    NSDictionary *parameters;
    NSInteger supplyPageNo;
    NSInteger buyPageNo;
    BOOL _isFirst;
    CLLocation *currentLocation;
}

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation NearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentLocation = [AppDelegate sharedDelegate].currentLocation;
    _isFirst = YES;
    [self configCollectionView];
    
}

- (void)configCollectionView {
    UINib *nib = [UINib nibWithNibName:@"MomentCollectionViewCell" bundle:nil];
    [_supplyCollectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];
    [_buyCollectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];
    [self initialRefreshCollectionView];
}

- (void)viewWillLayoutSubviews {
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth * 2, 1.0);
}

- (void)initialRefreshCollectionView {
    [_supplyCollectionView addPullToRefreshWithActionHandler:^{
        [self insertRowAtTop:_supplyCollectionView];
    }];
    [_buyCollectionView addPullToRefreshWithActionHandler:^{
        [self insertRowAtTop:_buyCollectionView];
    }];
    
}


- (void)insertRowAtTop:(UICollectionView *)collectionView {
    __weak NearByViewController *weakSelf = self;
    int64_t delayInseconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInseconds * NSEC_PER_MSEC);
    [self showHudInView:self.view hint:@"加载数据"];
    [weakSelf getQueryParameters];
    [Moments getNearByInof:parameters
                     block:^(ResponseType responseType, id responseObj) {
                         _isFirst = NO;
                         [self hideHud];
                         dispatch_after(popTime, dispatch_get_main_queue(), ^{
                              sellInfos = [responseObj[@"supplyList"] mutableCopy];
                              buyInfos = [responseObj[@"purchaseList"] mutableCopy];
                              [collectionView.pullToRefreshView stopAnimating];
                              [_supplyCollectionView  reloadData];
                              [_buyCollectionView reloadData];
                          });
                      }];
}

- (void)initValue {
    supplyPageNo = 0;
    buyPageNo = 0;
    buyInfos = [NSMutableArray mutableCopy];
    sellInfos = [NSMutableArray mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    if (_isFirst) {
        [_supplyCollectionView triggerPullToRefresh];
    }
    
}

- (void )getQueryParameters {
    NSNumber *longi = [NSNumber numberWithDouble:[currentLocation coordinate].longitude];
    NSNumber *lati = [NSNumber numberWithDouble:[currentLocation coordinate].latitude];
    parameters = @{@"longitude":[longi stringValue],
                    @"latitude":[lati stringValue],
                    @"distance": @"4000"};
}

- (UICollectionView *)getCurrentCollectionView {
    if (_bottomScrollView.contentOffset.x < ScreenWidth / 2) {
        [_buyCollectionView reloadData];
        return _supplyCollectionView;
    } else {
        [_buyCollectionView reloadData];
        return _buyCollectionView;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != _bottomScrollView) {
        return;
    }
    NSInteger x = scrollView.contentOffset.x / ScreenWidth;
    if (x ==0) {
        _underLine.centerX = ScreenWidth / 4;
        [_supplyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        _underLine.centerX = ScreenWidth / 4 * 3;
        [_buyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
        [_supplyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    if (point.x < 0 || point.x > ScreenWidth) {
        return;
    }
    if (scrollView != _bottomScrollView) {
        return;
    }
    
    _underLine.centerX = ScreenWidth / 4 + point.x/2;
}

- (IBAction)touchType:(id)sender {
    if ((UIButton *)sender == _supplyButton) {
        [UIView animateWithDuration:0.2f animations:^{
            _underLine.centerX = ScreenWidth / 4;
        }];
        [_supplyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _bottomScrollView.contentOffset = CGPointMake(0, 0);
    } else if ((UIButton *)sender == _buyButton) {
        [UIView animateWithDuration:0.2f animations:^{
            _underLine.centerX = ScreenWidth / 4 * 3;
        }];
        [_buyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
        [_supplyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _bottomScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    }
    [self.view setNeedsDisplay];
}


- (IBAction)postTouch:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"发布求购"
                                              otherButtonTitles:@"发布供应", nil];
    [sheet dismissWithClickedButtonIndex:2 animated:YES];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) {
        return;
    }
    PostViewController *vc = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
    if (buttonIndex == 0) {
        vc.type = Buy;
    } else {
        vc.type = Sell;
    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc
                                         animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _supplyCollectionView) {
        return sellInfos.count;
    } else {
        return buyInfos.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MomentCollectionViewCell *cell = (MomentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (collectionView == _supplyCollectionView) {
        cell.postInfo = sellInfos[indexPath.row];
        
    } else {
        cell.postInfo = buyInfos[indexPath.row];
    }
    [cell setNeedsDisplay];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (iPhone4 || iPhone5) {
        return CGSizeMake(100, 150);
    } else if (iPhone6) {
        return CGSizeMake(118, 168);
    } else {
        return CGSizeMake(131, 181);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PostDetialViewController *detail = [[PostDetialViewController alloc] initWithNibName:@"PostDetialViewController" bundle:nil];
    NSDictionary *postInfo ;
    if (collectionView == _supplyCollectionView) {
        postInfo = sellInfos[indexPath.item];
        detail.postType = @"sell";
    } else {
        postInfo = buyInfos[indexPath.item];
        detail.postType = @"buy";
    }
    detail.postId = postInfo[@"id"];
    
    [self.navigationController pushViewController:detail animated:YES];
    
}


@end

