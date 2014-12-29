//
//  CustomPullToRefresh.m
//  PullToRefreshDemo
//
//  Created by John Wu on 3/22/12.
//  Copyright (c) 2012 TFM. All rights reserved.
//

#import "CustomPullToRefresh.h"

@implementation CustomPullToRefresh
@synthesize refreshTop,refreshBottom;
- (id) initWithScrollView:(UIScrollView *)scrollView delegate:(id<CustomPullToRefreshDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _scrollView = scrollView;
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
        _ptrc = [[MSPullToRefreshController alloc] initWithScrollView:_scrollView delegate:self];
        
        refreshTop = [[UIView alloc] initWithFrame:CGRectMake(0, -RefreshViewHeight, ScreenWidth, RefreshViewHeight)];
        _indicatorTop = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorTop.hidesWhenStopped = YES;
        _indicatorTop.frame = CGRectMake((refreshTop.frame.size.width-ArrowWidth)/2, refreshTop.height-RefreshOperationViewHeight+(RefreshOperationViewHeight-ArrowWidth)/2, ArrowWidth, ArrowWidth);
        [refreshTop addSubview:_indicatorTop];
        [scrollView addSubview:refreshTop];

        refreshBottom = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollView.frame.size.height, ScreenWidth, RefreshViewHeight)];
        _indicatorBottom = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorBottom.hidesWhenStopped = YES;
        _indicatorBottom.frame = CGRectMake((refreshBottom.frame.size.width-ArrowWidth)/2, (RefreshOperationViewHeight-ArrowWidth)/2, ArrowWidth, ArrowWidth);
        [refreshBottom addSubview:_indicatorBottom];
        [scrollView addSubview:refreshBottom];


        _arrowTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refreshIcon"]];
        _arrowTop.frame = CGRectMake((refreshTop.frame.size.width-_arrowTop.frame.size.width)/2, refreshTop.height-RefreshOperationViewHeight+(RefreshOperationViewHeight-ArrowHeight)/2, _arrowTop.frame.size.width, _arrowTop.frame.size.height);
        _labelTop = [UILabel buildLabel:@"下拉刷新" textColor:[UIColor textColor] font:FONT(14) startPoint:CGPointMake(160, refreshTop.height-RefreshOperationViewHeight+(RefreshOperationViewHeight-ArrowHeight)/2) parentView:refreshTop];
        CGFloat length = _labelTop.width+2*ArrowWidth;
        _arrowTop.left = (ScreenWidth-length)/2;
        _labelTop.left = _arrowTop.left + 2*ArrowWidth;
        [refreshTop addSubview:_arrowTop];

        _arrowBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refreshIcon"]];
        _arrowBottom.frame = CGRectMake((refreshBottom.frame.size.width-_arrowBottom.frame.size.width)/2, (RefreshOperationViewHeight-ArrowHeight)/2 , _arrowBottom.frame.size.width, _arrowBottom.frame.size.height);
        _arrowBottom.transform  = CGAffineTransformMakeRotation(M_PI);
        _labelBottom = [UILabel buildLabel:@"上拉载入更多" textColor:[UIColor textColor] font:FONT(14) startPoint:CGPointMake(160, (RefreshOperationViewHeight-ArrowHeight)/2) parentView:refreshBottom];
        length = _labelBottom.width+2*ArrowWidth;
        _arrowBottom.left = (ScreenWidth-length)/2;
        _labelBottom.left = _arrowBottom.left + 2*ArrowWidth;
        [refreshBottom addSubview:_arrowBottom];
        
        refreshTop.backgroundColor = [UIColor whiteColor];
        refreshBottom.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat contentSizeArea = _scrollView.contentSize.width*_scrollView.contentSize.height;
    CGFloat frameArea = _scrollView.frame.size.width*_scrollView.frame.size.height;
    CGSize adjustedContentSize = contentSizeArea < frameArea ? _scrollView.frame.size : _scrollView.contentSize;
    refreshBottom.frame = CGRectMake(0, adjustedContentSize.height, _scrollView.frame.size.width, _scrollView.frame.size.height);
}

- (void) dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void) endRefresh {
    [_ptrc finishRefreshingDirection:MSRefreshDirectionTop animated:YES];
    [_ptrc finishRefreshingDirection:MSRefreshDirectionBottom animated:YES];
    [_indicatorTop stopAnimating];
    [_indicatorBottom stopAnimating];
    _arrowBottom.hidden = NO;
    _arrowBottom.transform  = CGAffineTransformMakeRotation(M_PI);
    _labelTop.text = @"下拉刷新";
    _labelTop.hidden = NO;
    _arrowTop.hidden = NO;
    _arrowTop.transform = CGAffineTransformIdentity;
    _labelBottom.text = @"上拉载入更多";
    _labelBottom.hidden = NO;
}

- (void) startRefresh {
    [_ptrc startRefreshingDirection:MSRefreshDirectionTop];
}

#pragma mark - MSPullToRefreshDelegate Methods

- (BOOL) pullToRefreshController:(MSPullToRefreshController *)controller canRefreshInDirection:(MSRefreshDirection)direction {
    return (direction == MSRefreshDirectionTop || direction == MSRefreshDirectionBottom);
}

- (CGFloat) pullToRefreshController:(MSPullToRefreshController *)controller refreshingInsetForDirection:(MSRefreshDirection)direction {
    return RefreshOperationViewHeight;
}

- (CGFloat) pullToRefreshController:(MSPullToRefreshController *)controller refreshableInsetForDirection:(MSRefreshDirection)direction {
    return RefreshOperationViewHeight;
}

- (void) pullToRefreshController:(MSPullToRefreshController *)controller canEngageRefreshDirection:(MSRefreshDirection)direction {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    _arrowTop.transform = CGAffineTransformMakeRotation(M_PI);
    _labelTop.text = @"松开刷新";
    _arrowBottom.transform = CGAffineTransformIdentity;
    _labelBottom.text = @"松开载入更多";
    [UIView commitAnimations];
}

- (void) pullToRefreshController:(MSPullToRefreshController *)controller didDisengageRefreshDirection:(MSRefreshDirection)direction {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    _arrowTop.transform = CGAffineTransformIdentity;
    _labelTop.text = @"下拉刷新";
    _arrowBottom.transform  = CGAffineTransformMakeRotation(M_PI);
    _labelBottom.text = @"上拉载入更多";
    [UIView commitAnimations];
}

- (void) pullToRefreshController:(MSPullToRefreshController *)controller didEngageRefreshDirection:(MSRefreshDirection)direction {
    _arrowTop.hidden = YES;
    _labelTop.hidden = YES;
    _arrowBottom.hidden = YES;
    _labelBottom.hidden = YES;
    [_indicatorTop startAnimating];
    [_indicatorBottom startAnimating];
    [_delegate customPullToRefreshShouldRefresh:self didEngageRefreshDirection:direction];
}

@end
