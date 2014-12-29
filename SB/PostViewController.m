//
//  PostViewController.m
//  SB
//
//  Created by serlight on 11/18/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "PostViewController.h"
#import "ClothTypeViewController.h"
#import <ELCImagePickerController.h>
#import "SBImageCollectionView.h"
#import "User.h"

@interface PostViewController () <ClothTypeDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate> {
    NSDictionary *clothTypeInfo;
    ClothTypeViewController *clothViewController;
}

@property (strong, nonatomic) NSMutableArray *images;

@end

@implementation PostViewController
@synthesize images;

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_contentView.frame));
    [_contentView setNeedsDisplay];
    _backScrollView.contentSize = _contentView.frame.size;
    [_backScrollView addSubview:_contentView];
    _photoCollection.hidden = YES;
    images = [NSMutableArray array];
    UINib *nib = [UINib nibWithNibName:@"SBImageCollectionView" bundle:nil];
    [_photoCollection registerNib:nib forCellWithReuseIdentifier:@"cell"];
    _photoCollection.delegate = self;
    _photoCollection.dataSource = self;
    _connectName.text = [User getUserName];
    _connectPhone.text = [User getUserInfo][@"logid"];
    if (_type == Buy) {
        self.navigationItem.title = @"发布求购";
    } else {
        self.navigationItem.title = @"发布供应";
    }
}

- (void)viewWillLayoutSubviews {
    _contentView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_contentView.frame));
    [_contentView updateConstraintsIfNeeded];
    [_contentView setNeedsDisplay];
}

- (IBAction)clothTypeTouch:(id)sender {
    if (!clothViewController) {
        clothViewController = [[AppDelegate sharedDelegate].storyboard instantiateViewControllerWithIdentifier:@"ClothTypeViewController"];
        clothViewController.delegate = self;
    }
    [self.navigationController pushViewController:clothViewController animated:YES];
}

- (IBAction)addImageTouch:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:@"选择图片" otherButtonTitles:@"拍照", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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

//- (void)

- (void)getClothType:(NSDictionary *)typeInfo {
    clothTypeInfo = typeInfo;
    _clothTypeField.text = typeInfo[@"name"];
    _clothTypeField.enabled = NO;
    _arrowIcon.hidden = YES;
}

#pragma mark imagepicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [images addObject:chosenImage];
    _photoCollection.hidden = NO;
    [_photoCollection reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)setImages:(NSMutableArray *)newImages {
    if (!newImages) {
        return;
    }
    images = newImages;
    if (images.count > 0) {
        [_photoCollection reloadData];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SBImageCollectionView *cell =(SBImageCollectionView *) [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = images[indexPath.item];
    return cell;
}

- (IBAction)releaseTouch:(id)sender {
    NSMutableArray *imageInfos  = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (UIImage *image in images) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        dispatch_group_async(group, queue, ^{
            [Cloth uploadImage:imageData block:^(ResponseType responseType, id responseObj) {
                if (responseType == RequestSucceed) {
                    [imageInfos addObject:responseObj[@"id"]];
                }
            }];
        });
    }
    
    dispatch_group_notify(group,
                          dispatch_get_main_queue(),
                          ^{
                              NSDictionary *postInfo = @{@"title":_titleField.text,
                                                         @"typeId":clothTypeInfo[@"id"],
                                                         @"typeName":clothTypeInfo[@"name"],
                                                         @"payMoney":_priceField.text,
                                                         @"description":_descriptionTextView.text,
                                                         @"contact":_connectName.text,
                                                         @"idList":imageInfos,
                                                         @"phone":_connectPhone.text};
                              [self showHudInView:self.view hint:@"上传数据"];
                              [Cloth releasePurchasePost:postInfo block:^(ResponseType responseType, id responseObj) {
                                  [self hideHud];
                                  [self showHint:@"发布成功"];
                              }];
                          });
}
@end
