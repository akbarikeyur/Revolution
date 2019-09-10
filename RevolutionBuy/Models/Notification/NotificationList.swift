//
//  NotificationList.swift
//
//  Created by Vivek Yadav on 06/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class NotificationList: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kNotificationListNotificationKey: String = "notification"
    private let kNotificationListTotalCountKey: String = "totalCount"

    // MARK: Properties
    public var notification: [Notification]?
    public var totalCount: Int?

    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(map: Map) {
        //Mapping keys
    }

    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        notification <- map[kNotificationListNotificationKey]
        totalCount <- map[kNotificationListTotalCountKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = notification { dictionary[kNotificationListNotificationKey] = value.map {
            $0.dictionaryRepresentation()
        }
        }
        if let value = totalCount {
            dictionary[kNotificationListTotalCountKey] = value
        }
        return dictionary
    }

}
