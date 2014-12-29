//
//  Shop.m
//  SB
//
//  Created by serlight on 12/9/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "Shop.h"
#import "SBHTTPSessionManager.h"

@implementation Shop

+ (void)getShopInfo:(NSString *)logid block:(CompletionBlock)callBack {
    [SBHTTPSessionManager postWithPath:GetShopInfo
                        withParameters:@{@"id":logid}
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callBack(responseType, responseObj);
                       }];
}

@end
