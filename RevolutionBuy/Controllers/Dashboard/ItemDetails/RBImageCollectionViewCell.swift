//
//  RBImageCollectionViewCell.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgvProduct: UIImageView!

    func configureCellWithImage(imageData: RBBuyerProductImages?) {

        if let image = imageData, let url = image.imageName, let theUrl: URL = URL(string: url) {
            //            imgvProduct.sd_setImage(with: theUrl, placeholderImage: UIImage(named:PlaceHolderImage.cartBlueNormal.rawValue))
            self.imgvProduct.rb_setImageFrom(url: theUrl)
        } else {
            imgvProduct.image = UIImage(named: PlaceHolderImage.cartBlueNormal.rawValue)
        }
    }

    func configureSellerOfferProductCellWithImage(imageData: RBSellerProductImages?) {

        if let image = imageData, let url = image.imageName, let theUrl: URL = URL(string: url) {
            //            imgvProduct.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:PlaceHolderImage.cartBlueNormal.rawValue))
            self.imgvProduct.rb_setImageFrom(url: theUrl)
        } else {
            imgvProduct.image = UIImage(named: PlaceHolderImage.cartBlueNormal.rawValue)
        }
    }

    class func identifier() -> String {
        return "RBImageCollectionViewCell"
    }
}


