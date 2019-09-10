//
//  UIButton+Additions.swift
//
//  Created by Geetika Gupta on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIButton Extension
extension UIButton {

    /**
     Override method of awake from nib to change font size as per aspect ratio.
     */
    override open func awakeFromNib() {

        super.awakeFromNib()
    }

    /**
     Make underline title
     */
    func underlineTitle() {

        if let buttonTitle = self.titleLabel?.text {
            let range = NSMakeRange(0, buttonTitle.length)
            underlineTitle(range)
        }
    }

    func underlineTitle(_ range: NSRange) {

        if let buttonTitle = self.titleLabel?.text {
            let titleString: NSMutableAttributedString = NSMutableAttributedString(string: buttonTitle)
            titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
            self.setAttributedTitle(titleString, for: UIControlState())
        }
    }

    func underlineTextInTitle(_ text: String) {
        underlineTextsInTitle(text)
    }

    func underlineTextsInTitle(_ texts: String...) {

        if let buttonTitle = self.titleLabel?.text {
            let titleString: NSMutableAttributedString = NSMutableAttributedString(string: buttonTitle)

            for text in texts {
                let range = (buttonTitle as NSString).range(of: text)
                titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
            }

            self.setAttributedTitle(titleString, for: UIControlState())
        }
    }

}
