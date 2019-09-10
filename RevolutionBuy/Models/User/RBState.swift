//
//  State.swift
//
//  Created by Sandeep Kumar on 04/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBState: NSObject, Mappable, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kStateNameKey: String = "name"
    private let kStateInternalIdentifierKey: String = "id"
    private let kStateCountryIdKey: String = "countryId"
    private let kStateCountryKey: String = "country"

    // MARK: Properties
    public var name: String?
    public var internalIdentifier: Int?
    public var countryId: Int?
    public var country: RBCountry?

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
        name <- map[kStateNameKey]
        internalIdentifier <- map[kStateInternalIdentifierKey]
        countryId <- map[kStateCountryIdKey]
        country <- map[kStateCountryKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = name {
            dictionary[kStateNameKey] = value
        }
        if let value = internalIdentifier {
            dictionary[kStateInternalIdentifierKey] = value
        }
        if let value = countryId {
            dictionary[kStateCountryIdKey] = value
        }
        if let value = country {
            dictionary[kStateCountryKey] = value.dictionaryRepresentation()
        }
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: kStateNameKey) as? String
        self.internalIdentifier = aDecoder.decodeObject(forKey: kStateInternalIdentifierKey) as? Int
        self.countryId = aDecoder.decodeObject(forKey: kStateCountryIdKey) as? Int
        self.country = aDecoder.decodeObject(forKey: kStateCountryKey) as? RBCountry
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: kStateNameKey)
        aCoder.encode(internalIdentifier, forKey: kStateInternalIdentifierKey)
        aCoder.encode(countryId, forKey: kStateCountryIdKey)
        aCoder.encode(country, forKey: kStateCountryKey)
    }

}

extension RBState {

    //State id
    func stateId() -> String {
        var stateString: String = ""
        if let stateID: Int = self.internalIdentifier {
            stateString = "\(stateID)"
        }
        return stateString
    }

    //Full state name
    func stateName() -> String {
        var stateName: String = ""
        if let nameText: String = self.name {
            stateName = nameText
        }
        return stateName
    }
}
