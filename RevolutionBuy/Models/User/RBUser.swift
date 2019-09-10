//
//  User.swift
//
//  Created by Sandeep Kumar on 04/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public class RBUser: NSObject, Mappable, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kUserCityKey: String = "city"
    private let kUserNameKey: String = "name"
    private let kUserEmailKey: String = "email"
    private let kUserMobileKey: String = "mobile"
    private let kUserLoginTypeKey: String = "loginType"
    private let kUserAgeKey: String = "age"
    private let kUserIsMobileVerifiedKey: String = "isMobileVerified"
    private let kUserStatusKey: String = "status"
    private let kUserInternalIdentifierKey: String = "id"
    private let kUserFbIdKey: String = "fbId"
    private let kUserImageKey: String = "image"
    private let kUserImageNameKey: String = "imageName"
    private let kUserIsProfileCompleteKey: String = "isProfileComplete"
    private let kUserTokenKey: String = "token"
    private let kUserSellerProductsKey: String = "sellerProducts"
    private let kUserBuyerProductsKey: String = "buyerProducts"
    private let kUserIsTempPassword: String = "isTempPassword"
    private let kUserIsSellerAccConnected: String = "isSellerAccConnected"
    private let kUserSoldCountKey: String = "soldCount"
    private let kUserPurchaseCountKey: String = "purchasedCount"
    
    private let kUserFbCityKey: String = "FbCity"
    private let kUserFbCountryKey: String = "FbCountry"

    // MARK: Properties
    public var city: RBCity?
    public var name: String?
    public var email: String?
    public var mobile: String?
    public var loginType: Int?
    public var age: Int?
    public var isMobileVerified: Int?
    public var status: Int?
    public var internalIdentifier: Int?
    public var fbId: String?
    public var image: String?
    public var imageName: String?
    public var isProfileComplete: Int?
    public var accessToken: String?
    public var isTempPassword: Int?
    public var isSellerAccConnected: Int?
    public var soldCount: Int?
    public var purchaseCount: Int?
    
    public var fbCityKey: String?
    public var fbCountryKey: String?
    
    
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
        city <- map[kUserCityKey]
        name <- map[kUserNameKey]
        email <- map[kUserEmailKey]
        mobile <- map[kUserMobileKey]
        loginType <- map[kUserLoginTypeKey]
        age <- map[kUserAgeKey]
        isMobileVerified <- map[kUserIsMobileVerifiedKey]
        status <- map[kUserStatusKey]
        internalIdentifier <- map[kUserInternalIdentifierKey]
        fbId <- map[kUserFbIdKey]
        image <- map[kUserImageKey]
        imageName <- map[kUserImageNameKey]
        isProfileComplete <- map[kUserIsProfileCompleteKey]
        accessToken <- map[kUserTokenKey]
        isTempPassword <- map[kUserIsTempPassword]
        isSellerAccConnected <- map[kUserIsSellerAccConnected]
        soldCount <- map[kUserSoldCountKey]
        purchaseCount <- map[kUserPurchaseCountKey]
        
        fbCityKey <- map[kUserFbCityKey]
        fbCountryKey <- map[kUserFbCountryKey]
    }

    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = self.addDictionaryRepresentation()
        if let value = name { dictionary[kUserNameKey] = value }
        if let value = email { dictionary[kUserEmailKey] = value }
        if let value = mobile { dictionary[kUserMobileKey] = value }
        if let value = loginType { dictionary[kUserLoginTypeKey] = value }
        if let value = age { dictionary[kUserAgeKey] = value }
        if let value = isMobileVerified { dictionary[kUserIsMobileVerifiedKey] = value }
        if let value = status { dictionary[kUserStatusKey] = value }
        if let value = purchaseCount { dictionary[kUserPurchaseCountKey] = value }
        if let value = soldCount { dictionary[kUserSoldCountKey] = value }
        
        if let value = fbCityKey { dictionary[kUserFbCityKey] = value }
        if let value = fbCountryKey { dictionary[kUserFbCountryKey] = value }
        
        return dictionary
    }

    private func addDictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = internalIdentifier { dictionary[kUserInternalIdentifierKey] = value }
        if let value = fbId { dictionary[kUserFbIdKey] = value }
        if let value = image { dictionary[kUserImageKey] = value }
        if let value = imageName { dictionary[kUserImageNameKey] = value }
        if let value = isProfileComplete { dictionary[kUserIsProfileCompleteKey] = value }
        if let value = accessToken { dictionary[kUserTokenKey] = value }
        if let value = isTempPassword { dictionary[kUserIsTempPassword] = value }
        if let value = isSellerAccConnected { dictionary[kUserIsSellerAccConnected] = value }
        if let value = city { dictionary[kUserCityKey] = value.dictionaryRepresentation() }
        
        
        
        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.city = aDecoder.decodeObject(forKey: kUserCityKey) as? RBCity
        self.name = aDecoder.decodeObject(forKey: kUserNameKey) as? String
        self.email = aDecoder.decodeObject(forKey: kUserEmailKey) as? String
        self.mobile = aDecoder.decodeObject(forKey: kUserMobileKey) as? String
        self.loginType = aDecoder.decodeObject(forKey: kUserLoginTypeKey) as? Int
        self.age = aDecoder.decodeObject(forKey: kUserAgeKey) as? Int
        self.isMobileVerified = aDecoder.decodeObject(forKey: kUserIsMobileVerifiedKey) as? Int
        self.status = aDecoder.decodeObject(forKey: kUserStatusKey) as? Int
        self.internalIdentifier = aDecoder.decodeObject(forKey: kUserInternalIdentifierKey) as? Int
        self.fbId = aDecoder.decodeObject(forKey: kUserFbIdKey) as? String
        self.image = aDecoder.decodeObject(forKey: kUserImageKey) as? String
        self.imageName = aDecoder.decodeObject(forKey: kUserImageNameKey) as? String
        self.isProfileComplete = aDecoder.decodeObject(forKey: kUserIsProfileCompleteKey) as? Int
        self.accessToken = aDecoder.decodeObject(forKey: kUserTokenKey) as? String
        self.isTempPassword = aDecoder.decodeObject(forKey: kUserIsTempPassword) as? Int
        self.isSellerAccConnected = aDecoder.decodeObject(forKey: kUserIsSellerAccConnected) as? Int
        self.purchaseCount = aDecoder.decodeObject(forKey: kUserPurchaseCountKey) as? Int
        self.soldCount = aDecoder.decodeObject(forKey: kUserSoldCountKey) as? Int
        
        
        self.fbCityKey = aDecoder.decodeObject(forKey: kUserFbCityKey) as? String
        self.fbCountryKey = aDecoder.decodeObject(forKey: kUserFbCountryKey) as? String
        
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(city, forKey: kUserCityKey)
        aCoder.encode(name, forKey: kUserNameKey)
        aCoder.encode(email, forKey: kUserEmailKey)
        aCoder.encode(mobile, forKey: kUserMobileKey)
        aCoder.encode(loginType, forKey: kUserLoginTypeKey)
        aCoder.encode(age, forKey: kUserAgeKey)
        aCoder.encode(isMobileVerified, forKey: kUserIsMobileVerifiedKey)
        aCoder.encode(status, forKey: kUserStatusKey)
        aCoder.encode(internalIdentifier, forKey: kUserInternalIdentifierKey)
        aCoder.encode(fbId, forKey: kUserFbIdKey)
        aCoder.encode(image, forKey: kUserImageKey)
        aCoder.encode(imageName, forKey: kUserImageNameKey)
        aCoder.encode(isProfileComplete, forKey: kUserIsProfileCompleteKey)
        aCoder.encode(accessToken, forKey: kUserTokenKey)
        aCoder.encode(isTempPassword, forKey: kUserIsTempPassword)
        aCoder.encode(isSellerAccConnected, forKey: kUserIsSellerAccConnected)
        aCoder.encode(purchaseCount, forKey: kUserPurchaseCountKey)
        aCoder.encode(soldCount, forKey: kUserSoldCountKey)
        
        aCoder.encode(fbCityKey, forKey: kUserFbCityKey)
        aCoder.encode(fbCountryKey, forKey: kUserFbCountryKey)
        
    }

}

