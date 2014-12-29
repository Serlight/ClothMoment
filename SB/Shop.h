//
//  Shop.h
//  SB
//
//  Created by serlight on 12/9/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject

+ (void)getShopInfo:(NSString *)logid block:(CompletionBlock)callBack;

@end
