//
//  CategoryItemList.swift
//
//  Created by Vivek Yadav on 03/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBCategoryItemRecords: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kCategoryItemListProductKey: String = "product"
    private let kTotalCount: String = "totalCount"

    // MARK: Properties
    public var product: [RBProduct]?
    public var totalCount: Int?

    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(map: Map) {
        // MARK: ObjectMapper Initalizers
    }

    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        product <- map[kCategoryItemListProductKey]
        totalCount <- map[kTotalCount]

    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = product {
            dictionary[kCategoryItemListProductKey] = value.map {
                $0.dictionaryRepresentation()
            }
        }
        if let value = totalCount {
            dictionary[kTotalCount] = value
        }

        return dictionary
    }

}
