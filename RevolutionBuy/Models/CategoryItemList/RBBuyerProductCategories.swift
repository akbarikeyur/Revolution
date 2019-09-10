//
//  BuyerProductCategories.swift
//
//  Created by Vivek Yadav on 05/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBBuyerProductCategories: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kBuyerProductCategoriesCategoryIdKey: String = "categoryId"
    private let kBuyerProductCategoriesCategoryKey: String = "category"
    private let kBuyerProductCategoriesBuyerProductIdKey: String = "buyerProductId"

    // MARK: Properties
    public var categoryId: Int?
    public var category: RBCategoryItem?
    public var buyerProductId: Int?

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
        categoryId <- map[kBuyerProductCategoriesCategoryIdKey]
        category <- map[kBuyerProductCategoriesCategoryKey]
        buyerProductId <- map[kBuyerProductCategoriesBuyerProductIdKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = categoryId {
            dictionary[kBuyerProductCategoriesCategoryIdKey] = value
        }
        if let value = category {
            dictionary[kBuyerProductCategoriesCategoryKey] = value.dictionaryRepresentation()
        }
        if let value = buyerProductId {
            dictionary[kBuyerProductCategoriesBuyerProductIdKey] = value
        }
        return dictionary
    }
}
