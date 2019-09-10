//
//  FacebookConfiguration.swift
//
//  Created by Sourabh Bhardwaj on 06/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FacebookConfiguration: SocialConfiguration {

    fileprivate static var fbConfiguration: FacebookConfiguration?

    // MARK: - Permissions
    struct Permissions {
        static let PublicProfile = "public_profile"
        static let Email = "email"
        static let UserFriends = "user_friends"
        static let UserAboutMe = "user_about_me"
        static let UserBirthday = "user_birthday"
        static let UserHometown = "user_hometown"
        static let UserLikes = "user_likes"
        static let UserInterests = "user_interests"
        static let UserPhotos = "user_photos"
        static let FriendsPhotos = "friends_photos"
        static let FriendsHometown = "friends_hometown"
        static let FriendsLocation = "friends_location"
        static let FriendsEducationHistory = "friends_education_history"
        static let UserLocation = "user_location"
        
    }

    fileprivate class func defaultPermissions() -> [String] {
        //return [Permissions.PublicProfile, Permissions.Email,Permissions.UserLocation,Permissions.UserBirthday]
        return [Permissions.PublicProfile, Permissions.Email]
    }

    override init(client_ID: String, scope: [String]) {
        super.init(client_ID: client_ID, scope: scope)
    }

    // MARK: - Helpers
    fileprivate class func fbAppId() -> String! {
        return ConfigurationManager.sharedManager().facebookAppId()
    }

    class func defaultConfiguration() -> FacebookConfiguration {

        if fbConfiguration == nil {
            fbConfiguration = FacebookConfiguration(client_ID: fbAppId(), scope: defaultPermissions())
        }

        // Optionally add to ensure your credentials are valid:
        FBSDKLoginManager.renewSystemCredentials { (result: ACAccountCredentialRenewResult, error: Error?) -> Void in
            if let _ = error {
                LogManager.logError(error?.localizedDescription)
            }
        }

        return fbConfiguration!
    }

}
