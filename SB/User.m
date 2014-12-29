//
//  User.m
//  SB
//
//  Created by serlight on 10/30/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "User.h"
#import "SBHTTPSessionManager.h"
#import "LoginViewController.h"
#import <AFHTTPRequestOperationManager.h>

@implementation User

+ (BOOL)isLogined {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"]) return YES;
    return NO;
}

+ (NSString *) getUserName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
}

+ (NSString *)getSessionId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"];
}

+ (NSDictionary *)getUserInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
}

+ (void)login:(NSDictionary *)userInfo block:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:LoginUrl
                        withParameters:userInfo
                       completionBlock:^(ResponseType responseType, NSDictionary *dict) {
                           if (responseType == RequestSucceed) {
                               [User cachedUserInfo:dict];
                           }
                           callback(responseType, dict);
                       }];
}

+ (void)resetPassword:(NSDictionary *)userInfo block:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:ResetPasswordUrl
                        withParameters:userInfo
                       completionBlock:callback];
}

+ (void)signUp:(NSDictionary *)userInfo block:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:SignUpUrl
                        withParameters:userInfo completionBlock:^(ResponseType responseType, id responseObj) {
                            callback(responseType, responseObj);
                        }];
}

+ (void)logOut:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:LogOutUrl
                        withParameters:@{}
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           [self clearUserInfo];
                           if (callback) {
                               callback(responseType, responseObj);
                           }
                       }];
}

+ (void)cachedUserInfo:(NSDictionary *)userInfo {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:userInfo[@"sessionId"] forKey:@"sessionId"];
    [defaults setObject:userInfo[@"name"] forKey:@"userName"];
    [defaults setObject:userInfo forKey:@"userInfo"];
    [defaults synchronize];
}

+ (void)clearUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"sessionId"];
    [defaults removeObjectForKey:@"userName"];
    [defaults removeObjectForKey:@"userInfo"];
}

+ (void)updateUserInfo:(NSDictionary *)userInfo block:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:UpdateUserInfo
                        withParameters:userInfo
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           if (responseType == RequestSucceed) {
                               [User cachedUserInfo:responseObj];
                               callback(responseType, responseObj);
                           }
                       }];
    
}

+ (void)userAttendWithBlock:(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:AttendUrl
                        withParameters:[NSDictionary dictionary]
                       completionBlock:callback];
}

+ (void)presendLoginWindow:(void(^)(void))callback {
    LoginViewController *loginVC = [[AppDelegate sharedDelegate].storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    loginVC.callback = callback;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [[AppDelegate sharedDelegate].tabbarController.selectedViewController presentViewController:nav
                                                                                       animated:NO completion:nil];
}

+ (BOOL)checkLogin:(void (^)(void))callback loginedCallback:(void (^)(void))loginedCallback {
    if (![User isLogined]) {
        [User presendLoginWindow:callback];
        return NO;
    } else {
        loginedCallback();
        return YES;
    }
}

+ (void)uploadUserAvatar:(NSData *)imageData block:(CompletionBlock)callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([User getSessionId]) {
        param[@"sessionId"] = [User getSessionId];
    }
    NSURL *baseUrl = [NSURL URLWithString:@""];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    
    [manager POST:SetProfile
       parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData
                                name:@"File"
                            fileName:@"file"
                            mimeType:@"image/jpeg"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    [formData appendPartWithFormData:jsonData name:@"requestData"];
} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if ([responseObject[@"return_code"]  isEqual: @(0)]){
        callback(RequestSucceed, responseObject[@"return_value"]);
    }
    callback(RequestFailed,nil);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    callback(RequestFailed,nil);
}];
}

+ (void)submitSuggestion:(NSString *)suggestion block:(CompletionBlock)callback {
    NSDictionary *parameters =@{@"contents": suggestion, @"logid":[User getUserInfo][@"logid"]};
    [SBHTTPSessionManager postWithPath:SaveSuggestion
                        withParameters:parameters
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, nil);
                       }];
}

+ (void)getCreditScoreWithBlock:(CompletionBlock)callback {
    NSDictionary *parameter = [NSDictionary dictionary];
    [SBHTTPSessionManager postWithPath:GetCreditScore
                        withParameters:parameter
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, responseObj);
                       }];
}

+ (void)deleteOneFriend:(NSString *)logId block:(CompletionBlock)callback {
    NSDictionary *parameter = @{@"id": logId};
    [SBHTTPSessionManager postWithPath:DeleteOneUser
                        withParameters:parameter
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, responseObj);
                       }];
}

+ (void)addOneFriend:(NSString *)logId block:(CompletionBlock)callback {
    NSDictionary *parameter = @{@"id":logId};
    [SBHTTPSessionManager postWithPath:AddFriend
                        withParameters:parameter
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, responseObj);
                       }];
}

+ (void)searchUser:(NSString *)searchText block:(CompletionBlock)callback {
    NSDictionary *parameter = @{@"str": searchText};
    [SBHTTPSessionManager postWithPath:SearchFriend
                        withParameters:parameter
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, responseObj);
                       }];
}

+ (void)getUserInfo:(NSArray *)idList block :(CompletionBlock)callback {
    [SBHTTPSessionManager postWithPath:GetUserInfo
                        withParameters:@{@"idList":idList}
                       completionBlock:^(ResponseType responseType, id responseObj) {
                           callback(responseType, responseObj);
                       }];
}

@end
