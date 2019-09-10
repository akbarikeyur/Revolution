//
//  NotificationDetail.swift
//
//  Created by Vivek Yadav on 07/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBNotificationDetail: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kRBNotificationInternalIdentifierKey: String = "id"
    private let kRBNotificationSellerProductIdKey: String = "sellerProductId"
    private let kRBNotificationCreatedAtKey: String = "createdAt"
    private let kRBNotificationBuyerProductIdKey: String = "buyerProductId"
    private let kRBNotificationIsReadKey: String = "isRead"
    private let kRBNotificationDescriptionValueKey: String = "description"
    private let kRBNotificationTypeKey: String = "type"
    private let kRBNotificationTimestampKey: String = "timestamp"

    // MARK: Properties
    public var internalIdentifier: Int?
    public var sellerProductId: Int?
    public var createdAt: RBNotificationTime?
    public var buyerProductId: Int?
    public var isRead: Int?
    public var descriptionValue: String?
    public var type: Int?
    public var timestamp: Int?

    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(map: Map) {
        //Map keys for notification detail
    }

    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        internalIdentifier <- map[kRBNotificationInternalIdentifierKey]
        sellerProductId <- map[kRBNotificationSellerProductIdKey]
        createdAt <- map[kRBNotificationCreatedAtKey]
        buyerProductId <- map[kRBNotificationBuyerProductIdKey]
        isRead <- map[kRBNotificationIsReadKey]
        descriptionValue <- map[kRBNotificationDescriptionValueKey]
        type <- map[kRBNotificationTypeKey]
        timestamp <- map[kRBNotificationTimestampKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = internalIdentifier {
            dictionary[kRBNotificationInternalIdentifierKey] = value
        }
        if let value = sellerProductId {
            dictionary[kRBNotificationSellerProductIdKey] = value
        }
        if let value = createdAt {
            dictionary[kRBNotificationCreatedAtKey] = value.dictionaryRepresentation()
        }
        if let value = buyerProductId {
            dictionary[kRBNotificationBuyerProductIdKey] = value
        }
        if let value = isRead {
            dictionary[kRBNotificationIsReadKey] = value
        }
        if let value = descriptionValue {
            dictionary[kRBNotificationDescriptionValueKey] = value
        }
        if let value = type {
            dictionary[kRBNotificationTypeKey] = value
        }
        if let value = timestamp {
            dictionary[kRBNotificationTimestampKey] = value
        }
        return dictionary
    }

}

extension RBNotificationDetail {

    func hasNotificationRead() -> Bool {
        var hasRead: Bool = false
        if let hasUserRead: Int = self.isRead, hasUserRead > 0 {
            hasRead = true
        }
        return hasRead
    }
}
