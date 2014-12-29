//
//  UserProfileViewController.m
//  SB
//
//  Created by serlight on 11/17/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "UserProfileViewController.h"
#import "User.h"
#import <MHTextField.h>

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIView *basicView;
@property (weak, nonatomic) IBOutlet UIView *otherVIew;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改个人资料";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    _basicView.layer.borderColor = UIColorFromRGB(196, 196, 196).CGColor;
    _basicView.layer.borderWidth = 1.0f;
    
    _otherVIew.layer.borderColor = UIColorFromRGB(196, 196, 196).CGColor;
    _otherVIew.layer.borderWidth = 1.0f;
    _buyRadioButton.groupButtons = @[_buyRadioButton, _sellRadioButton];
    [self initialUserInfo];
}

- (void)initialUserInfo {
    NSDictionary *userInfo = [User getUserInfo];
    _accountTextField.text = userInfo[@"logid"];
    _companyNameTextField.text = userInfo[@"companyName"];
    _nameTextField.text = userInfo[@"name"];
    _idCardTextField.text = userInfo[@"idCard"];
    _companyNumTextField.text = userInfo[@"licenseId"];
    _companyAddressTextField.text = userInfo[@"licenseAddr"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)submitTouchUpInside:(id)sender {
    NSString *companyName = _companyAddressTextField.text;
    NSString *name = _nameTextField.text;
    if (![NSString bNoEmpty:companyName]) {
        [[[UIAlertView alloc] initWithTitle:nil
                                   message:@"必须提供公司名称"
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    if (![NSString bNoEmpty:name]) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"必须提供用户名"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"name"] = name;
    userInfo[@"companyName"] = companyName;
    if (_buyRadioButton.selected) {
        userInfo[@"authStatus"] = @"0";
    } else {
        userInfo[@"authStatus"] = @"1";
    }
    
    if ([NSString bNoEmpty:_idCardTextField.text]) {
        userInfo[@"idCard"] = _idCardTextField.text;
    }
    if ([NSString bNoEmpty:_companyNumTextField.text]) {
        userInfo[@"licenseId"] = _companyNumTextField.text;
    }
    if ([NSString bNoEmpty:_companyAddressTextField.text]) {
        userInfo[@"licenseAddr"] = _companyAddressTextField.text;
    }
    
    
    
}


@end
