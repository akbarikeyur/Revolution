//
//  RBSendOfferViewController+ImagePicker.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

extension RBSendOfferViewController {

    // UIImagePickerControllerDelegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        // Image here
        arrImages[currentIndex] = image
        picker.dismiss(animated: true, completion: nil)
        updateImageViews()
    }
}
