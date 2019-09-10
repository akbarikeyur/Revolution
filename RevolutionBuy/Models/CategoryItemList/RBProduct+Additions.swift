//
//  Product+Additions.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 14/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBProduct {

    func numberOfBuyerImages() -> Int {
        if let count = self.buyerProductImages?.count {
            return count
        }

        return 0
    }
}
