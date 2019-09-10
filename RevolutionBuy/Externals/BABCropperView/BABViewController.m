//
//  BABViewController.m
//  BABCropperView
//
//  Created by Bryn Bodayle on 04/17/2015.
//  Copyright (c) 2014 Bryn Bodayle. All rights reserved.
//

#import "BABViewController.h"
#import "BABCropperView.h"

@interface BABViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet BABCropperView *cropperView;
@property (weak, nonatomic) IBOutlet UIImageView *croppedImageView;
@property (weak, nonatomic) IBOutlet UIButton *cropButton;

@property (weak, nonatomic) id <BABImagePickDelegate> cropperDelegate;

@property (strong, nonatomic) UIImage *originalImage;
@property (assign, nonatomic) CGSize cropSize;

@end

@implementation BABViewController

+(BABViewController *)cropperInstanceWithImage:(UIImage *)image cropsize:(CGSize)cropSize delegate:(id <BABImagePickDelegate>) cropDelegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Cropper" bundle:nil];
    BABViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"BABViewController"];
    controller.cropSize = cropSize;
    controller.originalImage = image;
    controller.cropperDelegate = cropDelegate;
    controller.cropperView.cropsImageToCircle = NO;
    return controller;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cropperView.cropsImageToCircle = NO;
    self.cropperView.cropSize = self.cropSize;
    self.cropperView.image = self.originalImage;
}

#pragma mark - Button Targets
- (IBAction)cropButtonPressed:(id)sender {
    __weak typeof(self)weakSelf = self;
    [self.cropperView renderCroppedImage:^(UIImage *croppedImage, CGRect cropRect){
        [weakSelf displayCroppedImage:croppedImage];
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    __weak typeof(self)weakSelf = self;
    [self.cropperDelegate imageCropperDidClickCancel:weakSelf];
}

- (void)displayCroppedImage:(UIImage *)croppedImage {
    __weak typeof(self)weakSelf = self;
    [self.cropperDelegate imageCropper:weakSelf didCropImage:croppedImage];
}

@end
