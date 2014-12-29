//
//  CustomPullToRefresh.h
//  PullToRefreshDemo
//
//  Created by John Wu on 3/22/12.
//  Copyright (c) 2012 TFM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSPullToRefreshController.h>
#import "UIView+Coordinate.h"

@protocol CustomPullToRefreshDelegate;

@interface CustomPullToRefresh : NSObject <MSPullToRefreshDelegate> {
    MSPullToRefreshController *_ptrc;
    UIScrollView *_scrollView;
    id <CustomPullToRefreshDelegate> _delegate;
    UIImageView *_arrowTop;
    UIActivityIndicatorView *_indicatorTop;
    UIActivityIndicatorView *_indicatorBottom;
    UIImageView *_arrowBottom;
    UILabel *_labelTop;
    UILabel *_labelBottom;
}
@property (strong, nonatomic) UIView *refreshTop;
@property (strong, nonatomic) UIView *refreshBottom;
- (id) initWithScrollView:(UIScrollView *)scrollView delegate:(id <CustomPullToRefreshDelegate>)delegate;
- (void) endRefresh;
- (void) startRefresh;

@end

@protocol CustomPullToRefreshDelegate <NSObject>

- (void) customPullToRefreshShouldRefresh:(CustomPullToRefresh *)ptr didEngageRefreshDirection:(MSRefreshDirection)direction;

@end