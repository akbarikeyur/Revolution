//
//  RBAddCreditCardVC+textfieldDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 04/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBAddCreditCardVC: UITextFieldDelegate {

    // MARK: - text field delegate -
    internal   func textFieldDidBeginEditing(_ textField: UITextField) {
        if let theTxtField: RBCustomTextField = textField as? RBCustomTextField {
            theTxtField.textFieldType = TextFieldType.accurate
        }
    }

    internal  func textFieldDidEndEditing(_ textField: UITextField) {

        if let theTxtField: RBCustomTextField = textField as? RBCustomTextField {

            if theTxtField == self.expiryTextfield, let charactersCount = theTxtField.text?.characters.count, charactersCount == 0 {
                self.setDateInExpiryField(month: self.monthYearPicker.month, year: self.monthYearPicker.year)
            }

            let requiredlength: Int = self.textfieldRequiredLimit(textField)

            if let charactersCount = theTxtField.text?.characters.count, charactersCount < requiredlength {
                theTxtField.textFieldType = TextFieldType.warning
            }
        }
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Allow backspace always
        if string == "" {
            return true
        }

        // limit from 'self.textfieldMaximumLimit'
        if let theText = textField.text, theText.length < self.textfieldMaximumLimit(textField) {
            return self.validateForLimit(theText: theText, textField: textField, string: string)
        }

        return false
    }

    private func validateForLimit(theText: String, textField: UITextField, string: String) -> Bool {
        let characterCount = theText.length
        if textField == nameTextfield, characterCount >= self.textfieldRequiredLimit(textField) {
            let substringString: String = theText.substring(from: theText.index(theText.endIndex, offsetBy: -1))
            if substringString == " " && string == " " {
                return false
            }
        }

        // Allow alphabets in name only
        if textField == self.nameTextfield {
            let letters = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
            return string.rangeOfCharacter(from: letters) == nil
        }

        // For others, simply check max limit
        return true
    }

    private func textfieldRequiredLimit(_ textField: UITextField) -> Int {

        var requiredlength: Int = 1
        switch textField {
        case self.cardNumberTextField:
            requiredlength = 15
        case self.cvvTextfield:
            requiredlength = 3
        default :
            requiredlength = 1
        }
        return requiredlength
    }

    private func textfieldMaximumLimit(_ textField: UITextField) -> Int {

        var maxlength: Int = 100
        switch textField {
        case self.nameTextfield:
            maxlength = 40
        case self.cardNumberTextField:
            maxlength = 16
        case self.cvvTextfield:
            maxlength = 4
        default :
            maxlength = 100
        }
        return maxlength
    }
}
