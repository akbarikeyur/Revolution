//
//  UITextField+Additions.swift
//
//  Created by Geetika Gupta on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITextField Extension
extension UITextField {

    /**
     Override method of awake from nib to change font size as per aspect ratio.
     */
    override open func awakeFromNib() {
        super.awakeFromNib()
    }

    func isTextFieldEmpty() -> Bool {

        if let str = self.text /*self.textByTrimmingWhiteSpacesAndNewline()*/ {
            return str.length == 0
        }
        return true
    }

    func textByTrimmingWhiteSpacesAndNewline() -> String {

        self.trimWhiteSpacesAndNewline()

        guard let _ = self.text else {
            return ""
        }
        return self.text!
    }

    func trimWhiteSpacesAndNewline() {
        let whitespaceAndNewline: CharacterSet = CharacterSet.whitespacesAndNewlines
        let trimmedString: String? = self.text?.trimmingCharacters(in: whitespaceAndNewline)
        self.text = trimmedString
    }

    // MARK: Control Actions
    @IBAction func toggleSecureText() {
        self.isSecureTextEntry = !self.isSecureTextEntry
    }
}
