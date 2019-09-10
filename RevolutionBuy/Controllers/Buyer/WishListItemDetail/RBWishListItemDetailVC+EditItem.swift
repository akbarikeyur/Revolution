//
//  RBWishListItemDetailVC+EditItem.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 15/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBWishListItemDetailVC: RBAddItemDelegate {

    internal func itemUpdatedFromServer(with updatedItem: RBProduct) {

        // Replace Item
        self.item = updatedItem
        if let wishListController = self.wishListController {
            wishListController.dataSource.updateProduct(updatedItem: updatedItem, atIndex: self.itemIndex)
        }

        // Setup Datasource & Headers
        self.initTableDataSource()
        self.setUpHeader()
        self.setupPageControl()
        self.collectionViewItemImages.reloadData()
        self.itemDetailTableView.reloadData()
        let imageCount = self.item.numberOfBuyerImages()
        if imageCount > 0 {
            self.collectionViewItemImages.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .left, animated: false)
        }

        // Dismiss presented controller
        self.dismissItemAddition()

        // Show Alert
        RBAlert.showSuccessAlert(message: "Item has been successfully updated")
    }

    internal func newItemAddedFromServer(with newItem: RBProduct) {
        // nothing to do
        self.dismissItemAddition()
    }

    internal func dismissItemAddition() {
        self.dismiss(animated: true, completion: nil)
    }
}
