//
//  AnalyticsManager.swift
//
//  Created by Geetika Gupta on 06/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Mixpanel

enum PlatformType {
    case mixPannel
    case flurry
    case googleAnalytics
}

class AnalyticsManager: NSObject {

    static var platformType: PlatformType = .mixPannel

    /**
     Method to initialize track tool as per their selection.

     - parameter tool: A type of track tool
     */
    class func initializeTracker() {

        switch platformType {

        case .mixPannel:

            if ConfigurationManager.sharedManager().trackingEnabled() {
                Mixpanel.sharedInstance(withToken: ConfigurationManager.sharedManager().analyticsKey())
            }

        default:
            break
        }
    }

    /**
     Track event on particular event.

     - parameter eventName:  A String is a event name which we want to given for track
     - parameter attributes: A Dictionary to ass more attribute
     - parameter tool:       track tool which contain type of tool which we want to prefer for tracking
     - parameter screenName: A String is a screen name
     */
    class func trackEvent(_ eventName: String, attributes: NSDictionary?, screenName: String?) {

        switch platformType {

        case .mixPannel:

            if let _ = attributes {
                Mixpanel.sharedInstance()?.track(eventName, properties: attributes as? [AnyHashable: Any]) //Plan selected)
            } else {
                Mixpanel.sharedInstance()?.track(eventName)
            }

        default:
            break
        }
    }
}

extension AnalyticsManager {

    class func registerMixpanelUserWith(userID: String, email: String, name: String, mobileNumber: String) {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            let dictForUser = ["userID": userID, "email": email, "Name": name, "Time": NSDate(), "phone": mobileNumber] as [String: Any]
            Mixpanel.sharedInstance()?.identify(userID)
            Mixpanel.sharedInstance()?.people.set(dictForUser)
            Mixpanel.sharedInstance()?.registerSuperProperties(dictForUser)
        }
    }

    class func manageMixpanelUserIdentityWithUserId(userID: String, email: String, name: String, mobileNumber: String) {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            let dictForUser = ["userID": userID, "email": email, "Name": name, "Time": NSDate(), "phone": mobileNumber] as [String: Any]
            Mixpanel.sharedInstance()?.identify(userID)
            Mixpanel.sharedInstance()?.registerSuperProperties(dictForUser)
        }
    }

    class func trackMixpanelEvent(eventName: String) {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            Mixpanel.sharedInstance()?.track(eventName)
        }
    }

    //MARK: - Track Mixpanel event with properties -
    class func trackMixpanelEventWithProperties(eventName: String, dict: NSDictionary) {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            Mixpanel.sharedInstance()?.track(eventName, properties: dict as [NSObject: AnyObject])
        }
    }

    class func trackChargesInMixpanelEvent(Value: NSNumber, attributeDictattributes: NSDictionary) {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            Mixpanel.sharedInstance()?.people.trackCharge(Value, withProperties: attributeDictattributes as [NSObject: AnyObject])
        }
    }

    class func incremnetOfUserEvent(eventName: String, withValuenumber: NSNumber) {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            Mixpanel.sharedInstance()?.people.increment(eventName, by: withValuenumber)
        }
    }

    class func incrementOfUserWithAttributeDict(attributes: NSDictionary) {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            Mixpanel.sharedInstance()?.people.increment(attributes as [NSObject: AnyObject])
        }
    }
}

extension AnalyticsManager {

    /*
     * Set distinct user id
     * if set to nil, the user is changed to
     * Anonymous User
     */
    class func setDistictUser(user: RBUser?) {
        if let userId = user?.internalIdentifier {
            // Registered User
            Mixpanel.sharedInstance()?.identify("\(userId)")
        } else {
            // Anonymous User
            Mixpanel.sharedInstance()?.clearSuperProperties()
            Mixpanel.sharedInstance()?.reset()
        }
    }

    class func setDistictUserSuperProperties(type: String, action: Int, personModel: RBUser?) {

        guard let user: RBUser = personModel else {
            return
        }

