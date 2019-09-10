//
//  RBSellerBaseVC+PageControllerDelegate.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBSellerBaseVC {
    func buttonSelectedWithTag(_ tag: Int) {
        var btn: UIButton?
        switch tag {
        case self.btnCurrent.tag:
            btn = self.btnCurrent
        case self.btnSold.tag:
            btn = self.btnSold
        default: break
        }

        if btn != nil {
            self.selectHeaderButton(btn!, completion: nil)
        }
    }
}
