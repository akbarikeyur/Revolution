//
//  SellerOfferList.swift
//
//  Created by Vivek Yadav on 12/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBSellerOfferRecords: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kSellerOfferListSellerProductKey: String = "sellerProduct"

    // MARK: Properties
    public var sellerProduct: [RBSellerProduct]?

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
        sellerProduct <- map[kSellerOfferListSellerProductKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = sellerProduct { dictionary[kSellerOfferListSellerProductKey] = value.map {
            $0.dictionaryRepresentation()
        }
        }
        return dictionary
    }

}
