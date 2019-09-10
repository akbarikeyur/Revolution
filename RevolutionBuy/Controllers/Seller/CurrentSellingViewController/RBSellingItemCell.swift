//
//  RBSellingItemCell.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 04/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSellingItemCell: UITableViewCell {

    @IBOutlet weak var vwInner: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell() {
        // Configure cell
    }

    // MARK: - Class Methods

    class func identifier() -> String {
        return "RBSellingItemCellIdentifier"
    }

}
