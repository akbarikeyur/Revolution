//
//  RBTopHeaderView.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 27/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBTopHeaderView: UIView {

    //MARK: - Inspectable
    @IBInspectable var border: Bool = false

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        if border {
            addCornerRadius()
        } else {
            self.setup()
        }
    }

    func setup() {

        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: -10)
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath

    }

    /**
     Updates all layer properties according to the public properties of the `ShadowView`.
     */
    private func addCornerRadius() {

        self.layer.cornerRadius = 4.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.5
    }

}
