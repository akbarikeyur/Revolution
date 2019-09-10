//
//  RBItemNameCell.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 05/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBItemNameCell: UITableViewCell {

    @IBOutlet weak var lblCategories: UILabel!
    @IBOutlet weak var lblItemName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(data: RBProduct) {
        self.lblItemName.text = data.title
        lblCategories.text = data.categories()
    }

    func configureCellWithSellerOffer(data: RBSellerProduct) {
        self.lblItemName.text = data.productName()
        lblCategories.text = data.categories()
    }

    // MARK: - Class Methods

    class func identifier() -> String {
        return "RBItemNameCellIdentifier"
    }

}