        //Add person model to Mixpanel
        self.setPersonOnMixPanel(person: user, action: action)

        //Add user properties
        self.setPersonUserPropertiesOnMixPanel(type: type, person: user, action: action)

        //Add super properties
        self.setSuperPropertiesOnMixPanel(type: type, person: user, action: action)
    }

    //Add super properties
    private class func setSuperPropertiesOnMixPanel(type: String, person: RBUser, action: Int) {

        let eventProperties: NSMutableDictionary = NSMutableDictionary()

        guard let userId: Int = person.internalIdentifier else {
            return
        }

        eventProperties.setValue(String(userId), forKey: "UserId")
        eventProperties.setValue(type, forKey: "UserType")

        if action == 0 { //0 = Login, 1 = Sign up
            eventProperties.setValue("Login", forKey: "Action")
        } else {
            eventProperties.setValue("SignUp", forKey: "Action")
        }

        eventProperties.setValue(person.mobileNumber(), forKey: "Phone")
        eventProperties.setValue(person.userEmail(), forKey: "Email")
        eventProperties.setValue(person.userFullName(), forKey: "Name")
        eventProperties.setValue(person.userAge(), forKey: "Age")

        if let cityModel: UserAreaParameters = person.userCityAreaModel() {
            eventProperties.setValue(cityModel.areaName, forKey: "selectedCity")
        }

        if let stateModel: UserAreaParameters = person.userStateModel() {
            eventProperties.setValue(stateModel.areaName, forKey: "selectedState")
        }

        if let countryModel: UserAreaParameters = person.userCountryModel() {
            eventProperties.setValue(countryModel.areaName, forKey: "selectedCountry")
        }

        Mixpanel.sharedInstance()?.registerSuperProperties(eventProperties as [NSObject: AnyObject])

    }

    //Add user properties
    private class func setPersonUserPropertiesOnMixPanel(type: String, person: RBUser, action: Int) {

        let userProperties: NSMutableDictionary = NSMutableDictionary()

        guard let userId: Int = person.internalIdentifier else {
            return
        }

        userProperties.setValue(String(userId), forKey: "UserId")
        userProperties.setValue(type, forKey: "UserType")

        if action == 0 { //0 = Login, 1 = Sign up
            userProperties.setValue("Login", forKey: "Action")
        } else {
            userProperties.setValue("SignUp", forKey: "Action")
        }

        userProperties.setValue(person.userAge(), forKey: "Age")

        if let cityModel: UserAreaParameters = person.userCityAreaModel() {
            userProperties.setValue(cityModel.areaName, forKey: "selectedCity")
        }

        if let stateModel: UserAreaParameters = person.userStateModel() {
            userProperties.setValue(stateModel.areaName, forKey: "selectedState")
        }

        if let countryModel: UserAreaParameters = person.userCountryModel() {
            userProperties.setValue(countryModel.areaName, forKey: "selectedCountry")
        }

        Mixpanel.sharedInstance()?.people.set(userProperties as [NSObject: AnyObject])
    }

    //Add person model to Mixpanel
    private class func setPersonOnMixPanel(person: RBUser, action: Int) {

        guard let userId: Int = person.internalIdentifier else {
            return
        }

        if action == 1 { //0 = Login, 1 = Sign up
            Mixpanel.sharedInstance()?.createAlias("\(userId)", forDistinctID: (Mixpanel.sharedInstance()?.distinctId)!)
            Mixpanel.sharedInstance()?.identify((Mixpanel.sharedInstance()?.distinctId)!)
            Mixpanel.sharedInstance()?.people.set("$created", to: "\(NSDate())")

        } else {
            Mixpanel.sharedInstance()?.identify("\(userId)")
        }

        Mixpanel.sharedInstance()?.people.set("$email", to: person.userEmail())
        Mixpanel.sharedInstance()?.people.set("$name", to: person.userFullName())
        Mixpanel.sharedInstance()?.people.set("$phone", to: person.mobileNumber())
    }
}
