//
//  Notification.swift
//
//  Created by Vivek Yadav on 06/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

extension NotificationList {

    // MARK: Get list of product
    class func fetchNotification(params: [String: AnyObject], completion: @escaping(_ success: Bool, _ error: Error?, _ data: NotificationList?, _ message: String) -> (Void)) {

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.notificationListAPI, params: params as [String: AnyObject]?) { (response) -> Void in

            print(response.success)

            if response.success, let data: NotificationList = Mapper<NotificationList>().map(JSON: (response.resultDictionary?.object(forKey: "result") as? [String: Any])!) {
                completion(true, nil, data, RBGenericMethods.serviceResponseMessage(response: response))
            } else {
                completion(false, nil, nil, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }
}
