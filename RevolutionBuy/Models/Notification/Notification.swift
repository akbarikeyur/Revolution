//
//  Notification.swift
//
//  Created by Vivek Yadav on 06/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class Notification: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kNotificationNotificationDetailKey: String = "notification"
    private let kNotificationUserIdKey: String = "userId"
    private let kNotificationInternalIdentifierKey: String = "id"
    private let kNotificationNotificationIdKey: String = "notificationId"

    // MARK: Properties
    public var notificationDetail: NotificationDetail?
    public var userId: Int?
    public var internalIdentifier: Int?
    public var notificationId: Int?

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
        notificationDetail <- map[kNotificationNotificationDetailKey]
        userId <- map[kNotificationUserIdKey]
        internalIdentifier <- map[kNotificationInternalIdentifierKey]
        notificationId <- map[kNotificationNotificationIdKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = notificationDetail {
            dictionary[kNotificationNotificationDetailKey] = value.dictionaryRepresentation()
        }
        if let value = userId {
            dictionary[kNotificationUserIdKey] = value
        }
        if let value = internalIdentifier {
            dictionary[kNotificationInternalIdentifierKey] = value
        }
        if let value = notificationId {
            dictionary[kNotificationNotificationIdKey] = value
        }
        return dictionary
    }

}