extension RBUser {

    //MARK: - User mmethod -

    //Full name
    func userFullName() -> String {
        var userName: String = ""
        if let nameText: String = self.name {
            userName = nameText
        }
        return userName
    }

    //User email
    func userEmail() -> String {
        var emailUser: String = ""
        if let emailID: String = self.email {
            emailUser = emailID
        }
        return emailUser
    }

    //First letter of last name
    func userNameTrimmingLastWord() -> String {

        var userName: String = ""
        if let nameText: String = self.name {
            let arrayWordsInText: [String] = nameText.components(separatedBy: " ")
            if arrayWordsInText.count > 1 {
                userName = arrayWordsInText[0]
                let secondLetter = arrayWordsInText.map { String($0.characters.first!) }
                userName = userName + " \(secondLetter[1])"
                return userName.capitalized
            } else {
                return nameText.capitalized
            }
        }
        return userName.capitalized
    }

    //Has user completed profile
    func hasUserCompletedProfile() -> Bool {
        var hasCompleted: Bool = false
        if let hasVerifiedProfile: Int = self.isProfileComplete, hasVerifiedProfile == 1 {
            hasCompleted = true
        }
        return hasCompleted
    }

    //Is user's email verified
    func isEmailVerified() -> Bool {
        var isEmail: Bool = false
        if let emailStatus: Int = self.status, emailStatus == 1 {
            isEmail = true
        }
        return isEmail
    }

