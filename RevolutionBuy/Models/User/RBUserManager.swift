//
//  UserManager.swift
//
//  Created by Sourabh Bhardwaj on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import ObjectMapper

let ACTIVE_USER_KEY = "activeUser"
let LOGGED_USER_EMAIL_KEY = "userEmail"

/// User Manager - manages all feature for User model
class RBUserManager: NSObject {

    fileprivate var _activeUser: RBUser?
    private var guestUser: Bool?

    var activeUser: RBUser! {
        get {
            return _activeUser
        }
        set {
            _activeUser = newValue

            if let _ = _activeUser {
                self.saveActiveUser()
            }
        }
    }

    // MARK: Singleton Instance
    fileprivate static let _sharedManager = RBUserManager()

    class func sharedManager() -> RBUserManager {
        return _sharedManager
    }

    fileprivate override init() {
        // initiate any queues / arrays / filepaths etc
        super.init()

        // Load last logged user data if exists
        if isUserLoggedIn() {
            loadActiveUser()
        }
    }

    func isUserLoggedIn() -> Bool {

        guard let _ = UserDefaults.object(forKey: ACTIVE_USER_KEY)
            else {
            return false
        }
        return true
    }

    func userLogout() {
        self.deleteActiveUser()
        AppDelegate.presentRootViewController()
        FacebookManager.sharedManager().logout()
        AnalyticsManager.setDistictUser(user: nil)
    }

    // MARK: - KeyChain / User Defaults / Flat file / XML

    /**
     Load last logged user data, if any
     */
    func loadActiveUser() {

        guard let decodedUser = UserDefaults.object(forKey: ACTIVE_USER_KEY) as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: decodedUser) as? RBUser
            else {
            return
        }
        self.activeUser = user
    }

    func lastLoggedUserEmail() -> String? {
        return UserDefaults.object(forKey: LOGGED_USER_EMAIL_KEY) as? String
    }

    /**
     Save current user data
     */
    func saveActiveUser() {

        UserDefaults.set(NSKeyedArchiver.archivedData(withRootObject: self.activeUser) as AnyObject?, forKey: ACTIVE_USER_KEY)

        if let email = self.activeUser.email {
            UserDefaults.set(email as AnyObject?, forKey: LOGGED_USER_EMAIL_KEY)
        }
    }

    /**
     Delete current user data
     */
    func deleteActiveUser() {
        // remove active user from storage
        UserDefaults.removeObject(forKey: ACTIVE_USER_KEY)
        UserDefaults.removeObject(forKey: Constants.FBUserLoginData.country)
        UserDefaults.removeObject(forKey: Constants.FBUserLoginData.city)
        UserDefaults.removeObject(forKey: Constants.FBUserLoginData.state)
        //UserDefaults.removeObject(forKey: Constants.FBUserLoginData.birthday)
        UserDefaults.synchronize()
        // free user object memory
        self.activeUser = nil
    }

    /**
     Set user as guest user
     */
    func setGuestUser() {
        self.guestUser = true
        self.deleteActiveUser()
        FacebookManager.sharedManager().logout()
        AnalyticsManager.setDistictUser(user: nil)
    }

    /**
     Remove guest user
     */
    func removeGuestUser() {
        self.guestUser = nil
    }

    /**
     Is user guest user
     */
    func isUserGuestUser() -> Bool {
        if let user: Bool = self.guestUser, user == true {
            return true
        }
        return false
    }

    /**
     Compare loggend In User
     */
    func compareCurrentUser(with otherUser: RBUser) -> Bool {
        var isSame = false
        if let curntUser: RBUser = self.activeUser, curntUser.internalIdentifier == otherUser.internalIdentifier {
            isSame = true
        }
        return isSame
    }
}

// MARK: API Services

extension RBUserManager {

    /**
     Method used to handle user signin and signup api response

     - parameter response:   api response
     - parameter completion: completion handler
     */
    func handleSignInSignUpResponse(_ response: Response, completion: (_ success: Bool, _ error: Error?) -> (Void)) {
        LogManager.logDebug("response = \(response)")

        if response.success {
            // parse the response
            if let accessToken = response.resultDictionary?.value(forKeyPath: "result.accessToken") as? String {

                if (response.resultDictionary?.value(forKeyPath: "result.user")) != nil {
                    let user: RBUser? = nil //ModelMapper<User>.map(userDictionary as! [String: AnyObject])!
                    user?.accessToken = accessToken

                    self.activeUser = user

                    completion(true, nil)
                } else {
                    completion(false, response.responseError)
                }
            } else {
                completion(false, response.responseError)
            }
        } else {
            completion(false, response.responseError)
        }
    }

