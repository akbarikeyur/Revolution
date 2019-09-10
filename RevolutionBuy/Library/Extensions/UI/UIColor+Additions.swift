//
//  UIColor+Additions.swift
//
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor Extension
extension UIColor {

    /**
     Get RGB value and convert values into color.

     - parameter redValue:   CGFloat of red color
     - parameter greenValue: CGFloat of green color
     - parameter blueValue:  CGFloat of blue color
     - parameter alpha:      CGFloat of alpha

     - returns: UIColor from RGB
     */

    func colorWithRedValue(_ redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {

        return UIColor(red: redValue / 255.0, green: greenValue / 255.0, blue: blueValue / 255.0, alpha: alpha)
    }

    /**
     Get RGB value and convert values into color.

     - parameter rgbValue: UInt value of RGB
     - parameter alpha:    CGFloat of alpha

     - returns: UIColor from RGB
     */
    func colorWithRGB(_ rgbValue: UInt, alpha: CGFloat = 1.0) -> UIColor {

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255
        let blue = CGFloat(rgbValue & 0xFF) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    /**
     Get hexa value of color with alpha value of 1
     Convert hexa value into RGB and get color.

     - parameter hexColorCode: String of hexa code

     - returns: UIColor from hexa color
     */
    convenience init(hexColorCode: String) {

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0

        if hexColorCode.hasPrefix("#") {

            let index = hexColorCode.characters.index(hexColorCode.startIndex, offsetBy: 1)
            let hex = hexColorCode.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0

            if scanner.scanHexInt64(&hexValue) {

                if hex.characters.count == 6 {

                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if hex.characters.count == 8 {

                    red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF) / 255.0
                } else {

                    print("invalid hex code string, length should be 7 or 9", terminator: "")
                }
            } else {
                print("scan hex error")
            }
        } else {

            print("invalid hex code string, missing '#' as prefix", terminator: "")
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /**
     Get hexa value of color with given hexa value
     Convert hexa value into RGB and get color.

     - parameter hexColorCode: String of hexa code
     - parameter alpha:        CGFloat  of alpha

     - returns: UIColor from hex color code and alpha
     */
    convenience init(hexColorCode: String, alpha: CGFloat) {

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = alpha

        if hexColorCode.hasPrefix("#") {

            let index = hexColorCode.characters.index(hexColorCode.startIndex, offsetBy: 1)
            let hex = hexColorCode.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0

            if scanner.scanHexInt64(&hexValue) {

                if hex.characters.count == 6 {

                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if hex.characters.count == 8 {

                    red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF) / 255.0
                } else {

                    print("invalid hex code string, length should be 7 or 9", terminator: "")
                }
            } else {

                print("scan hex error")
            }
        } else {

            print("invalid hex code string, missing '#' as prefix", terminator: "")
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
