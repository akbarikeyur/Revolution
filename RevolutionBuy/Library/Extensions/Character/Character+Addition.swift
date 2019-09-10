//
//  Character+Addition.swift
//
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
// MARK: - Character Extension
public extension Character {

    /**
     If the character represents an integer that fits into an Int, returns
     the corresponding integer.
     */
    public func toInt() -> Int? {
        return Int(String(self))
    }
}
