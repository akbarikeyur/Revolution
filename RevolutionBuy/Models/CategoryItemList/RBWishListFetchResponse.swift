//
//  RBWishListFetchResponse.swift
//
//  Created by Pankaj Pal on 12/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBWishListFetchResponse: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kRBWishListFetchResponseTotalCountKey: String = "totalCount"
    private let kRBWishListFetchResponseBuyerProductKey: String = "buyerProduct"

    // MARK: Properties
    public var totalCount: Int?
    public var buyerProduct: [RBProduct]?

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
        totalCount <- map[kRBWishListFetchResponseTotalCountKey]
        buyerProduct <- map[kRBWishListFetchResponseBuyerProductKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = totalCount {
            dictionary[kRBWishListFetchResponseTotalCountKey] = value
        }
        if let value = buyerProduct { dictionary[kRBWishListFetchResponseBuyerProductKey] = value.map {
            $0.dictionaryRepresentation()
        }
        }
        return dictionary
    }

}
