//
//  Address.swift
//
//  Created by Vivek Yadav on 10/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBAddress: Mappable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kCountryKey: String = "country"
    private let kCityKey: String = "city"
    private let kStateKey: String = "state"

    // MARK: Properties
    public var country: [RBCountry]?
    public var state: [RBState]?
    public var city: [RBCity]?


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
        country <- map[kCountryKey]
        city <- map[kCityKey]
        state <- map[kStateKey]

    }

    /**
     unameeerates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = country { dictionary[kCountryKey] = value.map {
            $0.dictionaryRepresentation()
        }
        }
        if let value = city { dictionary[kCityKey] = value.map {
            $0.dictionaryRepresentation()
        }
        }
        if let value = state { dictionary[kStateKey] = value.map {
            $0.dictionaryRepresentation()
        }
        }

        return dictionary
    }

}
