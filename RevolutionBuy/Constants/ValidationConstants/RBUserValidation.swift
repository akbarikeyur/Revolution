//
//  RBUserValidation.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 04/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

//MARK: - User Area parameters -
struct UserAreaParameters {
    var areaId: String
    var areaName: String
    var areaCode: String
}

//MARK: - Struct email registration models -
struct UserRegistrationEmailModel {
    var email: String
    var password: String
}

struct UserRegistrationEmailModelValidation {

    var email: String?
    var password: String?

    enum InputError: Error {
        case EnterName
        case EnterEmail
        case EnterPassword
        case EnterCorrectEmail
        case EnterMobile
        case EnterCorrectMobile
        case SelectState
        case SelectCity
        case SelectCountry
        case PasswordLength
        case SelectProfilePicture
        case SelectAge
    }

    func createEmailUser() throws -> UserRegistrationEmailModel {

        guard let email = email, email.characters.count > 0 else {
            throw InputError.EnterEmail
        }

        if email.isValidEmail() == false {
            throw InputError.EnterCorrectEmail
        }

        guard let password = password, password.characters.count > 0 else {
            throw InputError.EnterPassword
        }

        if password.characters.count <= 4 || password.characters.count > 15 {
            throw InputError.PasswordLength
        }

        return UserRegistrationEmailModel(email: email, password: password)
    }
}

//MARK: - Struct Add profile model -
struct UserAddProfileModel {
    var fullName: String
    var age: String
    var countryId: String
    var stateId: String
    var cityID: String
    var imageData: Data
    var mobileNumber: String
    var countryCode: String
}

struct UserAddProfileModelValidation {

    var fullName: String?
    var age: String?
    var countryId: String?
    var stateId: String?
    var cityID: String?
    var imageData: Data?
    var mobileNumber: String?
    var countryCode: String?

    enum InputError: Error {
        case EnterName
        case EnterCorrectName
        case EnterMobile
        case EnterCorrectMobile
        case SelectState
        case SelectCity
        case SelectCountry
        case SelectProfilePicture
        case SelectAge
        case InvalidAge
    }

    func fillUserDetailsValidation() throws -> UserAddProfileModel {

        guard let fullName = fullName, fullName.characters.count > 0 else {
            throw InputError.EnterName
        }

        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        if fullName.rangeOfCharacter(from: characterset.inverted) != nil {
            throw InputError.EnterCorrectName
        }

        guard let age = age, age.characters.count > 0 else {
            throw InputError.SelectAge
        }

        if Int(age)! < 18 || Int(age)! > 100 {
            throw InputError.InvalidAge
        }

        guard let countryId = countryId, countryId.characters.count > 0 else {
            throw InputError.SelectCountry
        }

        guard let stateId = stateId, stateId.characters.count > 0 else {
            throw InputError.SelectState
        }

        guard let cityID = cityID, cityID.characters.count > 0 else {
            throw InputError.SelectCity
        }

        var countryPhoneCode: String = ""
        if let countryCodeNumber: String = countryCode {
            countryPhoneCode = countryCodeNumber
        }

        var imageSelectedData: Data = Data()
        if let imageData = imageData {
            imageSelectedData = imageData
        }

        return UserAddProfileModel(fullName: fullName, age: age, countryId: countryId, stateId: stateId, cityID: cityID, imageData: imageSelectedData, mobileNumber: "", countryCode: countryPhoneCode)
    }
}

//MARK: - Validate mobile number -
struct UserMobileNumberValidation {

    var mobileNumber: String?

    enum InputError: Error {
        case EnterMobile
        case EnterCorrectMobile
    }

    func validateUserMobile() throws -> String {

        guard let mobileNumber = mobileNumber, mobileNumber.characters.count > 0 else {
            throw InputError.EnterMobile
        }

        if mobileNumber.hasPrefix("+") == false {
            throw InputError.EnterCorrectMobile
        }

        return mobileNumber
    }
}

//MARK: - Validate facebook login -
struct SocialUserValidation {

    enum InputError: Error {
        case underAge
    }

    func validateSocialUser(user socialUser: SocialUser) throws -> [String: AnyObject] {

        var params: [String: AnyObject] = [String: AnyObject]()

        //Check Age Range
        if let ageRange: Int = socialUser.ageRange {

            if ageRange < 18 {
                throw InputError.underAge
            }
        } else {
            LogManager.logDebug("Unable to fetch age range")
        }

        //Check email
        if let userEmail: String = socialUser.email, userEmail.characters.count > 0 {
            params.updateValue(userEmail as AnyObject, forKey: "email")
        } else {
            params.updateValue("" as AnyObject, forKey: "email")
        }

        //Check username
        if let userName: String = socialUser.name, userName.characters.count > 0 {
            params.updateValue(userName as AnyObject, forKey: "name")
        } else {
            params.updateValue("" as AnyObject, forKey: "name")
        }

        
        //Check City
        if let cityName: String = socialUser.city, cityName.characters.count > 0 {
            params.updateValue(cityName as AnyObject, forKey: "city")
        } else {
            params.updateValue("" as AnyObject, forKey: "city")
        }
        
        //Check Country
        if let countryName: String = socialUser.city, countryName.characters.count > 0 {
            params.updateValue(countryName as AnyObject, forKey: "country")
        } else {
            params.updateValue("" as AnyObject, forKey: "country")
        }
        
        //Facebook id
        params.updateValue(socialUser.accountID as AnyObject, forKey: "fbId")

        return params

    }
}

