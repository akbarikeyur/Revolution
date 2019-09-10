//
//  SocialUser.swift
//
//  Created by Pawan Joshi on 08/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

struct SocialAccount {
    static let FACEBOOK = "Facebook"
    static let GOOGLE = "GooglePlus"
    static let LINKEDIN = "LinkedIn"
    static let TWITTER = "Twitter"
}

class SocialUser {

    var accountID: String!
    var accountType: String!

    var name: String?
    var email: String?
    var profilePicture: String?
    var ageRange: Int?
    
    var city:String?
    var country:String?
    
}
