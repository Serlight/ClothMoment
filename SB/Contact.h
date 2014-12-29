//
//  Contact.h
//  SB
//
//  Created by serlight on 12/5/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

+ (void)getFriendList:(NSDictionary *)parameters callback:(CompletionBlock)callback;

@end
