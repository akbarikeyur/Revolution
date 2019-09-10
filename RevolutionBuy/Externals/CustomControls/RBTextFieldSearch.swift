//
//  PXCustomTextField.swift
//  RevolutionBuy
//
//  Created by Appster on 02/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class RBTextFieldSearch: JVFloatLabeledTextField {

    override func draw(_ rect: CGRect) {
        // Drawing code
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

}
