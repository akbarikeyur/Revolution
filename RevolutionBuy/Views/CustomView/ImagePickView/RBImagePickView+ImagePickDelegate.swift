//
//  RBImagePickView+ImagePickDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 07/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBImagePickView: BABImagePickDelegate  {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        if let imageCaptured: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            //  343 / 269
            let ratio: CGFloat = Constants.KSCREEN_WIDTH / 343.0
            let newWidth = 343.0 * ratio
            let newHeight = 269.0 * ratio
            let cropSize = CGSize(width: newWidth, height: newHeight)
            //            let newCropRect = CGRect(x: 0.0, y: (Constants.KSCREEN_HEIGHT - cropSize.height) / 2.0, width: cropSize.width, height: cropSize.height)

            let cropper: BABViewController = BABViewController.cropperInstance(with: imageCaptured, cropsize: cropSize, delegate: self)
            picker.pushViewController(cropper, animated: true)
        }
    }

    //MARK: - BABImagePickDelegate

    internal func imageCropperDidClickCancel(_ cropper: BABViewController!) {
        cropper.dismiss(animated: true, completion: nil)
    }

    internal func imageCropper(_ cropper: BABViewController!, didCropImage croppedImage: UIImage!) {
        self.setImage(image: croppedImage)
        self.hideRemoveControls(animated: false)

        cropper.dismiss(animated: true) {
            self.checkImageAndSetSubviews(animated: true)
        }
    }
}
