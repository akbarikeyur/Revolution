//
//  Int+NSTimeInterval.swift
//
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

/**
 NSTimeInterval conversion extensions
 */
public extension Int {

    var seconds: TimeInterval {
        return TimeInterval(self)
    }
    var minutes: TimeInterval {
        return 60 * self.seconds
    }
    var hours: TimeInterval {
        return 60 * self.minutes
    }
    var days: TimeInterval {
        return 24 * self.hours
    }
    var years: TimeInterval {
        return 365 * self.days
    }
}
