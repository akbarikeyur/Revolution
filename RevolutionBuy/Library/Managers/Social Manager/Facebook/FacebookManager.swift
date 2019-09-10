//
//  FacebookManager.swift
//
//  Created by Sourabh Bhardwaj on 03/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import FBSDKCoreKit
//import FBSDKShareKit
import FBSDKLoginKit

class FacebookManager: SocialManager, Social {

    fileprivate static var manager = FacebookManager()
    var configuration: FacebookConfiguration = FacebookConfiguration.defaultConfiguration()

    fileprivate override init() {
        super.init()

        // customize initialization
    }

    // MARK: - Singleton Instance
    /**
     Initializes FacebookManager class to have a new instance of manager

     - parameter config: requires a FacebookConfiguration instance which is required to configure the manager

     - returns: an instance of FacebookManager which can be accessed via sharedManager()
     */
    class func managerWithConfiguration(_ config: FacebookConfiguration!) -> FacebookManager {

        if config != nil {
            manager.configuration = config!
            manager.configuration.isConfigured = true
        }
        return manager
    }

    class func sharedManager() -> FacebookManager {
        if isManagerConfigured() == false {
            managerWithConfiguration(FacebookConfiguration.defaultConfiguration())
        }
        return manager
    }

    // MARK: - Helpers for Manager
    fileprivate class func isManagerConfigured() -> Bool {
        return self.manager.configuration.isConfigured
    }

    class func resetManager() {
        self.manager.configuration.isConfigured = false
    }

    // MARK: - Token
    class func token() -> FBSDKAccessToken? {
        return FBSDKAccessToken.current()
    }

    func tokenString() -> String {
        return FBSDKAccessToken.current().tokenString
    }

    func isTokenValid() -> Bool {
        if let _ = FBSDKAccessToken.current() {
            return true
        } else {
            return false
        }
    }

    // MARK: Profile
    func currentProfile() -> FBSDKProfile {
        return FBSDKProfile.current()
    }

    func currentProfileURL() -> URL {
        return FBSDKProfile.current().imageURL(for: FBSDKProfilePictureMode.square, size: CGSize(width: 100, height: 100))
    }

    func logout() {
        super.logOut()
        LogManager.logDebug("logout facebook")
        FBSDKLoginManager().logOut()

        // flush permissions
        configuration.permissions = []
    }

    fileprivate func loginWithAccountFramework() {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierFacebook)

