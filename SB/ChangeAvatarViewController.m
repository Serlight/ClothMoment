//
//  ChangeAvatarViewController.m
//  SB
//
//  Created by serlight on 11/30/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "ChangeAvatarViewController.h"
#import <ZCSAvatarCaptureController.h>
#import "Photo.h"

@interface ChangeAvatarViewController () <ZCSAvatarCaptureControllerDelegate>{
    ZCSAvatarCaptureController *avatarCapture;
}

@end

@implementation ChangeAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Photo retrievePhoto:_avatarString
                callback:^(UIImage *image) {
                    _avatarImageView.image = image;
    }];
    
    avatarCapture = [[ZCSAvatarCaptureController alloc] init];
    avatarCapture.image = _avatarImageView.image;
    avatarCapture.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    _avatarImageView.layer.cornerRadius = (ScreenWidth - 110 * 2) / 2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)avatarTapGesture:(id)sender {
    [self.view addSubview:avatarCapture.view];
    [avatarCapture startCapture];
}

- (void)imageSelected:(UIImage *)image {
    _avatarImageView.image = image;
}
- (void)imageSelectionCancelled {
    
}

@end
