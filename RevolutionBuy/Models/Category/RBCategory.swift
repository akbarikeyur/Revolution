//
//  RBCategory.swift
//
//  Created by Appster on 31/03/17
//  Copyright (c) Appster. All rights reserved.
//

import Foundation
import ObjectMapper

public class RBCategory: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kRBCategoryImageKey: String = "image"
    private let kRBCategoryTitleKey: String = "title"
    private let kRBCategoryIdKey: String = "catId"
    private let kRBCategoryNotAvailableImageIdKey: String = "ImageOutStock"

    // MARK: Properties
    public var image: String?
    public var title: String?
    public var catId: String!
    public var imageCategoryNotAvailable: String?

    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(map: Map) {
        /**
         Map a JSON object to this class using ObjectMapper
         - parameter map: A mapping from ObjectMapper
         */
    }

    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        image <- map[kRBCategoryImageKey]
        title <- map[kRBCategoryTitleKey]
        catId <- map[kRBCategoryIdKey]
        imageCategoryNotAvailable <- map[kRBCategoryNotAvailableImageIdKey]

    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = image { dictionary[kRBCategoryImageKey] = value }
        if let value = title { dictionary[kRBCategoryTitleKey] = value }
        if let value = catId { dictionary[kRBCategoryIdKey] = value }
        if let value = imageCategoryNotAvailable { dictionary[kRBCategoryNotAvailableImageIdKey] = value }

        return dictionary
    }
}
