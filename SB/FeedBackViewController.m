//
//  FeedBackViewController.m
//  SB
//
//  Created by serlight on 12/26/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "FeedBackViewController.h"
#import "User.h"

@interface FeedBackViewController () <UITextViewDelegate>

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _feedbackTextView.placeholder = @"请输入你要反馈的意见";
    _feedbackTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _feedbackTextView.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (![NSString bNoEmpty:textView.text]) {
        _commit.enabled = NO;
    } else {
        _commit.enabled = YES;
    }
}

- (IBAction)commitTouch:(id)sender {
    [self showHudInView:self.view hint:@"提交意见"];
    [User submitSuggestion:_feedbackTextView.text
                     block:^(ResponseType responseType, id responseObj) {
                         [self hideHud];
                         if (responseType == RequestSucceed) {
                             [Utils showCustomHud:@"提交成功"];
                         }
                         [self.navigationController popViewControllerAnimated:YES];
                     }];
}



@end
