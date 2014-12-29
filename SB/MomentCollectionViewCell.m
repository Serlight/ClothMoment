//
//  MomentCollectionViewCell.m
//  SB
//
//  Created by serlight on 12/25/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "MomentCollectionViewCell.h"
#import "Photo.h"

@implementation MomentCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setPostInfo:(NSDictionary *)postInfo {
    _postInfo = postInfo;
    _postDate.text = postInfo[@"createDate"];
    [Photo retrievePhoto:postInfo[@"imageUrl"] callback:^(UIImage *image) {
        if (image) {
            _postImageView.image = image;
        }
        
    }];
    _status.text = postInfo[@"states"];
    _title.text = postInfo[@"title"];
    _clothType.text = postInfo[@"typeName"];
    [_scanCount setTitle:[postInfo[@"views"] stringValue] forState:UIControlStateNormal];
    [self setNeedsDisplay];
}

@end
