//
//  Photo.m
//  SB
//
//  Created by serlight on 11/2/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "Photo.h"
#import <UIImageView+WebCache.h>

@implementation Photo
+ (void)retrievePhoto:(NSString *)urlStr callback:(void (^)(UIImage *image))callback
{
    if (![NSString bNoEmpty:urlStr]) {
        return;
    }
    [Photo retrievePhotoFromURL:urlStr callback:callback];
}

+ (void)retrievePhotoFromURL:(NSString *)urlString callback:(void (^)(UIImage *image))callback
{
    if ([urlString length] == 0) {
        callback(nil);
    } else {
        UIImage *photo = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:urlString];
        if (!photo) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlString] options:(SDWebImageDownloaderContinueInBackground | SDWebImageDownloaderProgressiveDownload | SDWebImageRetryFailed) progress: nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (error == nil && image != nil && finished) {
                    [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:urlString toDisk:YES];
                    callback(image);
                } else if (finished) {
                    callback(nil);
                }
            }];
        } else {
            callback(photo);
        }
    }
}
@end
