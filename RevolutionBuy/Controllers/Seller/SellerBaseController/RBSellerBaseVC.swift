//
//  RBSellerBaseVC.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSellerBaseVC: UIViewController, RBSellerPageControllerDelegate {

    // MARK: - Varaibales
    var sellerPageViewController: RBSellerPageVC?

    // MARK: - IBOutlets
    @IBOutlet weak var btnSold: UIButton!
    @IBOutlet weak var btnCurrent: UIButton!
    @IBOutlet var centerWithSoldConstraint: NSLayoutConstraint!
    @IBOutlet var centerWithCurrentConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!

    // MARK: -  Class methods
    class func controllerInstance() -> RBSellerBaseVC {
        let controller: RBSellerBaseVC = UIStoryboard.sellerOfferStoryboard().instantiateViewController(withIdentifier: "RBSellerBaseVC") as! RBSellerBaseVC
        return controller
    }

    // MARK: - IBActions
    @IBAction func goBack(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func currentSoldButtonPressed(_ sender: UIButton) {
        // Move scroll only If button is selected
        self.selectHeaderButton(sender) {
            self.scrollpageControllerToIndex(sender.tag)
        }
    }

    // View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(self, selector: #selector(notifyOfferSold(notification:)), name: NSNotification.Name(rawValue: Constants.NotificationsIdentifier.kNotificationItemSoldBySeller.rawValue), object: nil)
    }

    //MARK: - Notification
    func notifyOfferSold(notification: NSNotification) {
        RBSellerTransactionCompletePopupVC.showController(on: self) {
            if let offer = notification.userInfo?[Constants.NotificationsObjectIdentifier.kOfferItem.rawValue] as? RBSellerProduct, let pageController = self.sellerPageViewController {
                pageController.currentController.deleteOfferFromDatasource(offer: offer)
                self.currentSoldButtonPressed(self.btnSold)
                pageController.soldController.refreshSellerSoldProductList()
                _ = self.navigationController?.popToViewController(self, animated: false)
            }
        }
    }

    // MARK: - Other Methods
    private func moveLineToCurrent(_ moveToWish: Bool) {

        self.centerWithCurrentConstraint.isActive = !moveToWish
        self.centerWithSoldConstraint.isActive = moveToWish

        UIView.animate(withDuration: 0.3) {
            self.headerView.layoutIfNeeded()
        }
    }

    private func scrollpageControllerToIndex(_ selectedIndex: Int) {

        if let pageController = self.sellerPageViewController {

            if selectedIndex > pageController.currentPage {
                pageController.goToNextPage(currentPageNumber: pageController.currentPage, nextPageNumber: selectedIndex)
            } else if selectedIndex < pageController.currentPage {
                pageController.goToPreviousPage(currentPageNumber: pageController.currentPage, nextPageNumber: selectedIndex)
            }
        }
    }

    func selectHeaderButton(_ sender: UIButton, completion: (() -> ())?) {
        // Return if already selected
        if sender.isSelected {
            return
        }
        let isCurrentSelected = sender == self.btnCurrent

        self.btnCurrent.isSelected = isCurrentSelected
        self.btnSold.isSelected = !isCurrentSelected
        self.moveLineToCurrent(isCurrentSelected)

        completion?()
    }

    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "SegueToSellerPageViewController", let pageController = segue.destination as? RBSellerPageVC {
            self.sellerPageViewController = pageController
            self.sellerPageViewController?.baseDelegate = self
        }
    }
}
