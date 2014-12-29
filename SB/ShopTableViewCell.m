//
//  ShopTableViewCell.m
//  SB
//
//  Created by serlight on 11/9/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "Photo.h"

@implementation ShopTableViewCell

- (void)awakeFromNib {
    _creditNumber.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setClothInfo:(NSDictionary *)clothInfo {
    if (clothInfo[@"imageUrl"]) {
        [Photo retrievePhoto:clothInfo[@"imageUrl"] callback:^(UIImage *image) {
            if (image) {
                _clothPic.image = image;
            }
        }];
    }
    _clothName.text = clothInfo[@"title"];
    _clothType.text = clothInfo[@"typeName"];
    _clothStatus.text = [NSString stringWithFormat:@"状态: %@", clothInfo[@"states"]];
    _postDate.text = clothInfo[@"createDate"];
    [_scanTime setTitle:[clothInfo[@"views"] stringValue] forState:UIControlStateNormal];
}

- (void)setCredit:(NSNumber *)credit {
    _creditNumber.text = [NSString stringWithFormat:@"信用度: %@", credit];
    _creditNumber.hidden = NO;
}

@end
