//
//  ResetPasswordViewController.h
//  SB
//
//  Created by serlight on 11/6/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MHTextField.h>

@interface ResetPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet MHTextField *oldPassword;
@property (weak, nonatomic) IBOutlet MHTextField *password;
@property (weak, nonatomic) IBOutlet MHTextField *confirmPassword;

@end
