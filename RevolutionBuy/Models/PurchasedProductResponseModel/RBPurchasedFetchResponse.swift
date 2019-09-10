//
//  RBWishListFetchResponse.swift
//
//  Created by Pankaj Pal on 21/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBPurchasedFetchResponse: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kRBPurchasedFetchResponseTotalCountKey: String = "totalCount"
    private let kRBPurchasedFetchResponseBuyerProductKey: String = "buyerProduct"

    // MARK: Properties
    public var totalCount: Int?
    public var buyerProduct: [RBPurchasedProduct]?

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
        totalCount <- map[kRBPurchasedFetchResponseTotalCountKey]
        buyerProduct <- map[kRBPurchasedFetchResponseBuyerProductKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = totalCount { dictionary[kRBPurchasedFetchResponseTotalCountKey] = value }
        if let value = buyerProduct { dictionary[kRBPurchasedFetchResponseBuyerProductKey] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }

}
