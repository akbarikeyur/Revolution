//
//  RBAddItemPictureVC+RBImagePickViewDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 26/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBAddItemPictureVC: RBImagePickViewDelegate {

    internal func willRemoveImage(pickView: RBImagePickView, from url: String!) {

        guard let theTempItem: RBTempItem = self.addEditBaseController?.tempItem else {
            return // Not temp image object found
        }

        guard let buyerImages: [RBBuyerProductImages] = theTempItem.productImages, buyerImages.count > 0 else {
            return // No buyer images
        }

        let matchedBuyerImagesArray: [RBBuyerProductImages]? = buyerImages.filter({ $0.imageName == url })
        if let matchedBuyerImages: [RBBuyerProductImages] = matchedBuyerImagesArray, matchedBuyerImages.count > 0, let theBuyerImage: RBBuyerProductImages = matchedBuyerImages.first, let theIdentifier: Int = theBuyerImage.internalIdentifier {
            theTempItem.deletedImageIds.append("\(theIdentifier)")
        }
    }
}
