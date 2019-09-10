//
//  Country.swift
//
//  Created by Sandeep Kumar on 04/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBCountry: NSObject, Mappable, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kCountryInternalIdentifierKey: String = "id"
    private let kCountryNameKey: String = "name"
    private let kPhoneCodeNameKey: String = "phoneCode"

    // MARK: Properties
    public var internalIdentifier: Int?
    public var name: String?
    public var phoneCode: String?

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
        internalIdentifier <- map[kCountryInternalIdentifierKey]
        name <- map[kCountryNameKey]
        phoneCode <- map[kPhoneCodeNameKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = internalIdentifier {
            dictionary[kCountryInternalIdentifierKey] = value
        }
        if let value = name {
            dictionary[kCountryNameKey] = value
        }
        if let value = phoneCode {
            dictionary[kPhoneCodeNameKey] = value
        }
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.internalIdentifier = aDecoder.decodeObject(forKey: kCountryInternalIdentifierKey) as? Int
        self.name = aDecoder.decodeObject(forKey: kCountryNameKey) as? String
        self.phoneCode = aDecoder.decodeObject(forKey: kPhoneCodeNameKey) as? String
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(internalIdentifier, forKey: kCountryInternalIdentifierKey)
        aCoder.encode(name, forKey: kCountryNameKey)
        aCoder.encode(phoneCode, forKey: kPhoneCodeNameKey)
    }

}

extension RBCountry {

    //Country id
    func countryId() -> String {
        var countryString: String = ""
        if let countryID: Int = self.internalIdentifier {
            countryString = "\(countryID)"
        }
        return countryString
    }

    //Full country name
    func countryName() -> String {
        var countryName: String = ""
        if let nameText: String = self.name {
            countryName = nameText
        }
        return countryName
    }

    //Full country code
    func countryCodeName() -> String {
        var countryPhoneNumber: String = ""
        if let phoneText: String = self.phoneCode {
            countryPhoneNumber = phoneText
        }
        return countryPhoneNumber
    }
}
