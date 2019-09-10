//
//  RBBuyerBaseVC+PageControllerDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

//MARK: - RBBuyerBaseClassDelegate
extension RBBuyerBaseVC: RBBuyerPageControllerDelegate {

    internal func buttonSelectedWithTag(_ tag: Int) {
        var btn: UIButton?
        switch tag {
        case self.wishlistButton.tag:
            btn = self.wishlistButton
        case self.purchasedButton.tag:
            btn = self.purchasedButton
        default: break
        }

        if btn != nil {
            self.selectHeaderButton(btn!, completion: nil)
        }
    }

    internal func newItemAddButtonClicked() {
        RBGenericMethods.askGuestUserToSignUp {
            let addItemController = RBAddItemBaseVC.instanceController()
            addItemController.addEditDelegate = self
            self.present(addItemController, animated: true, completion: nil)
        }
    }

    internal func openWishListDetail(pageController: RBBuyerPageViewController, item: RBProduct, index: Int) {
        self.pushToWishListDetailScreen(item: item, itemIndex: index, wishlistController: pageController.wishListController)
    }

    internal func openPurchasedDetail(pageController: RBBuyerPageViewController, purchasedItem: RBPurchasedProduct) {
        let controller: RBPurchasedItemDetailVC = RBPurchasedItemDetailVC.controllerInstance(with: purchasedItem)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
