//
//  NewMomentTableViewCell.h
//  SB
//
//  Created by serlight on 12/25/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMomentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *preview1;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UIButton *scanCount1;
@property (weak, nonatomic) IBOutlet UILabel *clothType1;
@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *statu1;
@property (weak, nonatomic) IBOutlet UILabel *postDate1;

@property (weak, nonatomic) IBOutlet UIImageView *preview2;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UIButton *scanCount2;
@property (weak, nonatomic) IBOutlet UILabel *clothType2;
@property (weak, nonatomic) IBOutlet UILabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *statu2;
@property (weak, nonatomic) IBOutlet UILabel *postDate2;

@property (weak, nonatomic) IBOutlet UIImageView *preview3;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UIButton *scanCount3;
@property (weak, nonatomic) IBOutlet UILabel *clothType3;
@property (weak, nonatomic) IBOutlet UILabel *price3;
@property (weak, nonatomic) IBOutlet UILabel *statu3;
@property (weak, nonatomic) IBOutlet UILabel *postDate3;

@property (weak, nonatomic) IBOutlet UIView *post1;
@property (weak, nonatomic) IBOutlet UIView *post2;
@property (weak, nonatomic) IBOutlet UIView *post3;

@property (strong, nonatomic) NSArray *postInfos;



@end
