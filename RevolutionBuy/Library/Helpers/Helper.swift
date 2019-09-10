//
//  Helper.swift
//
//  Created by Sourabh Bhardwaj on 15/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

let DEVICE_ID_KEY = "deviceID"
let DEVICE_TYPE = "iOS"

let FB_USER_CITY = "City"
let FB_USER_COUNTRY = "Country"
let FB_USER_AGE = "Age"

/**
 Global function to check if the input object is initialized or not.

 - parameter value: value to verify for initialization

 - returns: true if initialized
 */
public func isObjectInitialized(_ value: AnyObject?) -> Bool {
    guard let _ = value else {
        return false
    }
    return true
}

// MARK: Directory Path helper methods

public func documentsDirectoryPath() -> String? {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
}

public let documentsDirectoryURL: URL = {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.endIndex - 1]
}()

public let cacheDirectoryURL: URL = {
    let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    return urls[urls.endIndex - 1]
}()

// MARK: API helper methods

public func deviceID() -> String {

    if let deviceID = UserDefaults.object(forKey: DEVICE_ID_KEY) {
        return deviceID as! String
    } else {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        UserDefaults.set(deviceID as AnyObject?, forKey: DEVICE_ID_KEY)
        return deviceID
    }
}

public func deviceInfo() -> [String: String] {

    var deviceInfo = [String: String]()
    deviceInfo["deviceID"] = deviceID()
    deviceInfo["deviceType"] = DEVICE_TYPE
    deviceInfo["deviceToken"] = AppDelegate.delegate().deviceToken()

    return deviceInfo
}

/**
 Add additional parameters to an existing dictionary

 - parameter params: parameters dictionary

 - returns: returns final dictionary
 */
func addAdditionalParameters(_ params: [String: AnyObject]) -> [String: AnyObject] {

    var finalParams = params
    finalParams["deviceInfo"] = deviceInfo() as AnyObject?
    return finalParams
}

/**
 Method used to handle api response and based on the status it calls completion handler

 - parameter response:   api response
 - parameter completion: completion handler
 */
func handleApiResponse(_ response: Response, completion: (_ success: Bool, _ error: Error?) -> (Void)) {
    LogManager.logDebug("response = \(response)")

    if response.success {
        completion(true, nil)
    } else {
        completion(false, response.responseError)
    }
}

// MARK: Application info methods
/**
 Get version of application.

 - returns: Version of app
 */
func applicationVersion() -> String {
    let info: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
    return info.object(forKey: "CFBundleVersion") as! String
}

/**
 Get bundle identifier of application.

 - returns: NSBundle identifier of app
 */
func applicationBundleIdentifier() -> NSString {
    return Bundle.main.bundleIdentifier! as NSString
}

/**
 Get name of application.

 - returns: Name of app
 */
func applicationName() -> String {
    let info: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
    return info.object(forKey: "CFBundleDisplayName") as! String
}

/**
 Detect that the app is running on a jailbroken device or not

 - returns: bool value for jailbroken device or not
 */
func isDeviceJailbroken() -> Bool {
    #if arch(i386) || arch(x86_64)
        return false
    #else
        let fileManager = FileManager.default

            if (fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt")) ||
            fileManager.fileExists(atPath: "/private/var/lib/apt/") ||
            fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") {
            return true
        } else {
            return false
        }
    #endif
}
