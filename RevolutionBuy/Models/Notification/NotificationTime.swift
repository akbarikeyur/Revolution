//
//  NotificationTime.swift
//
//  Created by Vivek Yadav on 07/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class NotificationTime: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kNotificationTimeDateKey: String = "date"
    private let kNotificationTimeTimezoneTypeKey: String = "timezoneType"
    private let kNotificationTimeTimezoneKey: String = "timezone"

    // MARK: Properties
    public var date: String?
    public var timezoneType: Int?
    public var timezone: String?

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
        date <- map[kNotificationTimeDateKey]
        timezoneType <- map[kNotificationTimeTimezoneTypeKey]
        timezone <- map[kNotificationTimeTimezoneKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = date {
            dictionary[kNotificationTimeDateKey] = value
        }
        if let value = timezoneType {
            dictionary[kNotificationTimeTimezoneTypeKey] = value
        }
        if let value = timezone {
            dictionary[kNotificationTimeTimezoneKey] = value
        }
        return dictionary
    }

}
