//
//  RBItemDescriptionCell.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 05/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBItemDescriptionCell: UITableViewCell {

    @IBOutlet weak var lblItemDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(data: RBProduct?) {
        if let descp = data?.description(), descp.length > 0 {
            self.lblItemDescription.text = descp
        } else {
            self.lblItemDescription.text = "Not added by buyer"
        }
    }

    func configureCellWithProductOffer(data: RBSellerProduct?) {

//        self.lblItemDescription.text = data?.description() // Developer commented
        
        var descriptionWithCurrencyArray = data?.description().components(separatedBy: "&&")
        if descriptionWithCurrencyArray?.count ?? 0 > 1 {
            descriptionWithCurrencyArray?.remove(at: 0)
        }
        
        self.lblItemDescription.text = descriptionWithCurrencyArray?.joined(separator: " ")
    }

    // MARK: - Class Methods

    class func identifier() -> String {
        return "RBItemDescriptionCellIdentifier"
    }

}
