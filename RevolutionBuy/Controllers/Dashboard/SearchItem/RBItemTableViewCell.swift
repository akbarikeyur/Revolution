//
//  RBItemTableViewCell.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 28/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategories: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populateData(data: RBProduct) {

        lblTitle.text = data.title
        lblCategories.text = data.categories()
        self.imageViewItem.sd_cancelCurrentImageLoad()

        if let images = data.buyerProductImages, images.count > 0, let urlString = images[0].imageName, let theUrl: URL = URL(string: urlString) { // developer commented
//        if let images = data.buyerProductImages, images.count > 0, let urlString = images[0].imageName, let theUrl: URL = URL(string: urlString.replace("//", replacementString: "https://s3-ap-southeast-2.amazonaws.com/dev-revolutionbuy/")) {

            //            self.imageViewItem.sd_setImage(with: theUrl, placeholderImage: UIImage(named:PlaceHolderImage.cartBlueLong.rawValue))
            self.imageViewItem.rb_setImageFrom(url: theUrl)
        } else {
            self.imageViewItem.image = UIImage(named: PlaceHolderImage.cartBlueLong.rawValue)
        }
    }

    func populateDataFromPurchasedProduct(data: RBPurchasedProduct) {

        lblTitle.text = data.title
        lblCategories.text = data.categories()
        self.imageViewItem.sd_cancelCurrentImageLoad()

        if let sellerProductsArray: [RBSellerProduct] = data.sellerProducts, sellerProductsArray.count > 0, let imagesArray: [RBSellerProductImages] = sellerProductsArray[0].sellerProductImages, imagesArray.count > 0, let urlString = imagesArray[0].imageName, let theUrl: URL = URL(string: urlString) {
            //            self.imageViewItem.sd_setImage(with: theUrl, placeholderImage: UIImage(named:PlaceHolderImage.cartBlueLong.rawValue))
            self.imageViewItem.rb_setImageFrom(url: theUrl)
        } else {
            self.imageViewItem.image = UIImage(named: PlaceHolderImage.cartBlueLong.rawValue)
        }
    }

    class func identifier() -> String {
        return "RBItemTableViewCell"
    }
}
