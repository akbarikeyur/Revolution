//
//  UIFont+Additions.swift
//
//  Created by Pawan Joshi on 12/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

// MARK: - UIFont Extension
extension UIFont {
    func helvaticaNewBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "helvetica", size: size)!
    }

    // Font - AvenirNext-Medium
    class func avenirNextMediun(_ size: CGFloat) -> UIFont {
        var customFont: UIFont = UIFont.systemFont(ofSize: size)
        if let avenirNext: UIFont = UIFont(name: "AvenirNext-Medium", size: size) {
            customFont = avenirNext
        }
        return customFont
    }

    // Font - AvenirNext-Regular
    class func avenirNextRegular(_ size: CGFloat) -> UIFont {
        var customFont: UIFont = UIFont.systemFont(ofSize: size)
        if let avenirNext: UIFont = UIFont(name: "AvenirNext-Regular", size: size) {
            customFont = avenirNext
        }
        return customFont
    }

}
