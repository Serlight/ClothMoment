//
//  SBHTTPSessionManager.m
//  SB
//
//  Created by serlight on 10/23/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "SBHTTPSessionManager.h"
#import "User.h"

@implementation SBHTTPSessionManager

+ (instancetype)sharedSessionManager {
    static SBHTTPSessionManager *sbHttpSessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sbHttpSessionManager) {
            sbHttpSessionManager = [[SBHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
        }
        [sbHttpSessionManager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [sbHttpSessionManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    });
    [sbHttpSessionManager setSecurityPolicy:AFSSLPinningModeNone];
    [[sbHttpSessionManager requestSerializer] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [[sbHttpSessionManager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[sbHttpSessionManager requestSerializer] setTimeoutInterval:RequestTimeoutInterval];
    
    return sbHttpSessionManager;
}


+ (void)requestWithPath:(NSString *)path
         withParameters:(NSDictionary *)parameters
             withMethod:(RequestType)requestType
        completionBlock:(CompletionBlock)callback {
    if (requestType == GetRequest) {
        [[SBHTTPSessionManager sharedSessionManager] GET:path
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *task, id responseObject) {
                                                          MLog(@"JSON:%@", responseObject);
                                                          callback(RequestSucceed, responseObject);
                                                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                          [SBHTTPSessionManager dealFailureCallBackWithTask:task
                                                                                                           error:error
                                                                                              completionCallBack:callback];
                                                      }];
    }
    if (requestType == PostRequest) {
        [[SBHTTPSessionManager sharedSessionManager] POST:path
                                                    parameters:parameters
                                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                                           MLog(@"JSON:%@", responseObject);
                                                           callback(RequestSucceed, responseObject);
                                                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                           MLog(@"Error:%@", error);
                                                           callback(RequestFailed, nil);
                                                           
                                                       }];
    }
    if (requestType == PutRequest) {
        [[SBHTTPSessionManager sharedSessionManager] PUT:path
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask *task, id responseObject) {
                                                          MLog(@"JSON:%@", responseObject);
                                                          callback(RequestSucceed, responseObject);
                                                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                          MLog(@"Error:%@", error);
                                                          callback(RequestFailed, nil);
                                                      }];
    }
    if (requestType == DeleteRequest) {
        [[SBHTTPSessionManager sharedSessionManager] DELETE:path
                                                      parameters:parameters
                                                         success:^(NSURLSessionDataTask *task, id responseObject) {
                                                             MLog(@"JSON:%@", responseObject);
                                                             callback(RequestSucceed, responseObject);
                                                         } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                             MLog(@"Error:%@", error);
                                                             callback(RequestFailed, nil);
                                                         }];
    }
}

+ (void)dealFailureCallBackWithTask:(NSURLSessionDataTask *)task error:(NSError *)error completionCallBack:(CompletionBlock)callback {
    MLog(@"ERR=%@", error);
    ResponseType responseType = RequestFailed;
    if (error.code == NSURLErrorTimedOut) {
        responseType = RequestTimeout;
    }
    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache]
                                           cachedResponseForRequest:task.currentRequest];
    if (!cachedResponse && [[cachedResponse data] length] > 0) {
        NSError *cacheResponseError;
        id responseObject = [[SBHTTPSessionManager sharedSessionManager].responseSerializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:&cacheResponseError];
        if (!cacheResponseError) {
            callback(ResponseFromCache, responseObject);
            responseType = ResponseFromCache;
        } else {
            callback(RequestFailed, nil);
            MLog(@"Cache response error:%@", cacheResponseError);
        }
    }
}

+ (void)postWithPath:(NSString *)path withParameters:(NSDictionary *)parameters completionBlock:(CompletionBlock)callback {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    if ([User getSessionId]) {
        param[@"sessionId"] = [User getSessionId];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    parameters = @{@"requestData":str};
    [[SBHTTPSessionManager sharedSessionManager] POST:path
                                           parameters:parameters
                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                  [SBHTTPSessionManager operationPostResult:responseObject
                                                                                      block:callback];
                                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                  callback(RequestFailed, nil);
                                              }];
}

+ (void)operationPostResult:(id)responseObject block:(CompletionBlock)callback {
    id result = [NSJSONSerialization JSONObjectWithData:responseObject
                                                           options:NSJSONReadingMutableContainers error:nil];
    if ([[result[@"return_code"] stringValue] isEqualToString:@"-1"]) {
        callback(RequestDuplicate, result[@"return_msg"]);
        return;
    }
    if (![[result[@"return_code"] stringValue] isEqualToString:@"0"]) {
        callback(RequestFailed, nil);
        return;
    }
    callback(RequestSucceed, result[@"return_value"]);
}




@end
