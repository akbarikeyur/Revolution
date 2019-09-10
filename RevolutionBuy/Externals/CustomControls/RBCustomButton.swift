//
//  PXCustomButton.swift
//  RevolutionBuy
//
//  Created by Appster on 02/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class RBCustomButton: UIButton {

    //MARK: - Inspectable -
    @IBInspectable var doesBorderRequired: Bool = false
    @IBInspectable var borderColor: UIColor = Constants.color.buttonCornerRadiusColor
    @IBInspectable var shadowColor: UIColor = UIColor.lightGray

    /**
     Masks the layer to it's bounds and updates the layer properties and shadow path.
     */
    override func awakeFromNib() {
        super.awakeFromNib()

        if doesBorderRequired == false {
            self.layer.masksToBounds = false
            self.updateProperties()
            self.updateShadowPath()
        } else {
            self.updateBorderProperties()
        }
    }

    /**
     Updates all layer properties according to the public properties of the `ShadowView`.
     */
    private func updateProperties() {
        self.layer.cornerRadius = 4.0
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.5
    }

    /**
     Updates all border properties according to the public properties of the `ShadowView`.
     */
    private func updateBorderProperties() {
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = borderColor.cgColor
    }

    /**
     Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
     */
    private func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    /**
     Updates the shadow path everytime the views frame changes.
     */
    override func layoutSubviews() {
        super.layoutSubviews()

        self.updateShadowPath()
    }
}
