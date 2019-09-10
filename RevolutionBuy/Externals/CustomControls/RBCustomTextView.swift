//
//  RBCustomTextView.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 02/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBCustomTextView: UITextView {

    /**
     Masks the layer to it's bounds and updates the layer properties and shadow path.
     */
    override func awakeFromNib() {
        super.awakeFromNib()

        //Set textview configuration
        self.font = UIFont.avenirNextRegular(15.0)
        self.textColor = Constants.color.textFieldTextColor

        self.updateProperties()
    }

    private func updateProperties() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 0.8
        self.layer.borderColor = Constants.color.textFieldBorderDefaultColor.cgColor
    }
}
