//
//  NameIndex.h
//  SB
//
//  Created by serlight on 12/5/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameIndex : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic) NSInteger sectionNum;
@property (nonatomic) NSInteger originIndex;

- (NSString *)getFirstName;

@end
