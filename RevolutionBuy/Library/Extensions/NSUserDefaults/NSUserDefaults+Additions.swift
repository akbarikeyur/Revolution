//
//  NSUserDefaults+Additions.swift
//
//  Created by Anish Kumar on 20/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

// MARK: - NSUserDefaults Extension
extension UserDefaults {

    // MARK: - User Defaults
    /**
     sets/adds object to NSUserDefaults

     - parameter aObject: object to be stored
     - parameter defaultName: key for object
     */
    class func setObject(_ value: AnyObject?, forKey defaultName: String) {
        UserDefaults.set(value, forKey: defaultName)
        UserDefaults.synchronize()
    }

    /**
     gives stored object in NSUserDefaults for a key

     - parameter defaultName: key for object

     - returns: stored object for key
     */
    class func objectForKey(_ defaultName: String) -> AnyObject? {
        return UserDefaults.object(forKey: defaultName) as AnyObject?
    }

    /**
     removes object from NSUserDefault stored for a given key

     - parameter defaultName: key for object
     */
    class func removeObjectForKey(_ defaultName: String) {
        UserDefaults.removeObject(forKey: defaultName)
        UserDefaults.synchronize()
    }
}
