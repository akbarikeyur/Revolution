//
//  RBAddItemStepNumberView.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SDWebImage

@objc protocol RBImagePickViewDelegate {
    func willRemoveImage(pickView: RBImagePickView, from url: String!)
}

typealias RBImagePickerDownloadCompletion = ((_ success: Bool) -> ())

class RBImagePickView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Variables
    private var imagePickView: ImagePickView!
    private var imageUrlString: String?

    var selectedImage: UIImage? {
        return self.imagePickView.cameraButton.image(for: .normal)
    }

    var localSelectedImage: UIImage? {
        // return image only if locally selected
        if self.imageUrlString == nil {
            return self.selectedImage
        }
        return  nil
    }

    //MARK: - Outlets
    @IBOutlet weak var pickDelegate: RBImagePickViewDelegate?

    //MARK: - Boolean for label active/inactive -
    @IBInspectable var isPrimaryImage: Bool = false {
        didSet {

        }
    }

    //MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }

    private func xibSetup() {

        imagePickView = Bundle.main.loadNibNamed("ImagePickView", owner: self, options: nil)?.first as! ImagePickView
        imagePickView.frame = bounds
        imagePickView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imagePickView.backgroundColor = UIColor.white
        addSubview(imagePickView)

        imagePickView.cameraButton.addTarget(self, action: #selector(chooseImageButtonClicked), for: .touchUpInside)
        imagePickView.cameraButton.isExclusiveTouch = true
        imagePickView.cameraButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        imagePickView.cameraButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        imagePickView.cameraButton.contentVerticalAlignment = UIControlContentVerticalAlignment.fill

        imagePickView.removeImageButton.addTarget(self, action: #selector(removeImageButtonClicked), for: .touchUpInside)
        imagePickView.removeImageButton.isExclusiveTouch = true

        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = Constants.color.borderGreyColor.cgColor
        self.clipsToBounds = true

        self.checkImageAndSetSubviews(animated: false)
    }

    //MARK: - Private Methods
    func chooseImageButtonClicked() {

        RBCustomImagePickerView.showCustomImagePickerView { (selectionType) in

            guard let parentController = self.pickDelegate as? UIViewController else {
                RBAlert.showWarningAlert(message: "No parent found to show image picker")
                return
            }

            switch selectionType {
            case RBCustomImagePickerView.SelectedSourceType.camera:
                parentController.captureImageFromDevice(camera: true, useFrontCam: false, returnDelegate: self)
            case RBCustomImagePickerView.SelectedSourceType.photoLibrary:
                parentController.captureImageFromDevice(camera: false, useFrontCam: false, returnDelegate: self)
            case RBCustomImagePickerView.SelectedSourceType.cancel:
                break
            }
        }
    }

    @objc private func removeImageButtonClicked() {

        let confirmAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: AddImageIdentifier.RemoveImageAlert.YesTitle.rawValue, borderType: ConfirmationButtonType.BorderedOnly) {
            self.setImage(image: nil)
        }
        let declineAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: AddImageIdentifier.RemoveImageAlert.CancelTitle.rawValue, borderType: ConfirmationButtonType.Filled)
        RBAlert.showConfirmationAlert(message: AddImageIdentifier.RemoveImageAlert.Title.rawValue, leftButtonAttributes: declineAction, rightButtonAttributes: confirmAction)
    }

    func checkImageAndSetSubviews(animated: Bool) {

        let hasEmptyImage = imagePickView.cameraButton.image(for: .normal) == nil
        self.imagePickView.showRemoveButton(show: !hasEmptyImage, animated: animated)
        let showPrimary = !hasEmptyImage && self.isPrimaryImage
        self.imagePickView.showPrimaryPlaceHolder(show: showPrimary, animated: animated)
    }

    func hideRemoveControls(animated: Bool) {
        self.imagePickView.showRemoveButton(show: false, animated: animated)
        self.imagePickView.showPrimaryPlaceHolder(show: false, animated: animated)
    }

    //MARK: - Methods
    func setImage(image: UIImage?) {

        if self.imageUrlString != nil {
            self.pickDelegate?.willRemoveImage(pickView: self, from: self.imageUrlString)
        }

        self.imageUrlString = nil
        self.imagePickView.cameraButton.sd_cancelImageLoad(for: .normal)
        self.imagePickView.cameraButton.setImage(image, for: .normal)
        self.checkImageAndSetSubviews(animated: true)
    }

    func setImage(from urlString: String!, onCompletion: RBImagePickerDownloadCompletion?) {

        self.imageUrlString = urlString
        self.imagePickView.cameraButton.sd_cancelImageLoad(for: .normal)

        self.imagePickView.cameraButton.sd_setImage(with: URL.init(string: urlString), for: .normal) { (image, error, cacheType, url) in

            self.checkImageAndSetSubviews(animated: true)

            if image != nil {
                onCompletion?(true)
            } else {
                //                self.imageUrlString = nil
                onCompletion?(false)
            }
        }
    }
}
