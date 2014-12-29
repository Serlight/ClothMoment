//
//  SBHTTPSessionManager.h
//  SB
//
//  Created by serlight on 10/23/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface SBHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedSessionManager;

+ (void)requestWithPath:(NSString *)path
         withParameters:(NSDictionary *)parameters
             withMethod:(RequestType)requestType
        completionBlock:(CompletionBlock)callback;

+ (void)postWithPath:(NSString *)path
      withParameters:(NSDictionary *)parameters
     completionBlock:(CompletionBlock)callback;

@end
