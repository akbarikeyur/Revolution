//
//  RBSettingsTableViewCell.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 06/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSettingsTableViewCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet var leadingViewContraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
