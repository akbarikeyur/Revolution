//
//  BABViewController.h
//  BABCropperView
//
//  Created by Bryn Bodayle on 04/17/2015.
//  Copyright (c) 2014 Bryn Bodayle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BABImagePickDelegate.h"
#import "BABCropperView.h"

@interface BABViewController : UIViewController

+(BABViewController *)cropperInstanceWithImage:(UIImage *)image cropsize:(CGSize)cropSize delegate:(id <BABImagePickDelegate>) cropDelegate;

@end
