//
//  RBBuyerBaseVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 27/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBBuyerBaseVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var purchasedButton: UIButton!
    @IBOutlet weak var wishlistButton: UIButton!

    @IBOutlet var centerWithPurchasedConstraint: NSLayoutConstraint!
    @IBOutlet var centerWithWishlistConstraint: NSLayoutConstraint!

    @IBOutlet weak var headerView: UIView!

    //MARK: - Variables
    var buyerPageViewController: RBBuyerPageViewController?

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(notifyItemPurchase(notification:)), name: NSNotification.Name(rawValue: Constants.NotificationsIdentifier.kNotificationItemPurchasedByBuyer.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyItemPurchaseViaPushNotification(notification:)), name: NSNotification.Name(rawValue: Constants.NotificationsIdentifier.kNotificationItemSoldByBuyerPushNotified.rawValue), object: nil)
    }

    //MARK: - Notification
    func notifyItemPurchase(notification: NSNotification) {
        RBBuyerTransactionCompletePopupVC.showController(on: self) {
            if let wishListItem = notification.userInfo?[Constants.NotificationsObjectIdentifier.kWishlistItem.rawValue] as? RBProduct, let pageController = self.buyerPageViewController {
                pageController.wishListController.deleteItem(item: wishListItem, completion: { (deleted) in
                    self.clickWishlistPurchased(self.purchasedButton)
                    pageController.purchasedController.refreshPurchasedList()
                })
                _ = self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }

    //MARK: - Push notification update buyer models
    func notifyItemPurchaseViaPushNotification(notification: NSNotification) {
        if let wishListItem = notification.userInfo?[Constants.NotificationsObjectIdentifier.kWishlistItem.rawValue] as? RBProduct, let pageController = self.buyerPageViewController {
            pageController.wishListController.deleteItem(item: wishListItem, completion: { (deleted) in
                self.clickWishlistPurchased(self.purchasedButton)
                pageController.purchasedController.refreshPurchasedList()
            })
            _ = self.navigationController?.popToRootViewController(animated: false)
        }
    }

    //MARK: - Clicks
    @IBAction func clickWishlistPurchased(_ sender: UIButton) {

        // Move scroll only If button is selected
        self.selectHeaderButton(sender) {
            self.scrollpageControllerToIndex(sender.tag)
        }
    }

    //MARK: - Methods
    private func moveLineToWishList(_ moveToWish: Bool) {

        self.centerWithWishlistConstraint.isActive = moveToWish
        self.centerWithPurchasedConstraint.isActive = !moveToWish

        UIView.animate(withDuration: 0.3) {
            self.headerView.layoutIfNeeded()
        }
    }

    private func scrollpageControllerToIndex(_ selectedIndex: Int) {

        if let pageController = self.buyerPageViewController {

            if selectedIndex > pageController.currentPage {
                pageController.goToNextPage(crntPageNumber: pageController.currentPage, nxtPageNumber: selectedIndex)
            } else if selectedIndex < pageController.currentPage {
                pageController.goToPreviousPage(crntPageNumber: pageController.currentPage, nxtPageNumber: selectedIndex)
            }
        }
    }

    func selectHeaderButton(_ sender: UIButton, completion: (() -> ())?) {
        // Return if already selected
        if sender.isSelected {
            return
        }

        let isWishListSelected = sender == self.wishlistButton
        self.wishlistButton.isSelected = isWishListSelected
        self.purchasedButton.isSelected = !isWishListSelected
        self.moveLineToWishList(isWishListSelected)

        completion?()
    }

    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "SegueToBuyerPageViewController", let pageController = segue.destination as? RBBuyerPageViewController {
            self.buyerPageViewController = pageController
            self.buyerPageViewController?.baseDelegate = self
        }
    }
}
