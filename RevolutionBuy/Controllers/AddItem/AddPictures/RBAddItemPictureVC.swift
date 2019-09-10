//
//  RBAddItemPictureVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 02/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SDWebImage

class RBAddItemPictureVC: UIViewController {

    //MARK: - Variables
    weak var addEditBaseController: RBAddItemBaseVC?

    //MARK: - Outlets
    @IBOutlet weak var imagePickViewOne: RBImagePickView!
    @IBOutlet weak var imagePickViewTwo: RBImagePickView!
    @IBOutlet weak var imagePickViewThree: RBImagePickView!

    @IBOutlet var imagePickViews: [RBImagePickView]!
    @IBOutlet weak var headerTitleLabel: UILabel!

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageUrls = self.addEditBaseController?.tempItem.productImages, imageUrls.count > 0 {
            RBAlert.showSuccessAlert(message: "Please wait while we load your images")
            self.loadProductsExistingImages(imageUrls: imageUrls)
        }

        RBGenericMethods.setHeaderButtonExclusive(controller: self)
    }

    //MARK: - Method
    private func loadProductsExistingImages(imageUrls: [RBBuyerProductImages]) {

        var totalDownloadCount = 0
        var totalSuccessCount = 0

        let imageDownloadNotifyBlock: ((_ downloaded: Bool) -> ()) = { (downloaded) in

            totalDownloadCount += 1
            if downloaded {
                totalSuccessCount += 1
            }

            if totalDownloadCount == imageUrls.count {
                self.view.hideLoader()

                if totalSuccessCount < totalDownloadCount {
                    RBAlert.showSuccessAlert(message: "Some images were not downloaded")
                } else {
                    RBAlert.showSuccessAlert(message: "All images downloaded")
                }
            }
        }

        self.view.showLoader(subTitle: "Loading\nimages...")

        for i in 0 ..< imageUrls.count {
            let isIndexValid = imageUrls.indices.contains(i)
            if isIndexValid, let theUrlString = imageUrls[i].imageName {
                let imagePickView = self.imagePickViews[i]
                imagePickView.setImage(from: theUrlString, onCompletion: { (success) in
                    imageDownloadNotifyBlock(success)
                })
            }
        }
    }

    private func proceedToItemAdd() {

        var imageArray: [UIImage?] = [UIImage?]()
        for imgPickView in self.imagePickViews {
            imageArray.append(imgPickView.localSelectedImage)
        }
        self.addEditBaseController?.updateImages(images: imageArray)
        self.addEditBaseController?.addTempItemToServer()
    }

    private func checkValidPhotoOrder() -> Bool {
        var isValid = true

        if self.imagePickViewOne.selectedImage == nil && (self.imagePickViewTwo.selectedImage != nil || self.imagePickViewThree.selectedImage != nil) {
            isValid = false
        }

        return isValid
    }

    private func suggestValidPhotoOrder() {

        let msgNoPrimaryImage = AddImageIdentifier.NoPrimaryImageSelectedAlert.Title.rawValue
        let leftBtnAttribute = RBConfirmationButtonAttribute.init(title: AddImageIdentifier.NoPrimaryImageSelectedAlert.YesTitle.rawValue, borderType: ConfirmationButtonType.Filled) {
            self.imagePickViewOne.chooseImageButtonClicked()
        }
        let rightBtnAttribute = RBConfirmationButtonAttribute.init(title: AddImageIdentifier.NoPrimaryImageSelectedAlert.CancelTitle.rawValue, borderType: ConfirmationButtonType.BorderedOnly) {
            self.performValidPhotoOrder()
        }
        RBAlert.showConfirmationAlert(message: msgNoPrimaryImage, leftButtonAttributes: leftBtnAttribute, rightButtonAttributes: rightBtnAttribute)
    }

    private func performValidPhotoOrder() {

        var imageArray: [UIImage] = [UIImage]()

        for imgPickView in self.imagePickViews {
            if let img = imgPickView.selectedImage {
                imageArray.append(img)
            }

            imgPickView.setImage(image: nil)
        }

        for index in 0 ..< imageArray.count {
            if index < self.imagePickViews.count {
                let imgPickView: RBImagePickView = self.imagePickViews[index]
                imgPickView.setImage(image: imageArray[index])
            }
        }
    }

    //MARK: - Clicks
    @IBAction func clickCancel(_ sender: UIButton) {
        self.addEditBaseController?.cancelClicked()
    }

    @IBAction func clickSkipNext(_ sender: UIButton) {

        if self.checkValidPhotoOrder() {
            self.proceedToItemAdd()
        } else {
            self.suggestValidPhotoOrder()
        }
    }
}
