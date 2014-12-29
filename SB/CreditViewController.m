//
//  CreditViewController.m
//  SB
//
//  Created by serlight on 12/26/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "CreditViewController.h"
#import "User.h"

@interface CreditViewController ()

@end

@implementation CreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showHudInView:self.view hint:@"获取信用额度"];
    [User getCreditScoreWithBlock:^(ResponseType responseType, id responseObj) {
        [self hideHud];
        if (responseType == RequestSucceed) {
            _creditLabel.text = [responseObj[@"creditScore"] stringValue];
        }
    }];
}
@end
