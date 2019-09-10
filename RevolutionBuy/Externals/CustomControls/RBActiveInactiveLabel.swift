
//
//  RBActiveInactiveLabel.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBActiveInactiveLabel: UILabel {

    //MARK: - Boolean for label active/inactive -
    @IBInspectable var isLabelActive: Bool = true {
        didSet {
            self.setLabelActiveInactive()
        }
    }

    //MARK: - View life cycle -
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Label Active/Inactive color -
    private func setLabelActiveInactive() {
        if isLabelActive == true {
            self.setLabelActive()
        } else {
            self.setLabelInActive()
        }
    }

    private func setLabelActive() {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.backgroundColor = Constants.color.labelActiveColor
        self.textColor = UIColor.white
    }

    private func setLabelInActive() {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.backgroundColor = UIColor.white
        self.textColor = Constants.color.labelInActiveTextColor
    }
}
