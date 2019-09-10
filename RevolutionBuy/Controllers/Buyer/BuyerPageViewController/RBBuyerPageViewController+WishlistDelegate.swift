//
//  RBBuyerPageViewController+WishlistDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBBuyerPageViewController: RBBuyerWishlistDelegate {

    internal func addItemClicked() {
        self.baseDelegate?.newItemAddButtonClicked()
    }

    internal func openWishListDetail(wishListController: RBBuyerWishListVC, item: RBProduct, index: Int) {
        self.baseDelegate?.openWishListDetail(pageController: self, item: item, index: index)
    }
}
