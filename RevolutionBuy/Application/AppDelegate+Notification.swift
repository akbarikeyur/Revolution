//
//  AppDelegate+Notification.swift
//  RevolutionBuy
//
//  Created by Arvind Singh on 17/05/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import ObjectMapper

extension AppDelegate {

    struct Keys {
        static let deviceToken = "deviceToken"
    }
  
    // MARK: - UIApplicationDelegate Methods
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        LogManager.logDebug("Device Push Token \(String(describing: String(data: deviceToken, encoding: String.Encoding.utf8)))")
        // Prepare the Device Token for Registration (remove spaces and < >)

        self.setDeviceToken(deviceToken)
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        LogManager.logError(error.localizedDescription)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

        self.convertToJsonString(dict: userInfo)

        if let userInfoDict: NSDictionary = userInfo["aps"] as? NSDictionary {
            self.recievedRemoteNotification(application, userInfo as NSDictionary)
            self.updateUnreadBadgeCountOnActiveApplication(application.applicationState, userInfo: userInfoDict)
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping(UIBackgroundFetchResult) -> Swift.Void) {

        self.convertToJsonString(dict: userInfo)

        if let userInfoDict: NSDictionary = userInfo["aps"] as? NSDictionary {
            self.recievedRemoteNotification(application, userInfo as NSDictionary)
            self.updateUnreadBadgeCountOnActiveApplication(application.applicationState, userInfo: userInfoDict)
        }
    }

    // MARK: - Private Methods
    /**
     Register remote notification to send notifications
     */
    func registerRemoteNotification() {

        let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)

        // This is an asynchronous method to retrieve a Device Token
        // Callbacks are in AppDelegate.swift

        UIApplication.shared.registerForRemoteNotifications()
    }

    /**
     Deregister remote notification
     */
    func deregisterRemoteNotification() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }

    func setDeviceToken(_ token: Data) {
        let deviceToken = token.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.set(deviceToken as AnyObject?, forKey: Keys.deviceToken)
    }

    func deviceToken() -> String {
        let deviceToken: String? = UserDefaults.object(forKey: Keys.deviceToken) as? String

        if isObjectInitialized(deviceToken as AnyObject?) {
            return deviceToken!
        }

        return ""
    }

    /**
     Receive information from remote notification. Parse response.

     - parameter userInfo: Response from server
     */
    func recievedRemoteNotification(_ application: UIApplication, _ userInfo: NSDictionary) {

        //Does user info acquire required dictionary
        guard let dictioaryUserInfo: NSDictionary = userInfo["aps"] as? NSDictionary else {
            return
        }

        //Does user has logged into the application
        guard let userModel: RBUser = RBUserManager.sharedManager().activeUser else {
            return
        }

        //Has user completed profile
        if userModel.hasUserCompletedProfile() == false {
            return
        }

        //Show alert text to user when application is active
        if application.applicationState == UIApplicationState.active, let alertText: String = dictioaryUserInfo["alert"] as? String {
            // get data as per requirement
            RBAlert.showSuccessAlert(message: alertText)
        } else {
            self.extractNotificationInformation(application, dictioaryUserInfo)
        }
    }

    /**
     Receive information from remote notification.
     Update badge outside and inside the application.

     - parameter userInfo: Response from server
     */
    func updateUnreadBadgeCountOnActiveApplication(_ applicationState: UIApplicationState, userInfo: NSDictionary) {

        if let badgeInfo: Int64 = userInfo.value(forKeyPath: "badge") as? Int64, applicationState == UIApplicationState.active {
            self.updateTabBarControllerIcon(unreadCount: Int(badgeInfo))
        }
    }

    private func updateTabBarControllerIcon(unreadCount: Int) {

        if let tabController: RBTabBarController = AppDelegate.delegate().window?.rootViewController as? RBTabBarController {

            LogManager.logDebug("BadgeCount = \(unreadCount)")
            tabController.badgeView.badgeCount = unreadCount

            if tabController.selectedIndex == 2, let notificationController: RBNotificationViewController = tabController.viewControllers?[2] as? RBNotificationViewController {
                notificationController.reloadBtnAction(sender: 0 as AnyObject)
            }
        }
    }

    func convertToJsonString(dict: [AnyHashable: Any]) {
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let jsonString: String = String.init(data: jsonData, encoding: String.Encoding.utf8)!

            LogManager.logDebug("JSON string = \(jsonString)")

        } catch {
            LogManager.logDebug("JSON error = \(error.localizedDescription)")
        }
    }

}

extension AppDelegate {

