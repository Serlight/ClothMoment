//
//  NewMomentTableViewCell.m
//  SB
//
//  Created by serlight on 12/25/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "NewMomentTableViewCell.h"

@implementation NewMomentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPostInfos:(NSArray *)postInfos {
    _postInfos = postInfos;
    if (_postInfos.count == 1) {
        _post2.hidden = YES;
        _post3.hidden = YES;
    }
    
    for (NSDictionary *postInfo in postInfos) {
    }
}

@end
