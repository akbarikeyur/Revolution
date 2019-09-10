//
//  RBViewSellerOfferTitleTableViewCell.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 13/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBViewSellerOfferTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblCategories: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func identifier() -> String {
        return "RBViewSellerOfferTitleTableViewCell"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(data: RBSellerProduct?) {

        if let productDetail = data {
//            lblPrice.text = "$\(productDetail.priceProduct())" // Developer commented
            if productDetail.description().components(separatedBy: "&&").count > 0 {
                self.lblPrice.text =  productDetail.description().components(separatedBy: "&&")[0] + "\(productDetail.priceProduct())"
            } else {
                lblPrice.text = "$\(productDetail.priceProduct())"
            }

            lblProductName.text = productDetail.productName()
        }
    }

    func configurePurchasedCell(product: RBPurchasedProduct) {
        self.lblProductName.text = product.titleString()
        self.lblCategories.text = product.categories()
        if let sellerProduct = product.sellerProductModel() {
//            lblPrice.text = "$\(sellerProduct.priceProduct())" // developer commented
            
            if sellerProduct.description().components(separatedBy: "&&").count > 0 {
                self.lblPrice.text =  sellerProduct.description().components(separatedBy: "&&")[0] + "\(sellerProduct.priceProduct())"
            } else {
                lblPrice.text = "$\(sellerProduct.priceProduct())"
            }
        }
    }
}
