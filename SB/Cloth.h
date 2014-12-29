//
//  Cloth.h
//  SB
//
//  Created by serlight on 11/9/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cloth : NSObject

+ (void) getRecommendInfo:(NSDictionary *)parameters block:(CompletionBlock)callback;

+ (void) getMomentInfo:(NSDictionary *)parameters block:(CompletionBlock)callback;

+ (void)getClothsTypeWithBlock:(CompletionBlock)callback;

+ (void)uploadImage:(NSData *)imageData block:(CompletionBlock)callback;

+ (void)releasePurchasePost:(NSDictionary *)postInfo block:(CompletionBlock)callback;

+ (void)releaseSupplyPost:(NSDictionary *)postInfo block:(CompletionBlock)callback;

@end
