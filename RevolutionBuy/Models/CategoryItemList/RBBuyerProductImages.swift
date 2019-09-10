//
//  BuyerProductImages.swift
//
//  Created by Vivek Yadav on 03/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBBuyerProductImages: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kBuyerProductImagesImageNameKey: String = "imageName"
    private let kBuyerProductImagesNameKey: String = "name"
    private let kBuyerProductImagesBuyerProductIdKey: String = "buyerProductId"
    private let kBuyerProductImagesInternalIdentifierKey: String = "id"
    private let kBuyerProductImagesPrimaryKeyKey: String = "primaryImage"

    // MARK: Properties
    public var imageName: String?
    public var name: String?
    public var buyerProductId: Int?
    public var internalIdentifier: Int?
    public var isPrimaryImage: Bool = false

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
        imageName <- map[kBuyerProductImagesImageNameKey]
        name <- map[kBuyerProductImagesNameKey]
        buyerProductId <- map[kBuyerProductImagesBuyerProductIdKey]
        internalIdentifier <- map[kBuyerProductImagesInternalIdentifierKey]
        isPrimaryImage <- map[kBuyerProductImagesPrimaryKeyKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = imageName {
            dictionary[kBuyerProductImagesImageNameKey] = value
        }
        if let value = name {
            dictionary[kBuyerProductImagesNameKey] = value
        }
        if let value = buyerProductId {
            dictionary[kBuyerProductImagesBuyerProductIdKey] = value
        }
        if let value = internalIdentifier {
            dictionary[kBuyerProductImagesInternalIdentifierKey] = value
        }
        dictionary[kBuyerProductImagesPrimaryKeyKey] = Int(NSNumber(value: isPrimaryImage))
        return dictionary
    }

}
