//
//  AppDelegate+Deeplink.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 17/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension AppDelegate {

    func openProductWith(url: URL) {
        let deepLinkAbsUrl = Constants.kDeepLinkUrl.lowercased()
        let itemID = url.absoluteString.lowercased().replace(deepLinkAbsUrl, replacementString: "")
        if Int(itemID) != nil {
            // Necessary step - setTabBarAtRoot
            self.setTabBarAtRoot()
            self.loadProductDetail(itemID: itemID)
        } else {
            RBAlert.showWarningAlert(message: "Item not found")
        }
    }

    //MARK: - Private methods
    private func setTabBarAtRoot() {
        //If profile not completed, log in as guest user
        if  let userModel: RBUser = RBUserManager.sharedManager().activeUser, userModel.hasUserCompletedProfile() == false {
            RBUserManager.sharedManager().setGuestUser()
        } else if !RBUserManager.sharedManager().isUserLoggedIn() {
            RBUserManager.sharedManager().setGuestUser()
        }
        AppDelegate.presentRootViewController()
    }

    private func loadProductDetail(itemID: String) {
        self.window?.showLoader(subTitle: "Fetching Details")
        RBProduct.fetchProductsDetail(productId: itemID, completion: { (product, message) in
            self.window?.hideLoader()

            guard let theProduct = product else {
                self.showItemNotFoundErrorAlert(message: message)
                return
            }
            self.navigateToProductDetailScreen(product: theProduct)
        })
    }

    private func showItemNotFoundErrorAlert(message: String) {
        var theMessage = "Item details not found"
        if message.length > 0 {
            theMessage = message
        }
        RBAlert.showWarningAlert(message: theMessage)
    }

    private func navigateToProductDetailScreen(product: RBProduct) {

        guard let tabBar: RBTabBarController = self.window?.rootViewController as? RBTabBarController, let navigationController = tabBar.selectedViewController as? UINavigationController, let rootController: UIViewController = navigationController.visibleViewController else {
            RBAlert.showWarningAlert(message: "Unable to navigate to detail")
            return
        }

        var myUserId: Int = -1
        // get user id to compare
        if let userModel: RBUser = RBUserManager.sharedManager().activeUser, let loggedInUserId = userModel.internalIdentifier {
            myUserId = loggedInUserId
        }

        // check if my product or not
        if let buyerId = product.user?.internalIdentifier, buyerId == myUserId {
            // My Product
            rootController.pushToWishListDetailScreen(item: product, itemIndex: 0, wishlistController: nil)
        } else {
            rootController.pushToItemDetail(productDetail: product)
        }
    }
}
