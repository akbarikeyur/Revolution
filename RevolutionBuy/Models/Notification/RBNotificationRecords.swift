//
//  NotificationList.swift
//
//  Created by Vivek Yadav on 06/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBNotificationRecords: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kRBNotificationDetailNotificationKey: String = "notification"
    private let kRBNotificationDetailTotalCountKey: String = "totalCount"
    private let kRBNotificationDetailTotalUnreadCountKey: String = "totalUnreadCount"

    // MARK: Properties
    public var notification: [RBNotificationDetail]?
    public var totalCount: Int?
    public var totalUnreadCount: Int?

    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(map: Map) {
        //Map keys for notification record
    }

    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        notification <- map[kRBNotificationDetailNotificationKey]
        totalCount <- map[kRBNotificationDetailTotalCountKey]
        totalUnreadCount <- map[kRBNotificationDetailTotalUnreadCountKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = notification {
            dictionary[kRBNotificationDetailNotificationKey] = value.map {
                $0.dictionaryRepresentation()
            }
        }
        if let value = totalCount {
            dictionary[kRBNotificationDetailTotalCountKey] = value
        }
        if let value = totalUnreadCount {
            dictionary[kRBNotificationDetailTotalUnreadCountKey] = value
        }
        return dictionary
    }

}
