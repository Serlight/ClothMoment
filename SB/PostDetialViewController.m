//
//  MomentDetialViewController.m
//  SB
//
//  Created by serlight on 11/16/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "PostDetialViewController.h"
#import "Photo.h"
#import "Moments.h"
#import "ShopNViewController.h"
#import "ChatViewController.h"
#import "SignUpViewController.h"

@interface PostDetialViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) NSDictionary *postInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation PostDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, 600);
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.scrollView addSubview:self.postView];
    self.postHeaderScrollView.delegate = self;
    if ([_postType isEqualToString:@"buy"]) {
        self.navigationItem.title = @"求购详情";
    } else {
        self.navigationItem.title = @"供应详情";
    }
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
//    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewWillAppear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = YES;
    self.postDetail.editable = NO;
    [self showHudInView:self.view hint:@"加载数据"];
    if ([_postType isEqualToString:@"sell"]) {
        _buyView.hidden = YES;
        [Moments getMomentInfo:_postId
                         block:^(ResponseType responseType, id responseObj) {
                             [self hideHud];
                             if (responseType == RequestSucceed) {
                                 [self setPostInfo:responseObj];
                             }
                         }];
    } else {
        _supplyView.hidden = YES;
        [Moments getBuyMomentInfo:_postId
                            block:^(ResponseType responseType, id responseObj) {
                                [self hideHud];
                                if (responseType == RequestSucceed) {
                                    [self setPostInfo:responseObj];
                                }
                            }];
    }
}

- (void)setPostInfo:(NSDictionary *)postInfo {
    _postInfo = postInfo;
    self.postTitleLabel.text = postInfo[@"title"];
    self.postDate.text = [NSString stringWithFormat:@"发布时间: %@", postInfo[@"createDate"]];
    self.scanCount.text = [postInfo[@"views"] stringValue];
    self.postStatues.text = [NSString stringWithFormat:@"状态: %@", postInfo[@"states"]];
    self.postTypeName.text = [NSString stringWithFormat:@"分类: %@", postInfo[@"typeName"]];
    self.postPrice.text = [NSString stringWithFormat:@"价格: %@", postInfo[@"price"]];
    [self setHeaderScrollView:postInfo[@"urls"]];
    self.postDetail.text = postInfo[@"description"];
    self.postContact.text = [NSString stringWithFormat:@"联系人: %@", postInfo[@"contact"]];
    self.postPhone.text = [NSString stringWithFormat:@"电话: %@", postInfo[@"phone"]];
    [self updateViewConstraints];
}

- (void)setHeaderScrollView:(NSArray *)picInfos {
    self.postHeaderScrollView.contentSize = CGSizeMake(ScreenWidth * picInfos.count, 240);
    int index = 0;
    self.pageControl.numberOfPages = picInfos.count;
    if (picInfos.count == 1) {
        self.pageControl.hidden = YES;
    }
    self.pageControl.currentPage = 0;
    for (NSString *urlStr in picInfos) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * ScreenWidth, 0, ScreenWidth, 240)];
        [Photo retrievePhoto:urlStr
                    callback:^(UIImage *image) {
                        if (image) {
                            imageView.image = image;
                            [self.postHeaderScrollView addSubview:imageView];
                        }
                    }];
        index ++;
    }
    
    if (picInfos.count == 0) {
        self.postHeaderScrollView.contentSize = CGSizeMake(ScreenWidth, 240);
        self.pageControl.numberOfPages = 1;
        self.pageControl.hidden = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * ScreenWidth, 0, ScreenWidth, 240)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"no_image"];
        [self.postHeaderScrollView addSubview:imageView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

- (IBAction)enterShopTouch:(id)sender {
    ShopNViewController *shop = [[AppDelegate sharedDelegate].storyboard instantiateViewControllerWithIdentifier:@"ShopNViewController"];
    shop.userId = _postInfo[@"publisher"];
    [self presentViewController:shop animated:YES completion:^{
        nil;
    }];
    
}

- (IBAction)favorite:(id)sender {
    NSDictionary *favoriteInfo = @{@"infoId": _postId, @"infoType" : [_postType isEqualToString:@"buy"] ? @(1) : @(2)};
    [Moments favoriteRecorde:favoriteInfo
                       block:^(ResponseType responseType, id responseObj) {
                           [Utils showCustomHud:responseObj ? responseObj : @"收藏成功"];
                       }];
}

- (IBAction)sendMessage:(id)sender {
    ChatViewController *chatView = [[ChatViewController alloc] initWithChatter:_postInfo[@"phone"] isGroup:NO];
    chatView.title = _postInfo[@"contact"];
    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

- (IBAction)sendMessageTouch:(id)sender {
}

- (IBAction)callPhoneTouche:(id)sender {
}

@end
