//
//  RBMarkTransactionCompleteTableViewCell.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 17/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

protocol RBMarkTransactionCompleteTableViewCellDelegate {
    func callClicked()
    func markCompleteClicked()
    func payViaCreditCardClicked()
    func whatsThisClicked(selected: Bool)
}

class RBMarkTransactionCompleteTableViewCell: UITableViewCell {

    @IBOutlet weak var btnMarkCompleteTransection: RBCustomButton!
    @IBOutlet weak var btnCall: RBCustomButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnWhatsThis: UIButton!

    var cellDelegate: RBMarkTransactionCompleteTableViewCellDelegate?

    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!

    class func identifier() -> String {
        return "RBMarkTransactionCompleteTableViewCell"
    }

    @IBAction func clickMark(_ sender: UIButton) {
        self.cellDelegate?.markCompleteClicked()
    }

    @IBAction func clickCall(_ sender: UIButton) {
        self.cellDelegate?.callClicked()
    }

    @IBAction func clickPayViaCreditCard(_ sender: UIButton) {
        self.cellDelegate?.payViaCreditCardClicked()
    }

    @IBAction func clickWhatsThis(_ sender: UIButton) {
        self.btnWhatsThis.isSelected = !self.btnWhatsThis.isSelected
        let show = self.btnWhatsThis.isSelected
        self.cellDelegate?.whatsThisClicked(selected: show)
    }
}
