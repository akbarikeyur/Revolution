//
//  RBConfirmationButtonAttribute.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 02/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

enum ConfirmationButtonType: Int {
    case Filled
    case BorderedOnly
}

class RBConfirmationButtonAttribute: NSObject {

    var type: ConfirmationButtonType = .Filled
    var buttonTitle: String = "Ok"
    var clickcompletion: ClickClosure?

    init(title: String, borderType type: ConfirmationButtonType = ConfirmationButtonType.Filled, clickCompletion: ClickClosure? = nil) {

        self.type = type
        self.buttonTitle = title
        self.clickcompletion = clickCompletion
    }
}
