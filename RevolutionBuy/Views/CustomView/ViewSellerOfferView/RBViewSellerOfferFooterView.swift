//
//  MenuSectionHeader.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 26/09/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class RBViewSellerOfferFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var viewoOfferButton: UIButton!

    //MARK: - Identifier
    class func identifier() -> String {
        return "RBViewSellerOfferFooterView"
    }

    class func height() -> CGFloat {
        return 82.0
    }
}
