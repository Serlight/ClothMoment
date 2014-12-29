//
//  Utils.h
//  SB
//
//  Created by serlight on 12/26/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (instancetype)sharedInstance;

+ (void)showCustomHud:(NSString *)text;

- (NSDictionary *)getCurrentLocation;

@end
