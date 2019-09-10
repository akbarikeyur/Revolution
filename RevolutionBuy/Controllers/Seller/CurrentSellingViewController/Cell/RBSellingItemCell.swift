//
//  RBSellingItemCell.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 04/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSellingItemCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var vwInner: UIView!
    @IBOutlet weak var itemImageview: UIImageView!

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var buyerNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var buyerPlaceholderLabel: UILabel!

    // MARK: - Class Method
    class func identifier() -> String {
        return "RBSellingItemCell"
    }

    // MARK: - Methods
    func configureCell(sellerProduct: RBSellerProduct) {

        // Labels
        self.itemNameLabel.text = sellerProduct.productName()

        //self.priceLabel.text = "$\(sellerProduct.priceProduct())" // Developer Commented
        if sellerProduct.description().components(separatedBy: "&&").count > 0 {
            self.priceLabel.text =  sellerProduct.description().components(separatedBy: "&&")[0] + "\(sellerProduct.priceProduct())"
        } else {
            self.priceLabel.text = "$\(sellerProduct.priceProduct())"
        }
        
        // Buyer name
        if let buyerName = sellerProduct.buyerProduct?.user?.userNameTrimmingLastWord() {
            self.buyerNameLabel.text = buyerName
        } else {
            self.buyerNameLabel.text = "NA"
        }

        // Item Image
        self.itemImageview.sd_cancelCurrentImageLoad()
        if let images = sellerProduct.sellerProductImages, images.count > 0, let url = images[0].imageName, let theUrl: URL = URL(string: url) {
            //            self.itemImageview.sd_setImage(with: theUrl, placeholderImage: UIImage(named: PlaceHolderImage.cartBlueSquare.rawValue))
            self.itemImageview.rb_setImageFrom(url: theUrl)
        } else {
            self.itemImageview.image = UIImage(named: PlaceHolderImage.cartBlueSquare.rawValue)
        }

        // buyer placeholder
        if sellerProduct.state == .ItemSoldToBuyer {
            self.buyerPlaceholderLabel.text = "Buyer:"
        }
    }
}
