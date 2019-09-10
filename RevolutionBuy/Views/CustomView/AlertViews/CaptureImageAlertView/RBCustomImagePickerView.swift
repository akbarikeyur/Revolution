//
//  RBCustomImagePickerView.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 05/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

typealias CustomImagePickerViewClosure = ((RBCustomImagePickerView.SelectedSourceType) -> Void)

class RBCustomImagePickerView: RBAlertBaseView {

    //MARK: - IBOutlet -
    @IBOutlet var bottomSpaceConstraintImageView: NSLayoutConstraint!

    //MARK: - Variables -
    var tapImagePickerViewClosure: CustomImagePickerViewClosure?

    //MARK: - enum -
    enum SelectedSourceType: Int {
        case camera = 0, photoLibrary, cancel
    }

    //MARK: - Public Methods -
    class func showCustomImagePickerView(onCompletion: CustomImagePickerViewClosure? = nil) {
        DispatchQueue.main.async {
            let viewImagePickerView = self.makeImagePickerView(onCompletion: onCompletion)
            viewImagePickerView.showAlert()
        }
    }

    //MARK: - Private Methods -
    private class func makeImagePickerView(onCompletion: CustomImagePickerViewClosure? = nil) -> RBCustomImagePickerView  {

        let viewImagePickerView: RBCustomImagePickerView = UINib(nibName: "RBCustomImagePickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RBCustomImagePickerView

        viewImagePickerView.tapImagePickerViewClosure = onCompletion

        viewImagePickerView.frame = CGRect(x: 0.0, y: 0.0, width: Constants.KSCREEN_WIDTH, height: Constants.KSCREEN_HEIGHT)

        let finalHeight = 210.0 * Constants.KSCREEN_HEIGHT_RATIO
        viewImagePickerView.whiteViewFinalHeight = -finalHeight
        viewImagePickerView.bottomConstraint = viewImagePickerView.bottomSpaceConstraintImageView

        return viewImagePickerView
    }

    private func hideImagePickerView(_ type: RBCustomImagePickerView.SelectedSourceType) {

        self.tapImagePickerViewClosure?(type)
    }

    //MARK: - IBAction -
    @IBAction func clickCameraAction(_ sender: UIButton) {
        self.dismissAlert {
            self.hideImagePickerView(RBCustomImagePickerView.SelectedSourceType.camera)
        }
    }

    @IBAction func clickPhotoLibraryAction(_ sender: UIButton) {
        self.dismissAlert {
            self.hideImagePickerView(RBCustomImagePickerView.SelectedSourceType.photoLibrary)
        }
    }

    @IBAction func clickCancelAction(_ sender: UIButton) {
        self.dismissAlert {
            self.hideImagePickerView(RBCustomImagePickerView.SelectedSourceType.cancel)
        }
    }

}
