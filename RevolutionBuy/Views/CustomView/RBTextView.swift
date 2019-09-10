//
//  RBTopHeaderView.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 27/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBTextView: UITextView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }

    func setup() {
        self.layer.borderColor = Constants.color.borderColorTextview.cgColor
        self.layer.cornerRadius = 2
        self.layer.borderWidth = 1
        self.textContainerInset = UIEdgeInsetsMake(18, 13, 16, 13)
    }

}
