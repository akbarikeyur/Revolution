//
//  Notification.swift
//
//  Created by Vivek Yadav on 06/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

extension RBNotificationRecords {

    // MARK: Get list of product
    class func fetchNotification(params: [String: AnyObject], completion: @escaping(_ success: Bool, _ error: Error?, _ data: RBNotificationRecords?, _ message: String) -> (Void)) {

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.notificationListAPI, params: params as [String: AnyObject]?) { (response) -> Void in

            if response.success, let data: RBNotificationRecords = Mapper<RBNotificationRecords>().map(JSON: (response.resultDictionary?.object(forKey: "result") as? [String: Any])!) {
                completion(true, nil, data, RBGenericMethods.serviceResponseMessage(response: response))
            } else {
                completion(false, nil, nil, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }

    // MARK: Get unread notification count
    class func fetchUnreadNotificationCount(completion: @escaping(_ success: Bool, _ error: Error?, _ unreadCount: Int, _ message: String) -> (Void)) {

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.unreadNotificationCountAPI, params: nil) { (response) -> Void in

            LogManager.logDebug("Response = \(response)")

            if response.success, let unreadCount: Int64 = response.resultDictionary?.value(forKeyPath: "result.count") as? Int64 {
                completion(true, nil, Int(unreadCount), RBGenericMethods.serviceResponseMessage(response: response))
            } else {
                completion(false, response.responseError, 0, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }
}
