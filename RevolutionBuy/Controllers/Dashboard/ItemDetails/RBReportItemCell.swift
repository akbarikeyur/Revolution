//
//  RBReportItemCellIdentifier.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 05/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBReportItemCell: UITableViewCell {

    @IBOutlet weak var btnReport: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(data: RBProduct?) {

        if let report = data?.isReported(), report == true {
            btnReport.setTitle("Reported", for: .normal)
            btnReport.isUserInteractionEnabled = false
        }

    }
}
