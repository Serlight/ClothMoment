//
//  MomentsViewController.m
//  SB
//
//  Created by serlight on 11/2/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "MomentsViewController.h"
#import "MomentTableViewCell.h"
#import "Moments.h"
#import "PostDetialViewController.h"
#import <SVPullToRefresh.h>
#import "MomentCollectionViewCell.h"
#import "PostViewController.h"


@interface MomentsViewController () <UIActionSheetDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *buyInfos;
    NSMutableArray *sellInfos;
    NSMutableDictionary *parameters;
    NSInteger supplyPageNo;
    NSInteger buyPageNo;
    BOOL bSearchSupply;
    BOOL bSearchBuy;
    NSMutableArray *searchSupply;
    NSMutableArray *searchBuy;
    BOOL _isFirst;
}

@end

@implementation MomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirst = YES;
    [self getQueryParameters];
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
//    _supplyCollectionView.size = _baseView.size;
//    _buyCollectionView.size = _baseView.size;
}

- (void)initialRefreshCollectionView {
        [_supplyCollectionView addPullToRefreshWithActionHandler:^{
            [self insertRowAtTop:_supplyCollectionView];
        }];
        [_supplyCollectionView addInfiniteScrollingWithActionHandler:^{
            [self insertRowAtBottom:_supplyCollectionView];
        }];
    
        [_buyCollectionView addPullToRefreshWithActionHandler:^{
            [self insertRowAtTop:_buyCollectionView];
        }];
    
        [_buyCollectionView addInfiniteScrollingWithActionHandler:^{
            [self insertRowAtBottom:_buyCollectionView];
        }];
    
}


- (void)insertRowAtTop:(UICollectionView *)collectionView {
        __weak MomentsViewController *weakSelf = self;
        int64_t delayInseconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInseconds * NSEC_PER_MSEC);
        [weakSelf getQueryParameters];
        if (collectionView == _supplyCollectionView) {
            supplyPageNo = 0;
            parameters[@"page_no"] = @(supplyPageNo);
            parameters[@"query_type"] = @2;
        } else {
            buyPageNo = 0;
            parameters[@"page_no"] = @(buyPageNo);
            parameters[@"query_type"] = @1;
        }
        [Moments getMoments:parameters
                      block:^(ResponseType responseType, id responseObj) {
                          dispatch_after(popTime, dispatch_get_main_queue(), ^{
                              [collectionView.pullToRefreshView stopAnimating];
                              NSArray *data = responseObj[@"allData"];
                              if (collectionView == _supplyCollectionView) {
                                  sellInfos = [data mutableCopy];
                                  [_supplyCollectionView reloadData];
                              } else {
                                  buyInfos = [data mutableCopy];
                                  [_buyCollectionView reloadData];
                              }
                          });
                      }];
}

- (void)insertRowAtBottom: (UICollectionView *)collectionView {
        __weak MomentsViewController *weakSelf = self;
        int64_t delayInseconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInseconds * NSEC_PER_MSEC);
        [weakSelf getQueryParameters];
        if (collectionView == _supplyCollectionView) {
            supplyPageNo += 1;
            parameters[@"page_no"] = @(supplyPageNo);
            parameters[@"query_type"] = @2;
        } else {
            buyPageNo += 1;
            parameters[@"page_no"] = @(buyPageNo);
            parameters[@"query_type"] = @1;
        }
        [Moments getMoments:parameters
                      block:^(ResponseType responseType, id responseObj) {
                          NSMutableArray *indexpaths = [NSMutableArray array];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [collectionView.pullToRefreshView stopAnimating];
                          });
                          if (responseType == RequestSucceed) {
                              NSArray *data = responseObj[@"allData"];
                              dispatch_after(popTime, dispatch_get_main_queue(), ^{
                                  [collectionView performBatchUpdates:^{
                                      NSInteger oldSize = 0;
                                      if (collectionView == _supplyCollectionView) {
                                          oldSize = sellInfos.count;
                                          [sellInfos addObjectsFromArray:data];
                                      } else {
                                          oldSize = buyInfos.count;
                                          [buyInfos addObjectsFromArray:data];
                                      }
                                      for(int index = 0; index < data.count; index ++) {
                                          [indexpaths addObject:[NSIndexPath indexPathForItem:index + oldSize inSection:0]];
                                      }
                                      [collectionView insertItemsAtIndexPaths:indexpaths];
                                  } completion:^(BOOL finished) {
                                      nil;
                                  }];
                              });
                          }
                      }];
}

- (void)initValue {
    supplyPageNo = 0;
    buyPageNo = 0;
    buyInfos = [NSMutableArray mutableCopy];
    sellInfos = [NSMutableArray mutableCopy];
    searchSupply = [NSMutableArray array];
    searchBuy = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _supplyCollectionView.contentSize = _baseView.size;
    _buyCollectionView.contentSize = _baseView.size;
    [self.tabBarController.tabBar setHidden:NO];
    //    [_supplyTableView triggerPullToRefresh];
    //    [_buyTableView triggerPullToRefresh];
    if (_isFirst) {
        [self getMomentData];
    }
    
}

