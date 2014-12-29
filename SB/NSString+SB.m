//
//  NSString+SB.m
//  SB
//
//  Created by serlight on 11/16/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "NSString+SB.h"

@implementation NSString (SB)
+ (BOOL)bNoEmpty:(NSString *)str
{
    if((nil != str) && ([NSNull null]!= (NSNull *)str) && ([str length]>0)){
        return YES;
    }else{
        return NO;
    }
}

@end