    //Is temporary password
    func isTemporaryPassword() -> Bool {
        var isTemp: Bool = false
        if let temporaryPassword: Int = self.isTempPassword, temporaryPassword == 1 {
            isTemp = true
        }
        return isTemp
    }

    func address() -> String {
        var address: String = ""
        if let userCity = self.city?.name {
            address = userCity
        }
        if let userState = self.city?.state?.name {
            if address.length > 0 {
                address = address + ", \(userState)"
            } else {
                address = userState
            }
        }
        return address
    }

    func cityName() -> String {
        var city: String = ""
        if let userCity = self.city?.name {
            city = userCity
        }
        return city
    }

    func formattedAddress(fullAddress: Bool) -> String {
        if fullAddress {
            let addressWithEmail = self.address() + ", " + (self.email ?? "")
            return addressWithEmail
        } else {
            return self.cityName()
        }
    }

    func isFacebookUser() -> Bool {
        var isFacebook: Bool = false
        if let facebookId: Int = self.loginType, facebookId == 2 {
            isFacebook = true
        }
        return isFacebook
    }

    func userLocationString() -> String {
        var userLocation: String = ""
        if let cityString: String = self.city?.cityName(), cityString.characters.count > 0 {
            userLocation = cityString

            if let stateString: String = self.city?.state?.stateName(), stateString.characters.count > 0 {
                userLocation = userLocation + ", " + stateString
            }
        }
        return userLocation
    }

    func userAge() -> String {
        var userAge: String = "Years Old"
        if let ageInt: Int = self.age, ageInt > 0 {
            userAge = "\(ageInt)" + " " + "Years Old"
        }
        return userAge
    }

    func itemsSoldCount() -> String {
        if let soldItemInt: Int = self.soldCount {
            return "\(soldItemInt)"
        }
        return "0"
    }

    func itemsPurchasedCount() -> String {
        if let purchaseItemInt: Int = self.purchaseCount {
            return "\(purchaseItemInt)"
        }
        return "0"
    }

    //User image
    func userImageUrl() -> URL? {
        if let imageURLString: String = self.imageName, imageURLString.characters.count > 0, let imageURL: URL = URL.init(string: imageURLString) {
            return imageURL
        }
        return nil
    }

    //User age
    func userAgeInt() -> Int {
        var ageUser: Int = 0
        if let userAge: Int = self.age, userAge > 0 {
            ageUser = userAge
        }
        return ageUser
    }

    //User city model
    func userCityAreaModel() -> UserAreaParameters? {
        if let cityModel: RBCity = self.city, let cityName: String = cityModel.name, let cityId: Int = cityModel.internalIdentifier {
            return UserAreaParameters(areaId: "\(cityId)", areaName: cityName, areaCode: "")
        }
        return nil
    }

    //User state model
    func userStateModel() -> UserAreaParameters? {
        if let stateModel: RBState = self.city?.state, let stateName: String = stateModel.name, let stateId: Int = stateModel.internalIdentifier {
            return UserAreaParameters(areaId: "\(stateId)", areaName: stateName, areaCode: "")
        }
        return nil
    }

    //User country model
    func userCountryModel() -> UserAreaParameters? {
        if let countryModel: RBCountry = self.city?.state?.country {
            return UserAreaParameters(areaId: countryModel.countryId(), areaName: countryModel.countryName(), areaCode: countryModel.countryCodeName())
        }
        return nil
    }

    //User mobile number
    func mobileNumber() -> String {
        var num = ""
        if let number: String = self.mobile {
            num = number
        }
        return num
    }

    //Seller account status
    func hasSellerConnectedAccount() -> Bool {
        var hasConnected: Bool = false
        if let hashasConnectedAccount: Int = self.isSellerAccConnected, hashasConnectedAccount == 1 {
            hasConnected = true
        }
        return hasConnected
    }
    
}
