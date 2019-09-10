//
//  NSDate+Comparison.swift
//
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

public extension Date {

    /**
     Checks if self is after input NSDate

     - parameter date: NSDate to compare
     - returns: True if self is after the input NSDate, false otherwise
     */
    public func isAfter(_ date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedDescending
    }

    /**
     Checks if self is before input NSDate

     - parameter date: NSDate to compare
     - returns: True if self is before the input NSDate, false otherwise
     */
    public func isBefore(_ date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedAscending
    }
}
