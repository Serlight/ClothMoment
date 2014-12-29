//
//  MomentCollectionViewCell.h
//  SB
//
//  Created by serlight on 12/25/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSDictionary *postInfo;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *clothType;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UIButton *scanCount;


@end
