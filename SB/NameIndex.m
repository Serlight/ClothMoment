//
//  NameIndex.m
//  SB
//
//  Created by serlight on 12/5/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "NameIndex.h"
#import "pinyin.h"

@implementation NameIndex

- (NSString *)getFirstName {
    if ([_firstName canBeConvertedToEncoding: NSASCIIStringEncoding]) {
        return _firstName;
    } else {
        return [NSString stringWithFormat:@"%c", pinyinFirstLetter([_firstName characterAtIndex:0])];
    }
}

@end
