//
//  NotificationDetail.swift
//
//  Created by Vivek Yadav on 07/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class NotificationDetail: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kNotificationDetailDescriptionValueKey: String = "description"
    private let kNotificationDetailNotificationKey: String = "notification"
    private let kNotificationDetailTitleKey: String = "title"
    private let kNotificationDetailNotificationTimeKey: String = "createdAt"
    private let kNotificationDetailTimestampKey: String = "timestamp"

    // MARK: Properties
    public var descriptionValue: String?
    public var notification: String?
    public var title: String?
    public var notificationTime: NotificationTime?
    public var timestamp: Int?

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
        timestamp <- map[kNotificationDetailTimestampKey]
        descriptionValue <- map[kNotificationDetailDescriptionValueKey]
        notification <- map[kNotificationDetailNotificationKey]
        title <- map[kNotificationDetailTitleKey]
        notificationTime <- map[kNotificationDetailNotificationTimeKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = descriptionValue {
            dictionary[kNotificationDetailDescriptionValueKey] = value
        }
        if let value = notification {
            dictionary[kNotificationDetailNotificationKey] = value
        }
        if let value = title {
            dictionary[kNotificationDetailTitleKey] = value
        }
        if let value = notificationTime {
            dictionary[kNotificationDetailNotificationTimeKey] = value.dictionaryRepresentation()
        }
        if let value = timestamp {
            dictionary[kNotificationDetailTimestampKey] = value
        }

        return dictionary
    }

}
