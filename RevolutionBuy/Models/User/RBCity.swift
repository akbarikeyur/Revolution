//
//  City.swift
//
//  Created by Sandeep Kumar on 04/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBCity: NSObject, Mappable, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kCityStateIdKey: String = "stateId"
    private let kCityStateKey: String = "state"
    private let kCityNameKey: String = "name"
    private let kCityInternalIdentifierKey: String = "id"

    // MARK: Properties
    public var stateId: Int?
    public var state: RBState?
    public var name: String?
    public var internalIdentifier: Int?

    // MARK: ObjectMapper Initalizers
    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    required public init?(map p: Map) {
        //Mapping keys
    }

    /**
     Map a JSON object to this class using ObjectMapper
     - parameter map: A mapping from ObjectMapper
     */
    public func mapping(map: Map) {
        stateId <- map[kCityStateIdKey]
        state <- map[kCityStateKey]
        name <- map[kCityNameKey]
        internalIdentifier <- map[kCityInternalIdentifierKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = stateId {
            dictionary[kCityStateIdKey] = value
        }
        if let value = state {
            dictionary[kCityStateKey] = value.dictionaryRepresentation()
        }
        if let value = name {
            dictionary[kCityNameKey] = value
        }
        if let value = internalIdentifier {
            dictionary[kCityInternalIdentifierKey] = value
        }
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.stateId = aDecoder.decodeObject(forKey: kCityStateIdKey) as? Int
        self.state = aDecoder.decodeObject(forKey: kCityStateKey) as? RBState
        self.name = aDecoder.decodeObject(forKey: kCityNameKey) as? String
        self.internalIdentifier = aDecoder.decodeObject(forKey: kCityInternalIdentifierKey) as? Int
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(stateId, forKey: kCityStateIdKey)
        aCoder.encode(state, forKey: kCityStateKey)
        aCoder.encode(name, forKey: kCityNameKey)
        aCoder.encode(internalIdentifier, forKey: kCityInternalIdentifierKey)
    }

}

extension RBCity {

    //Full city id
    func cityId() -> String {
        var cityString: String = ""
        if let cityID: Int = self.internalIdentifier {
            cityString = "\(cityID)"
        }
        return cityString
    }

    //Full city name
    func cityName() -> String {
        var cityName: String = ""
        if let nameText: String = self.name {
            cityName = nameText
        }
        return cityName
    }

}
