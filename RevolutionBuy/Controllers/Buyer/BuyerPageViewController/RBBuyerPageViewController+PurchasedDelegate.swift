//
//  File.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBBuyerPageViewController: RBBuyerPurchasedDelegate {

    internal func openPurchasedDetail(purchasedController: RBBuyerPurchasedVC, item: RBPurchasedProduct) {
        self.baseDelegate?.openPurchasedDetail(pageController: self, purchasedItem: item)
    }
}
