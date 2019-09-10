//
//  RBBuyerBaseVC+AddItemDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 02/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBBuyerBaseVC: RBAddItemDelegate {

    internal func itemUpdatedFromServer(with updatedItem: RBProduct) {
        // nothing to do
        self.dismissItemAddition()
    }

    internal func newItemAddedFromServer(with newItem: RBProduct) {
        // Add item in array
        // In self.buyerPageViewController.wishlistController datasource
        if let pageController = self.buyerPageViewController {
            pageController.wishListController.dataSource.addNewProduct(newItem: newItem)
            pageController.wishListController.wishlistTableview.reloadData()
            let topIndex: IndexPath = IndexPath.init(row: 0, section: 0)
            pageController.wishListController.wishlistTableview.scrollToRow(at: topIndex, at: .top, animated: false)
        }
    }

    internal func dismissItemAddition() {
        self.dismiss(animated: true, completion: nil)
    }
}
