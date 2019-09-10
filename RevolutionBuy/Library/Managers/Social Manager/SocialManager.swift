//
//  SocialManager.swift
//
//  Created by Sourabh Bhardwaj on 05/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

public enum SocialType: Int {
    case facebook = 1
    case twitter = 2
    case google = 3
    case linkedIn = 4
}

@objc protocol Social {

    // MARK: - Configuration

    //    func defaultConfig()

    @objc optional func clientId() -> String?

    @objc optional func clientSecret() -> String?

    @objc optional func displayName() -> String?

    @objc optional func permissions() -> [String]?

    /**
     Wrapper method to provide facebook login

     - parameter sourceVC:     Source view controller from which login should be prompted.
     - parameter successBlock: Gets callback once login is successful
     - parameter failureBlock: Gets callback if there is any error in the login process
     */
    //    optional func loginWithReadPermissions( permissions: [AnyObject]?, fromViewController sourceVC: UIViewController!, Completion handler: SocialCompletionHandler)
}

/// Completion Handler returns user or error
typealias SocialCompletionHandler = (_ user: SocialUser?, _ error: Error?) -> Void

class SocialManager: NSObject {
    // MARK: - Closures
    var socialCompletionHandler: SocialCompletionHandler?
    var socialUser: SocialUser?
    var fromController: UIViewController!

    // MARK: - Login / Logout
    /**
     User Login

     - parameter fromController: controller on which login button
     - parameter handler:        callback on complete login
     */
    func loginFromController(_ sourceController: UIViewController, Handler handler: SocialCompletionHandler? = nil) {
        self.fromController = sourceController
        if handler != nil {
            socialCompletionHandler = handler
        }
    }

    /**
     User Login

     - parameter handler: callback on complete login
     */

    func login(_ handler: SocialCompletionHandler?) {
        if handler != nil {
            socialCompletionHandler = handler
        }

        assert(self.fromController != nil, "Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'fromController must not be nil")
        self.loginFromController(self.fromController, Handler: self.socialCompletionHandler)
    }

    /**
     User Login
     */
    func login() {
        assert(self.fromController != nil, "Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'fromController must not be nil")
        self.loginFromController(self.fromController, Handler: self.socialCompletionHandler)
    }

    /**
     User Logout
     */
    func logOut() {
        socialUser = nil
    }

    /**
     Get User Profile

     - parameter completion: callback on get profile
     */
    func fetchProfileInfo(_ completion: SocialCompletionHandler?) {
        if completion != nil {
            socialCompletionHandler = completion
        }
    }

}
