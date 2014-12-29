//
//  Moments.h
//  SB
//
//  Created by serlight on 11/4/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Moments : NSObject

+ (void)getMoments:(NSDictionary *)parameters block:(CompletionBlock)callback;

+ (void)getMomentInfo:(NSString *)momentId block:(CompletionBlock)callback;

+ (void)favoriteRecorde:(NSDictionary *)favoriteInfo block:(CompletionBlock)callback;

+ (void)getBuyMomentInfo:(NSString *)momentId block:(CompletionBlock)callback;
+ (void)getFavoriateList:(CompletionBlock)callback;
+ (void)getNearByInof:(NSDictionary *)inof block:(CompletionBlock)callback;

@end