- (void) getMomentData {
    [self showHudInView:self.view hint:@"加载数据"];
    [Moments getMoments:parameters
                  block:^(ResponseType responseType, id responseObj) {
                      if (responseType == RequestSucceed) {
                          [self hideHud];
                          _isFirst = NO;
                          if (responseObj[@"allData"]) {
                              sellInfos = [responseObj[@"allData"] mutableCopy];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self.supplyCollectionView reloadData];
                              });
                          }
                      }
                  }];
    parameters[@"query_type"] = @1;
    [Moments getMoments:parameters
                  block:^(ResponseType responseType, id responseObj) {
                      if (responseType == RequestSucceed) {
                          if (responseObj[@"allData"]) {
                              buyInfos = [responseObj[@"allData"] mutableCopy];
                              [self.buyCollectionView reloadData];
                          }
                      }
                  }];
    [self getQueryParameters];
}

- (void )getQueryParameters {
    parameters = [@{@"page_size":@10, @"page_no": @(0), @"query_type": @2} mutableCopy];
}

- (UICollectionView *)getCurrentCollectionView {
    if (_bottomScrollView.contentOffset.x < ScreenWidth / 2) {
        bSearchBuy = NO;
        bSearchSupply = YES;
        [_buyCollectionView reloadData];
        return _supplyCollectionView;
    } else {
        bSearchSupply = NO;
        bSearchBuy = YES;
        [_buyCollectionView reloadData];
        return _buyCollectionView;
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![NSString bNoEmpty:searchBar.text]) {
        bSearchBuy = NO;
        bSearchSupply = NO;
        [_supplyCollectionView reloadData];
        [_buyCollectionView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self getCurrentCollectionView];
    [self searchMoment];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void) searchMoment{
    [self showHudInView:self.view hint:@"加载数据"];
    [self getQueryParameters];
    parameters[@"query_str"] = _searchBar.text;
    UICollectionView *collectionView = [self getCurrentCollectionView];
    if (collectionView == _buyCollectionView) {
        parameters[@"query_type"] = @1;
    }
    
    [Moments getMoments:parameters
                  block:^(ResponseType responseType, id responseObj) {
                      if (responseType == RequestSucceed) {
                          [self hideHud];
                          _isFirst = NO;
                          if (responseObj[@"allData"]) {
                              if (collectionView == _supplyCollectionView) {
                                  searchSupply = [responseObj[@"allData"] mutableCopy];
                              } else {
                                  searchBuy = [responseObj[@"allData"] mutableCopy];
                              }
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [collectionView reloadData];
                              });
                          }
                      }
                  }];
    [self getQueryParameters];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != _bottomScrollView) {
        return;
    }
    NSInteger x = scrollView.contentOffset.x / ScreenWidth;
    if (x ==0) {
        _underLineView.centerX = ScreenWidth / 4;
        [_supplyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        _underLineView.centerX = ScreenWidth / 4 * 3;
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
    
    _underLineView.centerX = ScreenWidth / 4 + point.x/2;
}

- (IBAction)touchType:(id)sender {
    if ((UIButton *)sender == _supplyButton) {
        [UIView animateWithDuration:0.2f animations:^{
            _underLineView.centerX = ScreenWidth / 4;
        }];
        [_supplyButton setTitleColor:UIColorFromRGB(100, 200, 200) forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _bottomScrollView.contentOffset = CGPointMake(0, 0);
    } else if ((UIButton *)sender == _buyButton) {
        [UIView animateWithDuration:0.2f animations:^{
            _underLineView.centerX = ScreenWidth / 4 * 3;
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
        if (bSearchSupply) {
            return searchSupply.count;
        }
        return sellInfos.count;
    } else {
        if (bSearchBuy) {
            return searchBuy.count;
        }
        return buyInfos.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MomentCollectionViewCell *cell = (MomentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (collectionView == _supplyCollectionView) {
        if (bSearchSupply) {
            cell.postInfo = searchSupply[indexPath.item];
        } else {
            cell.postInfo = sellInfos[indexPath.row];
        }

    } else {
        if (bSearchBuy) {
            cell.postInfo = searchBuy[indexPath.item];
        } else {
            cell.postInfo = buyInfos[indexPath.row];
        }
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
        if (bSearchSupply) {
            postInfo = searchSupply[indexPath.item];
        } else {
            postInfo = sellInfos[indexPath.item];
        }
        detail.postType = @"sell";
    } else {
        if (bSearchBuy) {
            postInfo = searchBuy[indexPath.item];
        } else {
            postInfo = buyInfos[indexPath.item];
        }
        detail.postType = @"buy";
    }
    detail.postId = postInfo[@"mid"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}


@end
