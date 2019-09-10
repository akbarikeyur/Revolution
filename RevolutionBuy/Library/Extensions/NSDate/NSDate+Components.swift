//
//  NSDate+Components.swift
//
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

public extension Date {

    // MARK: Getter

    /**
     Date year
     */
    public var year: Int {
        get {
            return getComponent(.year)
        }
    }

    /**
     Date month
     */
    public var month: Int {
        get {
            return getComponent(.month)
        }
    }

    /**
     Date weekday
     */
    public var weekday: Int {
        get {
            return getComponent(.weekday)
        }
    }

    /**
     Date weekMonth
     */
    public var weekMonth: Int {
        get {
            return getComponent(.weekOfMonth)
        }
    }

    /**
     Date days
     */
    public var days: Int {
        get {
            return getComponent(.day)
        }
    }

    /**
     Date hours
     */
    public var hours: Int {

        get {
            return getComponent(.hour)
        }
    }

    /**
     Date minuts
     */
    public var minutes: Int {
        get {
            return getComponent(.minute)
        }
    }

    /**
     Date seconds
     */
    public var seconds: Int {
        get {
            return getComponent(.second)
        }
    }

    /**
     Returns the value of the NSDate component

     - parameter component: NSCalendarUnit
     - returns: the value of the component
     */

    public func getComponent(_ component: NSCalendar.Unit) -> Int {
        let calendar = Calendar.current
        let components: NSDateComponents = (calendar as NSCalendar).components(component, from: self) as NSDateComponents

        return components.value(forComponent: component)
    }
    /**
     Returns the value of the NSDate component

     - returns: the value of the component
     */
    public func components() -> DateComponents {
        return (Calendar.current as NSCalendar).components([.era, .year, .month, .weekOfYear, .weekOfMonth, .weekday, .weekdayOrdinal, .day, .hour, .minute, .second], from: self)
    }
}
