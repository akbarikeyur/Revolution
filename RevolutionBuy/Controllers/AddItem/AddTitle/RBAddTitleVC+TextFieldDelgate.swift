//
//  RBAddTitleVC+TextFieldDelgate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 06/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBAddTitleVC: UITextFieldDelegate {

    //MARK: - Textfield delegate -
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if let theTextField: RBCustomTextField = textField as? RBCustomTextField {
            theTextField.textFieldType = TextFieldType.accurate
        }
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == self.titleTextField {

            if let characterCount = textField.text?.length, characterCount >= 30, string != "" {
                return false
            }

            if let characterCount = textField.text?.length, characterCount == 0, string == " " {
                return false
            }
        }

        return true
    }
}
