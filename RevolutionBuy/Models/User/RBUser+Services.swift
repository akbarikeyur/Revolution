//
//  User+Services.swift
//
//  Created by Sourabh Bhardwaj on 07/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import ObjectMapper
// MARK: API Services
extension RBUser {

    // MARK: Upload user profile photo
    class func addUserProfileWithPinAPI(_ signUpModel: UserAddProfileModel, otpEntered: String, completion: @escaping(_ success: Bool, _ error: Error?, _ message: String, _ userModel: RBUser?) -> (Void)) {

        var signUpParamters: [String: String] = [String: String]()
        signUpParamters.updateValue(signUpModel.fullName, forKey: "name")
        signUpParamters.updateValue(signUpModel.age, forKey: "age")
        signUpParamters.updateValue(signUpModel.cityID, forKey: "cityId")
        signUpParamters.updateValue(signUpModel.mobileNumber, forKey: "mobile")
        signUpParamters.updateValue(otpEntered, forKey: "pin")

        var fileParams = [String: AnyObject]()
        if signUpModel.imageData.count > 0 {
            fileParams["key"] = "image" as AnyObject?
            fileParams["fileName"] = "userImage.jpg" as AnyObject?
            fileParams["value"] = signUpModel.imageData as AnyObject?
            fileParams["contentType"] = "image/jpeg" as AnyObject?
        }

        var request: URLRequest = URLRequest(url: URL(string: Constants.APIServices.addProfileWithVerifyPinAPI)!)

        request.setMultipartFormData(signUpParamters, fileFields: [fileParams])

        RequestManager.sharedManager().performRequest(request, userInfo: nil) { (response) -> Void in

            LogManager.logDebug("response = \(response)")

            if response.success, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.user") as? NSDictionary, let userModel: RBUser = Mapper<RBUser>().map(JSON: responseDictionary as! [String: Any]) {

                if let userToken: String = RBUserManager.sharedManager().activeUser.accessToken {
                    userModel.accessToken = userToken
                    RBUserManager.sharedManager().activeUser = userModel
                }

                completion(true, nil, "", userModel)
            } else {
                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }

    // MARK: Edit Profile
    class func editProfileWithAPI(_ signUpModel: UserAddProfileModel, completion: @escaping(_ success: Bool, _ error: Error?, _ message: String, _ userModel: RBUser?) -> (Void)) {

        var signUpParamters: [String: String] = [String: String]()
        signUpParamters.updateValue(signUpModel.fullName, forKey: "name")
        signUpParamters.updateValue(signUpModel.age, forKey: "age")
        signUpParamters.updateValue(signUpModel.cityID, forKey: "cityId")

        var fileParams = [String: AnyObject]()
        if signUpModel.imageData.count > 0 {
            fileParams["key"] = "image" as AnyObject?
            fileParams["fileName"] = "userImage.jpg" as AnyObject?
            fileParams["value"] = signUpModel.imageData as AnyObject?
            fileParams["contentType"] = "image/jpeg" as AnyObject?
        }

        var requestEditProfile: URLRequest = URLRequest(url: URL(string: Constants.APIServices.editProfileAPI)!)

        requestEditProfile.setMultipartFormData(signUpParamters, fileFields: [fileParams])

        RequestManager.sharedManager().performRequest(requestEditProfile, userInfo: nil) { (response) -> Void in

            LogManager.logDebug("response = \(response)")

            if response.success, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.user") as? NSDictionary, let userModel: RBUser = Mapper<RBUser>().map(JSON: responseDictionary as! [String: Any]) {

                if let userToken: String = RBUserManager.sharedManager().activeUser.accessToken {
                    userModel.accessToken = userToken
                    RBUserManager.sharedManager().activeUser = userModel
                }

                completion(true, nil, RBGenericMethods.serviceResponseMessage(response: response), userModel)
            } else {
                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }

    // MARK: Change user password
    static func changePassword(_ oldPassword: String, newPassword: String, confirmPassword: String, completion: @escaping(_ success: Bool, _ error: Error?, _ message: String) -> (Void)) {

        let params = ["oldPassword": oldPassword, "newPassword": newPassword, "confirmPassword": confirmPassword]

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.changePasswordAPI, params: params as [String: AnyObject]?) { (response) -> Void in

            LogManager.logDebug("response = \(response)")

            if response.success {
                completion(true, nil, RBGenericMethods.serviceResponseMessage(response: response))
            } else {
                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }

    // MARK: UpdateDevice token
    static func updateDeviceToken(deviceToken: String, completion: @escaping(_ success: Bool, _ error: NSError?) -> (Void)) {

        let parameter: [String: AnyObject] = ["deviceToken": AppDelegate.delegate().deviceToken() as AnyObject]

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.updateDeviceTokenAPI, params: parameter) { (response) -> Void in
            if response.success {
                LogManager.logDebug("response = \(response)")
                completion(true, nil)
            }
        }
    }

    // MARK: View Profile
    class func viewProfileWithAPI(completion: @escaping(_ success: Bool, _ error: Error?, _ message: String, _ userModel: RBUser?) -> (Void)) {

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.fetchProfileDetailsAPI, params: nil) { (response) -> Void in
            LogManager.logDebug("response = \(response)")

            if response.success, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.user") as? NSDictionary, let userInformationModel: RBUser = Mapper<RBUser>().map(JSON: responseDictionary as! [String: Any]) {

                if let userAccessToken: String = RBUserManager.sharedManager().activeUser.accessToken {
                    userInformationModel.accessToken = userAccessToken
                    RBUserManager.sharedManager().activeUser = userInformationModel
                }
                completion(true, nil, RBGenericMethods.serviceResponseMessage(response: response), userInformationModel)
            } else {

                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }
}
