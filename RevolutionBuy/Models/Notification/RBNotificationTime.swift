//
//  NotificationTime.swift
//
//  Created by Vivek Yadav on 07/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBNotificationTime: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kRBCreatedAtDateKey: String = "date"
    private let kRBCreatedAtTimezoneTypeKey: String = "timezoneType"
    private let kRBCreatedAtTimezoneKey: String = "timezone"

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
        //Map keys for notification time
    }

    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        date <- map[kRBCreatedAtDateKey]
        timezoneType <- map[kRBCreatedAtTimezoneTypeKey]
        timezone <- map[kRBCreatedAtTimezoneKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = date {
            dictionary[kRBCreatedAtDateKey] = value
        }
        if let value = timezoneType {
            dictionary[kRBCreatedAtTimezoneTypeKey] = value
        }
        if let value = timezone {
            dictionary[kRBCreatedAtTimezoneKey] = value
        }
        return dictionary
    }

}
