//
//  Moments.m
//  SB
//
//  Created by serlight on 11/4/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "Moments.h"
#import "SBHTTPSessionManager.h"

@implementation Moments

+ (void)getMoments:(NSDictionary *)parameters block:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:MomentsUrl
                        withParameters:parameters
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, responseObj);
                       }];
}

+ (void)getMomentInfo:(NSString *)momentId block:(CompletionBlock)callback {
    NSDictionary *parameters = @{@"id": momentId};
    [SBHTTPSessionManager postWithPath:MomentInfoUrl
                        withParameters:parameters
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, responseObj);
                       }];
}

+ (void)favoriteRecorde:(NSDictionary *)favoriteInfo block:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:AddFavorite
                        withParameters:favoriteInfo
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, responseObj);
                       }];
}

+ (void)getBuyMomentInfo:(NSString *)momentId block:(CompletionBlock)callback {
    NSDictionary *parameters = @{@"id": momentId};
    [SBHTTPSessionManager postWithPath:buyInfoUrl
                        withParameters:parameters
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, responseObj);
                       }];
}

+ (void)getFavoriateList:(CompletionBlock)callback {
    NSDictionary *parameter = [NSDictionary dictionary];
    [SBHTTPSessionManager postWithPath:GetFavoriteList
                        withParameters:parameter
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, responseObj);
                       }];
}

+ (void)getNearByInof:(NSDictionary *)inof block:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:GetNearByInfo
                        withParameters:inof
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, responseObj);
                       }];
}



@end
