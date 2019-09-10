//
//  RBSellerProductFetchResponse.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 08/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import ObjectMapper

public class RBSellerProductFetchResponse: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kRBWishListFetchResponseTotalCountKey: String = "totalCount"
    private let kRBWishListFetchResponseSellerProductKey: String = "sellerProduct"

    // MARK: Properties
    public var totalCount: Int?
    public var sellerProduct: [RBSellerProduct]?

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
        sellerProduct <- map[kRBWishListFetchResponseSellerProductKey]
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
        if let value = sellerProduct { dictionary[kRBWishListFetchResponseSellerProductKey] = value.map {
            $0.dictionaryRepresentation()
        }
        }
        return dictionary
    }

}
