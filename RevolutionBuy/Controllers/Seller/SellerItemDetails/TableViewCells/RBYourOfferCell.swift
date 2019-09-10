//
//  RBYourOfferCell.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 05/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBYourOfferCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var lblOffer: UILabel!

    func configureCellWithSellerOffer(offer: RBSellerProduct) {
//        self.lblOffer.text = "$\(offer.priceProduct())" // developer commented
        if offer.description().components(separatedBy: "&&").count > 0 {
            self.lblOffer.text =  offer.description().components(separatedBy: "&&")[0] + "\(offer.priceProduct())"
        } else {
            self.lblOffer.text = "$\(offer.priceProduct())"
        }
    }

    // MARK: - Class Methods
    class func identifier() -> String {
        return "RBYourOfferCellIdentifier"
    }
}
