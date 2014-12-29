//
//  Cloth.m
//  SB
//
//  Created by serlight on 11/9/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "Cloth.h"
#import "SBHTTPSessionManager.h"
#import "User.h"
#import <AFHTTPRequestOperationManager.h>

@implementation Cloth

+ (void)getRecommendInfo:(NSDictionary *)parameters block:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:RecommendDataUrl
                        withParameters:parameters
                       completionBlock:callback];
    
}

+ (void)getMomentInfo:(NSDictionary *)parameters block:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:MomentsUrl
                        withParameters:parameters
                       completionBlock:callback];
}

+ (void)getClothsTypeWithBlock:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:ClothType
                        withParameters:[NSDictionary dictionary]
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           if (responseType == RequestSucceed) {
                               NSArray *clothTypes = responseObj[@"allData"];
                               callback(responseType, clothTypes);
                           }
                       }];
}

+ (void)uploadImage:(NSData *)imageData block:(CompletionBlock)callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([User getSessionId]) {
        param[@"sessionId"] = [User getSessionId];
    }
    NSURL *baseUrl = [NSURL URLWithString:@""];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    
    [manager POST:UploadFile
       parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData
                                name:@"File"
                            fileName:@"file"
                            mimeType:@"image/jpeg"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    [formData appendPartWithFormData:jsonData name:@"requestData"];
} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (responseObject[@"return_code"] == 0) {
        callback(RequestSucceed, responseObject[@"return_value"]);
    }
    callback(RequestFailed,nil);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    callback(RequestFailed,nil);
}];
}

+ (void)releasePurchasePost:(NSDictionary *)postInfo block:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:UploadPurchase
                        withParameters:postInfo
                       completionBlock:callback];
    
}

+ (void)releaseSupplyPost:(NSDictionary *)postInfo block:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:UploadSupplyInfo
                        withParameters:postInfo
                       completionBlock:callback];
}

@end
