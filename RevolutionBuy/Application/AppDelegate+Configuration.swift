//
//  AppDelegate+Configuration.swift
//  RevolutionBuy
//
//  Created by Arvind Singh on 14/05/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

extension AppDelegate {

    /**
     Configures Facebook
     */
    class func configureFacebook() {
        let appId = ConfigurationManager.sharedManager().facebookAppId()
        var permissionsArray: [String]
        if let token = FacebookManager.token() {
            permissionsArray = (token.permissions as NSSet).allObjects as! [String]
        } else {
            permissionsArray = [FacebookConfiguration.Permissions.PublicProfile, FacebookConfiguration.Permissions.Email]
        }
        FacebookManager.managerWithConfiguration(FacebookConfiguration(client_ID: appId, scope: permissionsArray))
    }

    /**
     Device token
     */
    class func configureDeviceToken() {
        // Update device token
        if RBUserManager.sharedManager().isUserLoggedIn() && AppDelegate.delegate().deviceToken().characters.count > 0 {
            RBUser.updateDeviceToken(deviceToken: AppDelegate.delegate().deviceToken()) { (success, error) -> (Void) in
                if success {
                    LogManager.logDebug("Updated device token")
                }
            }
        }
    }

    /**
     Get unread notfication count
     */
    class func fetchUnreadNotificationCount() {
        // Update latest unread notification count
        if let activeUser: RBUser = RBUserManager.sharedManager().activeUser, activeUser.hasUserCompletedProfile() == true  {

            RBNotificationRecords.fetchUnreadNotificationCount(completion: { (status, error, unreadCount, message) -> (Void) in
                if status == true, let tabController: RBTabBarController = AppDelegate.delegate().window?.rootViewController as? RBTabBarController {
                    tabController.badgeView.badgeCount = unreadCount
                    UIApplication.shared.applicationIconBadgeNumber = unreadCount
                }
            })

            // Update device token
            self.configureDeviceToken()
        }
    }

    /**
     Configure Analytics Operations
     */
    class func configureAnalyticsOperations() {

        //Initialize tracking
        AnalyticsManager.initializeTracker()

        //Check profile completion
        if let activeUser: RBUser = RBUserManager.sharedManager().activeUser, activeUser.hasUserCompletedProfile() == true  {
            AnalyticsManager.setDistictUser(user: activeUser)
        } else {
            AnalyticsManager.setDistictUser(user: nil)
        }
    }

}
