//
//  Photo.h
//  SB
//
//  Created by serlight on 11/2/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject
+ (void)retrievePhoto:(NSString *)urlStr callback:(void (^)(UIImage *image))callback;
@end
