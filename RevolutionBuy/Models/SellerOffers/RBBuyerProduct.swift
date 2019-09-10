//
//  BuyerProduct.swift
//
//  Created by Vivek Yadav on 13/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBBuyerProduct: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kBuyerProductTitleKey: String = "title"
    private let kBuyerProductBuyerProductCategoriesKey: String = "buyerProductCategories"
    private let kBuyerProductInternalIdentifierKey: String = "id"
    private let kBuyerProductUserIdKey: String = "userId"
    private let kBuyerProductProductTypeTextKey: String = "productTypeText"
    private let kBuyerProductUserKey: String = "user"

    // MARK: Properties
    public var title: String?
    public var buyerProductCategories: [RBBuyerProductCategories]?
    public var internalIdentifier: Int?
    public var userId: Int?
    public var productTypeText: String?
    public var user: RBUser?

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
        title <- map[kBuyerProductTitleKey]
        buyerProductCategories <- map[kBuyerProductBuyerProductCategoriesKey]
        internalIdentifier <- map[kBuyerProductInternalIdentifierKey]
        userId <- map[kBuyerProductUserIdKey]
        productTypeText <- map[kBuyerProductProductTypeTextKey]
        user <- map[kBuyerProductUserKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = title {
            dictionary[kBuyerProductTitleKey] = value
        }
        if let value = buyerProductCategories { dictionary[kBuyerProductBuyerProductCategoriesKey] = value.map {
            $0.dictionaryRepresentation()
        }
        }
        if let value = internalIdentifier {
            dictionary[kBuyerProductInternalIdentifierKey] = value
        }
        if let value = userId {
            dictionary[kBuyerProductUserIdKey] = value
        }
        if let value = productTypeText {
            dictionary[kBuyerProductProductTypeTextKey] = value
        }
        if let value = user {
            dictionary[kBuyerProductUserKey] = value.dictionaryRepresentation()
        }
        return dictionary
    }

}

extension RBBuyerProduct {

    func categories() -> String {
        if let arrCat = self.buyerProductCategories {
            return RBGenericMethods.fetchCategoriesName(arrCat: arrCat)
        }
        return ""
    }
}
