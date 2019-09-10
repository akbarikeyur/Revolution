//
//  BABImagePickDelegate.h
//  BABCropperView
//
//  Created by Pankaj Pal on 30/05/17.
//  Copyright © 2017 Bryn Bodayle. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BABViewController;

@protocol BABImagePickDelegate <NSObject>

- (void)imageCropperDidClickCancel:(BABViewController *) cropper;
- (void)imageCropper:(BABViewController *) cropper didCropImage:(UIImage *) croppedImage;

@end
