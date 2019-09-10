//
//  RBNotificationViewController.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 06/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

extension RBNotificationViewController: UITableViewDelegate, UITableViewDataSource {

    //MARK: - Tableview delegate -
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "RBNotificationTableViewCell", for: indexPath) as! RBNotificationTableViewCell
        cell.configueCell(data: notificationList[indexPath.row])
        return cell
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.notificationList.count > indexPath.row, let notificationType: Int = self.notificationList[indexPath.row].type {

            let notificationDetail: RBNotificationDetail = self.notificationList[indexPath.row]

            //Show Loader
            self.view.showLoader(subTitle: "Fetching\nnotification\ndetails")

            switch notificationType {
            case NotificationIdentifier.notificationType.offerSentBySeller.rawValue:
                self.notificationHandling(offerSentBySeller: notificationDetail)

            case NotificationIdentifier.notificationType.buyerUnlockedDetails.rawValue:
                self.notificationHandling(buyerUnlockedDetails: notificationDetail)

            case NotificationIdentifier.notificationType.buyerMarkedTransactionAsComplete.rawValue:
                self.notificationHandling(buyerMarkedTransactionAsComplete: notificationDetail)

            case NotificationIdentifier.notificationType.productSoldByAnotherSeller.rawValue:
                self.notificationHandling(productSoldByAnotherSeller: notificationDetail)

            case NotificationIdentifier.notificationType.sellerMarkedTransactionAsComplete.rawValue:
                self.notificationHandling(sellerMarkedTransactionAsComplete: notificationDetail)

            default:
                //Hide loader
                self.view.hideLoader()
            }
        }
    }

    //MARK: - Private methods to manage notifications -
    private func notificationHandling(offerSentBySeller notificationDetail: RBNotificationDetail) {
        LogManager.logDebug("offerSentBySeller = \(notificationDetail.dictionaryRepresentation())")

        notificationDetail.fetchNotificationDetails(offerSentBySeller: { (status, message, sellerProduct, buyerProduct) in

            //Hide loader
            self.view.hideLoader()

            if status == true {
                LogManager.logDebug("\(sellerProduct?.dictionaryRepresentation())")
                LogManager.logDebug("\(buyerProduct?.dictionaryRepresentation())")

                let categoryDetailVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: viewSellerOfferDetailIdentifier) as! RBViewSellerOfferDetailViewController
                categoryDetailVC.wishlistProduct = buyerProduct
                categoryDetailVC.product = sellerProduct
                categoryDetailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(categoryDetailVC, animated: true)

            } else {
                RBAlert.showWarningAlert(message: message)
            }
        })
    }

    private func notificationHandling(buyerUnlockedDetails notificationDetail: RBNotificationDetail) {
        LogManager.logDebug("buyerUnlockedDetails = \(notificationDetail.dictionaryRepresentation())")

        notificationDetail.fetchNotificationDetails(buyerUnlockedDetails: { (status, message, buyerProduct) in

            //Hide loader
            self.view.hideLoader()

            if status == true {
                LogManager.logDebug("\(buyerProduct?.dictionaryRepresentation())")

                let categoryDetailVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: viewSellerIdentifier) as! RBViewSellerOfferViewController
                categoryDetailVC.product = buyerProduct
                categoryDetailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(categoryDetailVC, animated: true)
            } else {
                RBAlert.showWarningAlert(message: message)
            }
        })
    }

    private func notificationHandling(buyerMarkedTransactionAsComplete notificationDetail: RBNotificationDetail) {
        LogManager.logDebug("buyerMarkedTransactionAsComplete = \(notificationDetail.dictionaryRepresentation())")

        notificationDetail.fetchNotificationDetails(buyerMarkedTransactionAsComplete: { (status, message, sellerProduct) in

            //Hide loader
            self.view.hideLoader()

            if status == true && sellerProduct != nil {
                let controller: RBSellerItemDetailsVC = RBSellerItemDetailsVC.controllerInstance(with: sellerProduct!)
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                RBAlert.showWarningAlert(message: message)
            }
        })
    }

    private func notificationHandling(productSoldByAnotherSeller notificationDetail: RBNotificationDetail) {
        LogManager.logDebug("productSoldByAnotherSeller = \(notificationDetail.dictionaryRepresentation())")

        notificationDetail.fetchNotificationDetails(productSoldByAnotherSeller: { (status, message, sellerProduct) in

            //Hide loader
            self.view.hideLoader()

            if status == true && sellerProduct != nil {
                let controller: RBSellerItemDetailsVC = RBSellerItemDetailsVC.controllerInstance(with: sellerProduct!)
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                RBAlert.showWarningAlert(message: message)
            }
        })
    }

    private func notificationHandling(sellerMarkedTransactionAsComplete notificationDetail: RBNotificationDetail) {
        LogManager.logDebug("sellerMarkedTransactionAsComplete = \(notificationDetail.dictionaryRepresentation())")

        notificationDetail.fetchNotificationDetails(sellerMarkedTransactionAsComplete: { (status, message, purchasedProduct) in

            //Hide loader
            self.view.hideLoader()

            if status == true && purchasedProduct != nil {
                let controller: RBPurchasedItemDetailVC = RBPurchasedItemDetailVC.controllerInstance(with: purchasedProduct!)
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                RBAlert.showWarningAlert(message: message)
            }
        })
    }

    private func markThisNotifictionAsUnread(notificationDetail: RBNotificationDetail) {

        var notificationDetailInfo: RBNotificationDetail = notificationDetail

        if let readStatus: Int = notificationDetailInfo.isRead, readStatus == 0 {
            notificationDetailInfo.isRead = 1
        }

        if let theIndex: Int = self.notificationList.index(where: { $0.internalIdentifier == notificationDetailInfo.internalIdentifier }) {
            self.notificationList[theIndex] = notificationDetailInfo
            self.tableViewNotification.reloadData()
        }
    }
}
