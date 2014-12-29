//
//  Contact.m
//  SB
//
//  Created by serlight on 12/5/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "Contact.h"
#import "SBHTTPSessionManager.h"

@implementation Contact

+ (void)getFriendList:(NSDictionary *)parameters callback:(CompletionBlock)callback {
    if (!parameters) parameters = [NSDictionary dictionary];
    [SBHTTPSessionManager postWithPath:FriendListUrl
                        withParameters:parameters
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           if (responseType == RequestSucceed) {
                               callback(responseType, responseObj[@"allData"]);
                               return ;
                           }
                           callback(responseType, [NSArray array]);
                       }];
}

@end