    func performUrlRequest(_ urlString: String, params: [String: AnyObject], completion: @escaping(_ success: Bool, _ error: Error?) -> (Void)) {
        let finalParams = addAdditionalParameters(params)

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: urlString, params: finalParams) { (response) -> Void in

            self.handleSignInSignUpResponse(response, completion: completion)
        }
    }

    // MARK: Login via phone number
    func generateOTPAPI(_ mobileNumber: String, completion: @escaping(_ success: Bool, _ error: Error?, _ message: String) -> (Void)) {

        let params: [String: AnyObject] = ["mobile": mobileNumber as AnyObject]

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.createMobileOTPAPI, params: params) { (response) -> Void in

            LogManager.logDebug("response = \(response)")

            if response.success, let resultDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.user") as? NSDictionary, let userModel: RBUser = Mapper<RBUser>().map(JSON: resultDictionary as! [String: Any]) {
                LogManager.logDebug("response = \(userModel.dictionaryRepresentation())")
                completion(true, nil, RBGenericMethods.serviceResponseMessage(response: response))
            } else {
                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }

    func otpVerifyForChangedMobileNumber(_ mobileNumber: String, oneTimePassword: String, completion: @escaping(_ success: Bool, _ error: Error?, _ message: String) -> (Void)) {

        let params: [String: AnyObject] = ["mobile": mobileNumber as AnyObject, "pin": oneTimePassword as AnyObject]

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.verifyChangeMobileNumberPINAPI, params: params) { (response) -> Void in

            LogManager.logDebug("response = \(response)")

            if response.success, let resultDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.user") as? NSDictionary, let userModel: RBUser = Mapper<RBUser>().map(JSON: resultDictionary as! [String: Any]) {

                if let userToken: String = RBUserManager.sharedManager().activeUser.accessToken {
                    userModel.accessToken = userToken
                    RBUserManager.sharedManager().activeUser = userModel
                }

                completion(true, nil, RBGenericMethods.serviceResponseMessage(response: response))
            } else {
                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }

    // MARK: User Sign Up
    func registerWithEmail(_ parameter: [String: AnyObject], completion: @escaping(_ success: Bool, _ error: Error?, _ message: String, _ userModel: RBUser?) -> (Void)) {

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.sigupAPI, params: parameter) { (response) -> Void in

            LogManager.logDebug("response = \(response)")

            if response.success, let resultDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.user") as? NSDictionary, let userModel: RBUser = Mapper<RBUser>().map(JSON: resultDictionary as! [String: Any]) {
                completion(true, nil, "", userModel)
            } else {
                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }

    }

    // MARK: Login using email
    func loginWithEmail(email: String, password: String, completion: @escaping(_ success: Bool, _ error: Error?, _ message: String, _ userModel: RBUser?) -> (Void)) {

        //Create email Signup parameter
        var emailLoginParameters: [String: AnyObject] = [String: AnyObject]()
        emailLoginParameters.updateValue(email as AnyObject, forKey: "email")
        emailLoginParameters.updateValue(password as AnyObject, forKey: "password")
        emailLoginParameters.updateValue(AppDelegate.delegate().deviceToken() as AnyObject, forKey: "deviceToken")
        emailLoginParameters.updateValue(deviceID() as AnyObject, forKey: "deviceId")
        emailLoginParameters.updateValue(DEVICE_TYPE as AnyObject, forKey: "deviceType")

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.loginAPI, params: emailLoginParameters) { (response) -> Void in

            LogManager.logDebug("response = \(response)")

            if response.success, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.user") as? NSDictionary, let userModel: RBUser = Mapper<RBUser>().map(JSON: responseDictionary as! [String: Any]), let userToken: String = response.resultDictionary?.value(forKeyPath: "result.token") as? String {

                userModel.accessToken = userToken
                self.activeUser = userModel

                completion(true, nil, "", userModel)
            } else {
                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response), nil)
            }
        }
    }

    // MARK: Login using social platform
    func socialLoginWithID(_ params: [String: AnyObject], completion: @escaping(_ success: Bool, _ error: Error?, _ message: String, _ userModel: RBUser?, _ isSocialUserExist: Bool) -> (Void)) {

        var socialParams: [String: AnyObject] = params
        socialParams.updateValue(AppDelegate.delegate().deviceToken() as AnyObject, forKey: "deviceToken")
        socialParams.updateValue(deviceID() as AnyObject, forKey: "deviceId")
        socialParams.updateValue(DEVICE_TYPE as AnyObject, forKey: "deviceType")

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.socialLoginAPI, params: socialParams) { (response) -> Void in

            LogManager.logDebug("response = \(response)")

            if response.success, let userExistance: Int = response.resultDictionary?.value(forKeyPath: "result.isSocialMedia") as? Int, userExistance == 0 {

                completion(false, nil, RBGenericMethods.serviceResponseMessage(response: response), nil, false)

            } else if response.success, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.user") as? NSDictionary, let userModel: RBUser = Mapper<RBUser>().map(JSON: responseDictionary as! [String: Any]), let userToken: String = response.resultDictionary?.value(forKeyPath: "result.token") as? String {

                userModel.accessToken = userToken
                self.activeUser = userModel

                completion(true, nil, "", userModel, true)
            } else {
                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response), nil, true)
            }
        }
    }

    // MARK: Reset user password
    func resetUserPassword(_ email: String, completion: @escaping(_ success: Bool, _ oldPassword: String, _ message: String, _ error: Error?) -> (Void)) {

        let params: [String: AnyObject] = ["email": email as AnyObject]

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.resetPasswordAPI, params: params) { (response) -> Void in

            LogManager.logDebug("response = \(response)")

            if response.success == true {
                completion(true, "", RBGenericMethods.serviceResponseMessage(response: response), nil)
            } else {
                completion(false, "", RBGenericMethods.serviceResponseMessage(response: response), response.responseError)
            }
        }
    }

    // MARK: Reset user password
    func setNewPasswordPassword(_ password: String, completion: @escaping(_ success: Bool, _ userModel: RBUser?, _ message: String, _ error: Error?) -> (Void)) {

        let params: [String: AnyObject] = ["newPassword": password as AnyObject, "confirmPassword": password as AnyObject]

        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: Constants.APIServices.resetNewPasswordAPI, params: params) { (response) -> Void in

            LogManager.logDebug("response = \(response)")

            if response.success == true, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.user") as? NSDictionary, let userModel: RBUser = Mapper<RBUser>().map(JSON: responseDictionary as! [String: Any]) {
                completion(true, userModel, RBGenericMethods.serviceResponseMessage(response: response), nil)
            } else {
                completion(false, nil, RBGenericMethods.serviceResponseMessage(response: response), response.responseError)
            }
        }
    }

    // MARK: Logout
    func logoutAPI(_ completion: @escaping(_ success: Bool, _ error: Error?, _ message: String) -> (Void)) {

        RequestManager.sharedManager().performHTTPActionWithMethod(.GET, urlString: Constants.APIServices.logoutAPI, params: nil) { (response) -> Void in

            if response.success {
                completion(true, nil, "")
            } else {
                completion(false, response.responseError, RBGenericMethods.serviceResponseMessage(response: response))
            }
        }
    }
    
    // MARK: Payment Success
    func getAppUserID(completion: @escaping(_ success: Bool,_ userModel: RBUser?,_ message: String,_ error: Error?) -> (Void)) {
        
        let url =  "https://api.revolutionbuy.com/api/getAppUserId?user_id=\(RBUserManager.sharedManager().activeUser.internalIdentifier!)"
        
        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: url, params: nil) { (response) -> Void in
            
            LogManager.logDebug("response = \(response)")
            
            if response.success == true, let responseDictionary: NSDictionary = response.resultDictionary?.value(forKeyPath: "result.user") as? NSDictionary, let userModel: RBUser = Mapper<RBUser>().map(JSON: responseDictionary as! [String: Any]) {
                completion(true, userModel, RBGenericMethods.serviceResponseMessage(response: response), nil)
            } else {
                completion(false, nil, RBGenericMethods.serviceResponseMessage(response: response), response.responseError)
            }
        }
    }
    
    
    // MARK: Payment Success
    func getAppUserData(completion: @escaping(_ success: Bool,_ message: String,_ error: Error?) -> (Void)) {
        
        let url =  "http://technlogi.com/dev/RevBuyAPI/getMyurl.php"
        
        RequestManager.sharedManager().performHTTPActionWithMethod(.POST, urlString: url, params: nil) { (response) -> Void in
            
            LogManager.logDebug("response = \(response)")
            
            if response.success == true {
                completion(true, RBGenericMethods.serviceResponseMessage(response: response), nil)
            } else {
                completion(false, RBGenericMethods.serviceResponseMessage(response: response), response.responseError)
            }
        }
    }
    
    
}
