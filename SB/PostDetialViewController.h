//
//  MomentDetialViewController.h
//  SB
//
//  Created by serlight on 11/16/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostDetialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *postHeaderScrollView;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *scanCount;
@property (weak, nonatomic) IBOutlet UILabel *postStatues;
@property (weak, nonatomic) IBOutlet UILabel *postTypeName;
@property (weak, nonatomic) IBOutlet UILabel *postPrice;
@property (weak, nonatomic) IBOutlet UILabel *postContact;
@property (weak, nonatomic) IBOutlet UILabel *postPhone;
@property (weak, nonatomic) IBOutlet UITextView *postDetail;
@property (strong, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *buyView;

@property (weak, nonatomic) IBOutlet UIView *supplyView;

@property (copy, nonatomic) NSString *postId;
@property (copy, nonatomic) NSString *postType;

@end
