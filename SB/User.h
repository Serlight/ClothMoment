//
//  User.h
//  SB
//
//  Created by serlight on 10/30/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (BOOL)isLogined;
+ (NSString *)getUserName;
+ (NSDictionary *)getUserInfo;
+ (NSString *)getSessionId;
+ (void)login:(NSDictionary *)userInfo block:(CompletionBlock)callback;
+ (void)signUp:(NSDictionary *)userInfo block:(CompletionBlock)callback;
+ (void)logOut:(CompletionBlock)callback;
+ (void)resetPassword:(NSDictionary *)userInfo block:(CompletionBlock)callback;
+ (void)updateUserInfo:(NSDictionary *)userInfo block:(CompletionBlock)callback;
+ (void)userAttendWithBlock:(CompletionBlock)callback;

+ (BOOL)checkLogin:(void(^)(void))callback loginedCallback:(void(^)(void))loginedCallback;
+ (void)uploadUserAvatar:(NSData *)imageData block:(CompletionBlock)callback;
+ (void)submitSuggestion:(NSString *)suggestion block:(CompletionBlock)callback;
+ (void)getCreditScoreWithBlock:(CompletionBlock)callback;

+ (void)deleteOneFriend:(NSString *)logId block:(CompletionBlock)callback;
+ (void)addOneFriend:(NSString *)logId block:(CompletionBlock)callback;

+ (void)searchUser:(NSString *)searchText block:(CompletionBlock)callback;
+ (void)getUserInfo:(NSArray *)idList block:(CompletionBlock)callback;

@end