        let options: [String: AnyObject] = [ACFacebookAppIdKey: ConfigurationManager.sharedManager().facebookAppId() as AnyObject,
            ACFacebookPermissionsKey: [FacebookConfiguration.Permissions.PublicProfile, FacebookConfiguration.Permissions.Email] as AnyObject,
            ACFacebookAudienceKey: ACFacebookAudienceFriends as AnyObject]
        accountStore.requestAccessToAccounts(with: accountType, options: options) { (success, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if !success {
                    self.socialCompletionHandler!(nil, NSError(domain: "Error", code: 201, userInfo: ["info": error?.localizedDescription]))
                    return
                }
                let accounts = accountStore.accounts(with: accountType) as! [ACAccount]
                guard let fbAccount = accounts.first else {
                    self.socialCompletionHandler!(nil, NSError(domain: "Error", code: 201, userInfo: ["info": "There is no Facebook account configured. You can add or create a Facebook account in Settings."]))
                    return
                }
                LogManager.logDebug("\nFacebook account details:\n")
                LogManager.logDebug(fbAccount.userFullName)
                if let credentials = fbAccount.credential.oauthToken {
                    LogManager.logDebug(credentials)
                }
                let socialUser = SocialUser()
                socialUser.accountID = fbAccount.identifier as String!
                socialUser.accountType = SocialAccount.FACEBOOK
                socialUser.name = fbAccount.userFullName
                self.socialCompletionHandler!(socialUser, nil)
            })
        }
    }

    fileprivate func loginWithFacebookSDK() {
        if self.isTokenValid() {
            self.fetchProfileInfo(nil)
        } else {

            print("Permissions \(configuration.permissions)")
            FBSDKLoginManager().logIn(withReadPermissions: configuration.permissions, from: fromController, handler: { (result, error) in

                if error != nil {
                    // According to Facebook:
                    // Errors will rarely occur in the typical login flow because the login dialog
                    // presented by Facebook via single sign on will guide the users to resolve any errors.
                    FBSDKLoginManager().logOut()
                    self.socialCompletionHandler?(nil, error)

                } else if let resultFacebook: FBSDKLoginManagerLoginResult  = result {

                    if resultFacebook.isCancelled {

                        // Handle cancellations
                        FBSDKLoginManager().logOut()
                        self.socialCompletionHandler?(nil, error)

                    } else {

                        self.fetchProfileInfo(nil)

                    }
                }
            })

            //            FBSDKLoginManager().logIn(withReadPermissions: configuration.permissions, from: fromController) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            //
            //            }
        }
    }

    //
    // MARK: - Login
    //

    /**
     Wrapper method to provide Facebook Login

     - parameter fromController: source view controller from which login should be prompted.
     - parameter handler:        return with SocialCompletionHandler, either valid social user or with error information
     */
    override func loginFromController(_ sourceController: UIViewController, Handler handler: SocialCompletionHandler? = nil) {
        super.loginFromController(sourceController, Handler: handler)

        self.loginWithFacebookSDK()
    }

    //
    // MARK: - Profile Info
    //

    /**
     Returns user facebook profile information

     - parameter completion: gets callback once facebook server gives response
     */
    override func fetchProfileInfo(_ completion: SocialCompletionHandler?) {
        // See link for more fields:
        // http://stackoverflow.com/questions/32031677/facebook-graph-api-get-request-should-contain-fields-parameter-swift-faceb

        if completion != nil {
            self.socialCompletionHandler = completion
        }

       // let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, first_name, last_name, gender, picture.width(400).height(400),location{location},birthday"], httpMethod: "GET")
        
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, first_name, last_name, gender, picture.width(400).height(400),birthday"], httpMethod: "GET")
        
        request.start { (connection, result, error) -> Void in

            if let error = error { // handle error
                self.logout()
                LogManager.logError("error in getting profile info = \(error.localizedDescription)")
                self.socialCompletionHandler?(nil, NSError(domain: "Error", code: 201, userInfo: ["info": error.localizedDescription]))
            } else {
                print(result)
                LogManager.logDebug("success get profile info: = \(result!)")

                if let userInfo: NSDictionary = result as? NSDictionary {
                    self.extractDataFromResponseReceived(userInfo: userInfo)
                } else {
                    self.socialCompletionHandler?(nil, NSError(domain: "Error", code: 201, userInfo: ["info": "Invalid data received"]))
                }
            }
        }
    }

    private func extractDataFromResponseReceived(userInfo: NSDictionary) {

        let socialUser = SocialUser()
        socialUser.accountType = SocialAccount.FACEBOOK

        guard let accountId: String = userInfo["id"] as? String else {
            return
        }
        socialUser.accountID = accountId

        socialUser.name = userInfo["name"] as? String
        socialUser.email = userInfo["email"] as? String
        socialUser.profilePicture = userInfo.value(forKeyPath: "picture.data.url") as? String

        if let ageDictionary: NSDictionary = userInfo.value(forKeyPath: "age_range") as? NSDictionary{
            if let minAge: Int = ageDictionary.value(forKeyPath: "min") as? Int {
            socialUser.ageRange = minAge
            }
        }
//        if let userBirthday : String = userInfo.value(forKey: "birthday")as? String{
//            UserDefaults.setValue(userBirthday, forKey: Constants.FBUserLoginData.birthday)
//        }
        if let userLocationDict : NSDictionary = userInfo.value(forKey: "location")as? NSDictionary{
            if let userLoc : NSDictionary = userLocationDict.value(forKey: "location")as? NSDictionary{
                if let userCity : String = userLoc.value(forKey: "city")as? String{
                    UserDefaults.setValue(userCity, forKey: Constants.FBUserLoginData.city)
                    
                }
                
                if let userState : String = userLoc.value(forKey: "state")as? String{
                    UserDefaults.setValue(userState, forKey: Constants.FBUserLoginData.state)
                }
                
                if let userCountry : String = userLoc.value(forKey: "country")as? String{
                    UserDefaults.setValue(userCountry, forKey: Constants.FBUserLoginData.country)
                }
                
                    UserDefaults.synchronize()
            }
         
        }
        self.socialCompletionHandler?(socialUser, nil)
    }

    //
    // MARK: - Profile Picture
    //

    /**
     Returns user facebook picture url

     - parameter completion: gets callback once facebook server gives response
     */
    func facebookProfilePicture(completion: @escaping(URL) -> Void) {

        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "picture.width(400).height(400)"], httpMethod: "GET")
        request.start { (connection, result, error) -> Void in

            if let userInfo: NSDictionary = result as? NSDictionary, let urlString: String = userInfo.value(forKeyPath: "picture.data.url") as? String, urlString.characters.count > 0 {
                let url: URL = URL.init(string: urlString)!
                completion(url)
            }
        }
    }

    //
    // MARK: - Friends
    //

    /**
     Returns user's facebook friends who are using current application

     - parameter completion: gets callback once facebook server gives response
     */
    func getFriends(_ completion: @escaping(_ result: NSDictionary?, _ error: NSError?) -> Void) {

        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": "id, email, name, first_name, last_name, gender, picture"], httpMethod: "GET")
        request.start { (connection, result, error) -> Void in

            if let error = error { // handle error
                self.logout()
                LogManager.logError("error in getting friends = \(error.localizedDescription)")
                completion(nil, NSError(domain: "Error", code: 201, userInfo: ["info": error.localizedDescription]))
            } else {
                LogManager.logDebug("success get friends: = \(result!)")
                if let friends: NSDictionary = result as? NSDictionary {
                    completion(friends, nil)
                } else {
                    completion(nil, NSError(domain: "Error", code: 201, userInfo: ["info": NSLocalizedString("Invalid data received", comment: "Invalid data received")]))
                }
            }
        }
    }

    //
    // MARK: - Share link content
    //

    /**
     Post a Link with image having a caption, description and name
     * Link with image is posted on the me/feed graph path
     * link : NSURL - link to be shared with post
     * picture : NSURL - picture to be shred with post
     * name : NSString - Name for post( appears like a title)
     * description : NSString - Description for post ( appears like a subtitle)
     * caption : NSString - caption for image (apeears at bottom)
     * competion : gets callback once facebook server gives response
     */
    func shareLinkContent(_ link: URL, picture: URL, name: String, description: NSString, caption: NSString, completion: @escaping(_ result: NSDictionary?, _ error: NSError?) -> Void) {

        let params = ["": "null",
            "link": link.absoluteString,
            "picture": picture.absoluteString,
            "name": name,
            "description": description,
            "caption": caption] as [String: Any]

        let request = FBSDKGraphRequest(graphPath: "me/feed", parameters: params, httpMethod: "POST")

        request?.start { (connection, result, error) -> Void in
            if let error = error {
                LogManager.logError("error in posting link with image = \(error)")
                completion(nil, NSError(domain: "Error", code: 201, userInfo: ["info": error.localizedDescription]))
            } else {
                LogManager.logDebug("success in posting link with image: = \(result!)")
                if let id: NSDictionary = result as? NSDictionary {
                    completion(id, nil)
                } else {
                    completion(nil, NSError(domain: "Error", code: 201, userInfo: ["info": NSLocalizedString("Invalid data received", comment: "Invalid data received")]))
                }
            }
        }
    }

}
