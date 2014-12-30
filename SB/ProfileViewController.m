//
//  ProfileViewController.m
//  SB
//
//  Created by serlight on 11/2/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "ProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User.h"
#import <ZCSAvatarCaptureController.h>
#import "Photo.h"
#import "ChangeAvatarViewController.h"
#import "ShopViewController.h"
#import "FeedBackViewController.h"
#import "CreditViewController.h"
#import "ResponseViewController.h"
#import "FavoriateViewController.h"
#import "ShopNViewController.h"
#import "SettingsTableViewController.h"


@interface ProfileViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NSString *avatarUrl;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(barbuttonItemTouch:)];
    self.navigationItem.rightBarButtonItem = settingBarButton;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapTarget:)];
    [_avatarImageView addGestureRecognizer:gesture];
}

- (void)viewWillLayoutSubviews {
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth, 410);
}

- (void)viewWillAppear:(BOOL)animated {
    [User checkLogin:^{
        avatarUrl = [User getUserInfo][@"profileUrl"];
        [Photo retrievePhoto:avatarUrl callback:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    _avatarImageView.image = image;
                }
            });
        }];
    } loginedCallback:^{
        avatarUrl = [User getUserInfo][@"profileUrl"];
        [Photo retrievePhoto:avatarUrl callback:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    _avatarImageView.image = image;
                }
            });
        }];
    }];
}

- (void)avatarTapTarget:(UITapGestureRecognizer *) gesture{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"选择图片"
                                              otherButtonTitles:@"拍照", nil];
    [sheet dismissWithClickedButtonIndex:2 animated:YES];
    [sheet showFromTabBar:self.tabBarController.tabBar];
    
}

- (void)barbuttonItemTouch:(UIBarButtonItem *)sender {
    SettingsTableViewController *settings = [[AppDelegate sharedDelegate].storyboard instantiateViewControllerWithIdentifier:@"SettingsTableViewController"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settings animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shopTouchUpIndside:(id)sender {
    ShopNViewController *shop = [[AppDelegate sharedDelegate].storyboard
                                 instantiateViewControllerWithIdentifier:@"ShopNViewController"];
    NSDictionary *userInfo = [User getUserInfo];
    shop.userId = userInfo[@"logid"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shop animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (IBAction)foucsTouchUpInside:(id)sender {
    FavoriateViewController *vc = (FavoriateViewController *)[[AppDelegate sharedDelegate].secondStoryboard instantiateViewControllerWithIdentifier:@"FavoriateViewController"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (IBAction)creditTouchUpInside:(id)sender {
    CreditViewController *vc = (CreditViewController *)[[AppDelegate sharedDelegate].storyboard instantiateViewControllerWithIdentifier:@"CreditViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)responseTouch:(id)sender {
    ResponseViewController *vc = (ResponseViewController *)[[AppDelegate sharedDelegate].storyboard instantiateViewControllerWithIdentifier:@"ResponseViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)suggestionTouch:(id)sender {
    FeedBackViewController *vc = (FeedBackViewController *)[[AppDelegate sharedDelegate].storyboard instantiateViewControllerWithIdentifier:@"FeedBackViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)attendTouch:(id)sender {
    [self showHudInView:self.view hint:@""];
    [User userAttendWithBlock:^(ResponseType responseType, id responseObj) {
        [self hideHud];
        if (responseType == RequestDuplicate) {
            [self showHint:@"一天只能签到一次， 你今天已经签到了"];
        } else if (responseType == RequestSucceed) {
            [self showHint:@"签到成功，信用+2"];
        }
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex >=2) {
        return;
    }
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    [User uploadUserAvatar:imageData
                     block:^(ResponseType responseType, id responseObj) {
                         if (responseType == RequestSucceed) {
                             [self showHint:@"上传头像成功"];
                             NSMutableDictionary *userInfo = [[User getUserInfo] mutableCopy];
                             userInfo[@"profileUrl"] = responseObj[@"profile_url"];
                             [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
                         }
                     }];
    [_avatarImageView setImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