    /**
     Extract required information from the notification

     - parameter application: Application state
     - parameter userInfo: Response from server
     */
    fileprivate func extractNotificationInformation(_ application: UIApplication, _ notficationInfo: NSDictionary) {

        guard let dataArray: NSArray = notficationInfo["data"] as? NSArray else {
            RBAlert.showWarningAlert(message: "Notification object not found")
            return
        }

        if dataArray.count > 0, let notificationDetailDictionary: [String: Any] = dataArray.firstObject as? [String: Any], let notificationModel: RBNotificationDetail = Mapper<RBNotificationDetail>().map(JSON: notificationDetailDictionary) {
            self.inspectNotificationType(application, notificationModel)
        } else {
            RBAlert.showWarningAlert(message: "Notification object not correct")
        }

    }

    /**
     Detect notification type

     - parameter application: Application state
     - parameter userInfo: Response from server
     */
    fileprivate func inspectNotificationType(_ application: UIApplication, _ notificationDetail: RBNotificationDetail) {

        guard let notificationType: Int = notificationDetail.type else {
            RBAlert.showWarningAlert(message: "Notification type is undefined")
            return
        }

        //Show loader
        self.currentWindow()?.showLoader(subTitle: "Fetching\ndetails")

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
            self.currentWindow()?.hideLoader()
        }
    }

    //MARK: - Private methods to manage notifications -
    private func notificationHandling(offerSentBySeller notificationDetail: RBNotificationDetail) {
        LogManager.logDebug("offerSentBySeller = \(notificationDetail.dictionaryRepresentation())")

        notificationDetail.fetchNotificationDetails(offerSentBySeller: { (status, message, sellerProduct, buyerProduct) in

            //Hide loader
            self.currentWindow()?.hideLoader()

            if status == true {
                self.removeAllClassesFromStackForNotification(offerSentBySeller: true)

                let categoryDetailVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: viewSellerOfferDetailIdentifier) as! RBViewSellerOfferDetailViewController
                categoryDetailVC.wishlistProduct = buyerProduct
                categoryDetailVC.product = sellerProduct
                categoryDetailVC.hidesBottomBarWhenPushed = true
                self.presentNotificationNavigationController(categoryDetailVC)

            } else {
                RBAlert.showWarningAlert(message: message)
            }
        })
    }

    private func removeAllClassesFromStackForNotification(offerSentBySeller shouldRemove: Bool) {

        if let tabBarController: RBTabBarController = self.currentWindow()?.rootViewController as? RBTabBarController, tabBarController.selectedIndex == 1, let navigationController: UINavigationController = tabBarController.viewControllers?[1] as? UINavigationController {

            navigationController.dismiss(animated: false, completion: nil)
            navigationController.popToRootViewController(animated: false)
        }

        //TODO: Update wishlist and product as soon as user notified
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationsIdentifier.kNotificationItemPurchasedByBuyer.rawValue), object: nil, userInfo: wishListItemDict)
    }

    private func notificationHandling(buyerUnlockedDetails notificationDetail: RBNotificationDetail) {
        LogManager.logDebug("buyerUnlockedDetails = \(notificationDetail.dictionaryRepresentation())")

        notificationDetail.fetchNotificationDetails(buyerUnlockedDetails: { (status, message, buyerProduct) in

            //Hide loader
            self.currentWindow()?.hideLoader()

            if status == true {
                self.removeAllClassesFromStackForNotification(buyerUnlockedDetails: true)

                let categoryDetailVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: viewSellerIdentifier) as! RBViewSellerOfferViewController
                categoryDetailVC.product = buyerProduct
                categoryDetailVC.hidesBottomBarWhenPushed = true
                self.presentNotificationNavigationController(categoryDetailVC)

            } else {
                RBAlert.showWarningAlert(message: message)
            }
        })
    }

    private func removeAllClassesFromStackForNotification(buyerUnlockedDetails shouldRemove: Bool) {

        if let tabBarController: RBTabBarController = self.currentWindow()?.rootViewController as? RBTabBarController, tabBarController.selectedIndex == 1, let navigationController: UINavigationController = tabBarController.viewControllers?[1] as? UINavigationController {

            navigationController.dismiss(animated: false, completion: nil)
            navigationController.popToRootViewController(animated: false)
        }

        //TODO: Update wishlist and product as soon as user notified
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationsIdentifier.kNotificationItemPurchasedByBuyer.rawValue), object: nil, userInfo: wishListItemDict)
    }

    private func notificationHandling(buyerMarkedTransactionAsComplete notificationDetail: RBNotificationDetail) {
        LogManager.logDebug("buyerMarkedTransactionAsComplete = \(notificationDetail.dictionaryRepresentation())")

        notificationDetail.fetchNotificationDetails(buyerMarkedTransactionAsComplete: { (status, message, sellerProduct) in

            //Hide loader
            self.currentWindow()?.hideLoader()

            if status == true && sellerProduct != nil {
                self.removeAllClassesFromStackForNotification(buyerMarkedTransactionAsComplete: true)
                let controller: RBSellerItemDetailsVC = RBSellerItemDetailsVC.controllerInstance(with: sellerProduct!)
                controller.hidesBottomBarWhenPushed = true
                self.presentNotificationNavigationController(controller)
            } else {
                RBAlert.showWarningAlert(message: message)
            }
        })
    }

    private func removeAllClassesFromStackForNotification(buyerMarkedTransactionAsComplete shouldRemove: Bool) {

        if let tabBarController: RBTabBarController = self.currentWindow()?.rootViewController as? RBTabBarController, tabBarController.selectedIndex == 0, let navigationController: UINavigationController = tabBarController.viewControllers?[0] as? UINavigationController {

            navigationController.dismiss(animated: false, completion: nil)
            navigationController.popToRootViewController(animated: false)
        }
    }

    private func notificationHandling(productSoldByAnotherSeller notificationDetail: RBNotificationDetail) {
        LogManager.logDebug("productSoldByAnotherSeller = \(notificationDetail.dictionaryRepresentation())")

        notificationDetail.fetchNotificationDetails(productSoldByAnotherSeller: { (status, message, sellerProduct) in

            //Hide loader
            self.currentWindow()?.hideLoader()

            if status == true && sellerProduct != nil {
                self.removeAllClassesFromStackForNotification(productSoldByAnotherSeller: true)
                let controller: RBSellerItemDetailsVC = RBSellerItemDetailsVC.controllerInstance(with: sellerProduct!)
                controller.hidesBottomBarWhenPushed = true
                self.presentNotificationNavigationController(controller)
            } else {
                RBAlert.showWarningAlert(message: message)
            }
        })
    }

    private func removeAllClassesFromStackForNotification(productSoldByAnotherSeller shouldRemove: Bool) {

        if let tabBarController: RBTabBarController = self.currentWindow()?.rootViewController as? RBTabBarController, tabBarController.selectedIndex == 0, let navigationController: UINavigationController = tabBarController.viewControllers?[0] as? UINavigationController {

            navigationController.dismiss(animated: false, completion: nil)
            navigationController.popToRootViewController(animated: false)
        }
    }

    private func notificationHandling(sellerMarkedTransactionAsComplete notificationDetail: RBNotificationDetail) {
        LogManager.logDebug("sellerMarkedTransactionAsComplete = \(notificationDetail.dictionaryRepresentation())")

        notificationDetail.fetchNotificationDetails(sellerMarkedTransactionAsComplete: { (status, message, purchasedProduct) in

            //Hide loader
            self.currentWindow()?.hideLoader()

            if status == true && purchasedProduct != nil {
                self.removeAllClassesFromStackForNotification(sellerMarkedTransactionAsComplete: true)
                let controller: RBPurchasedItemDetailVC = RBPurchasedItemDetailVC.controllerInstance(with: purchasedProduct!)
                controller.hidesBottomBarWhenPushed = true
                self.presentNotificationNavigationController(controller)
            } else {
                RBAlert.showWarningAlert(message: message)
            }
        })
    }

    private func removeAllClassesFromStackForNotification(sellerMarkedTransactionAsComplete shouldRemove: Bool) {

        if let tabBarController: RBTabBarController = self.currentWindow()?.rootViewController as? RBTabBarController, tabBarController.selectedIndex == 1, let navigationController: UINavigationController = tabBarController.viewControllers?[1] as? UINavigationController {

            navigationController.dismiss(animated: false, completion: nil)
            navigationController.popToRootViewController(animated: false)
        }

        //TODO: Update wishlist and product as soon as user notified
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationsIdentifier.kNotificationItemPurchasedByBuyer.rawValue), object: nil, userInfo: wishListItemDict)
    }

    private func currentWindow() -> UIWindow? {

        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        guard let windowCurrent: UIWindow = appDelegate.window else {
            return nil
        }

        return windowCurrent
    }

    private func presentNotificationNavigationController(_ viewController: UIViewController) {
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        self.currentWindow()?.rootViewController?.dismiss(animated: false, completion: nil)
        self.currentWindow()?.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
}
