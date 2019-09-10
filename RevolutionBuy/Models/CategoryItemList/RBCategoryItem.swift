//
//  Category.swift
//
//  Created by Vivek Yadav on 05/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBCategoryItem: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kCategoryNameKey: String = "name"

    // MARK: Properties
    public var name: String?

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
        name <- map[kCategoryNameKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name {
            dictionary[kCategoryNameKey] = value
        }
        return dictionary
    }

    func catName() -> String {
        if let nameStr: String = self.name {
            return nameStr
        }
        return ""
    }
}
