//
//  SellerProductImages.swift
//
//  Created by Vivek Yadav on 12/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBSellerProductImages: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kSellerProductImagesImageNameKey: String = "imageName"
    private let kSellerProductImagesNameKey: String = "name"
    private let kSellerProductImagesSellerProductIdKey: String = "sellerProductId"

    // MARK: Properties
    public var imageName: String?
    public var name: String?
    public var sellerProductId: Int?

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
        imageName <- map[kSellerProductImagesImageNameKey]
        name <- map[kSellerProductImagesNameKey]
        sellerProductId <- map[kSellerProductImagesSellerProductIdKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = imageName {
            dictionary[kSellerProductImagesImageNameKey] = value
        }
        if let value = name {
            dictionary[kSellerProductImagesNameKey] = value
        }
        if let value = sellerProductId {
            dictionary[kSellerProductImagesSellerProductIdKey] = value
        }
        return dictionary
    }

}
