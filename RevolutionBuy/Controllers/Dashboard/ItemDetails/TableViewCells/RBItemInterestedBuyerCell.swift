//
//  RBItemInterestedBuyerCell.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 05/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBItemInterestedBuyerCell: UITableViewCell {

    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblInterestedBuyerName: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var vwSoldPurchase: UIView!
    @IBOutlet weak var btnItemsSold: UIButton!
    @IBOutlet weak var btnItemsPurchased: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCellWith(title: String, user: RBUser?, showFullAddress: Bool) {

        // HEADER
        self.lblHeading.text = title

        // USER NAME & ADDRESS
        guard let theUser: RBUser = user else {
            self.lblInterestedBuyerName.text = "Unknown User"
            self.btnLocation.setTitle("  None", for: .normal)
            self.btnItemsPurchased.setTitle("Unknown", for: .normal)
            self.btnItemsSold.setTitle("Unknown", for: .normal)
            return

        }
        self.lblInterestedBuyerName.text = theUser.userNameTrimmingLastWord()
//        self.btnLocation.setTitle("  \(theUser.formattedAddress(fullAddress: showFullAddress))", for: .normal) // Developer Commented
        
        
        self.btnLocation.titleLabel?.adjustsFontSizeToFitWidth = true
        self.btnLocation.titleLabel?.minimumScaleFactor = 0.5
        
        self.btnLocation.setTitle("  \(theUser.formattedAddress(fullAddress: showFullAddress))", for: .normal)

        // USER ATTRIBUTES
        self.vwSoldPurchase.layer.borderColor = UIColor(red: 128.0 / 255.0, green: 149.0 / 255.0, blue: 172.0 / 255.0, alpha: 1.0).cgColor
        self.vwSoldPurchase.layer.cornerRadius = 4.0
        self.vwSoldPurchase.layer.borderWidth = 0.2
        self.vwSoldPurchase.layer.masksToBounds = true

        let productSellSellerProduct: String = theUser.itemsSoldCount()
        let productBuyProduct: String = theUser.itemsPurchasedCount()

        //Sold string for product
        let soldStringProduct = NSMutableAttributedString(string: "\(productSellSellerProduct)\nItems Sold")
        let rangeProduct1 = (soldStringProduct.string as NSString).range(of: "Items Sold")

        // Grey color
        soldStringProduct.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 176.0 / 255.0, green: 176.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0), range: rangeProduct1)
        // Font
        soldStringProduct.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), range: rangeProduct1)

        //Update button sold
        self.btnItemsSold.titleLabel?.textAlignment = .center
        self.btnItemsSold.titleLabel?.numberOfLines = 0
        self.btnItemsSold.setAttributedTitle(soldStringProduct, for: .normal)

        let purchaseStringProduct = NSMutableAttributedString(string: "\(productBuyProduct)\nItems Purchased")
        let rangeProduct2 = (purchaseStringProduct.string as NSString).range(of: "Items Purchased")
        // Grey color
        purchaseStringProduct.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 176.0 / 255.0, green: 176.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0), range: rangeProduct2)
        // Font
        purchaseStringProduct.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0), range: rangeProduct2)

        self.btnItemsPurchased.titleLabel?.textAlignment = .center
        self.btnItemsPurchased.titleLabel?.numberOfLines = 0
        self.btnItemsPurchased.setAttributedTitle(purchaseStringProduct, for: .normal)
    }

    // MARK: - Class Methods
    class func identifier() -> String {
        return "RBItemInterestedBuyerCellIdentifier"
    }

}
