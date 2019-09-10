//
//  RBSendOfferCell.swift
//  RevolutionBuy
//
//  Created by Hemant Sharma on 31/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSendOfferCell: UITableViewCell, UITextFieldDelegate {

    let descriptionMaxLimit = 255

    let ACCEPTABLE_PRICE_CHARACTERS = "0123456789."
    let placeholder: String = "Describe your item here"

    @IBOutlet weak var txtvwItemDescription: UITextView!
    @IBOutlet weak var txtfPrice: RBCustomTextField!
    @IBOutlet weak var btnSelectCurrency: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        txtvwItemDescription.layer.borderColor = UIColor(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0).cgColor
        txtvwItemDescription.layer.borderWidth = 0.8
        txtvwItemDescription.layer.cornerRadius = 4.0
        txtvwItemDescription.layer.masksToBounds = true

        txtvwItemDescription.textContainerInset = UIEdgeInsetsMake(16, 16, 16, 16)

        txtvwItemDescription.placeholder = placeholder
        txtvwItemDescription.delegate = self
        txtfPrice.delegate = self
        
        btnSelectCurrency.layer.cornerRadius = 4.0
        btnSelectCurrency.layer.masksToBounds = true
        btnSelectCurrency.layer.borderColor = UIColor(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0).cgColor
        btnSelectCurrency.layer.borderWidth = 0.8
        btnSelectCurrency.layer.cornerRadius = 4.0
        btnSelectCurrency.layer.masksToBounds = true

    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string == "" {
            return true
        }
        
        var shouldReturn = false
        if let theText : NSString = textField.text as NSString? {
            let finalString = theText.replacingCharacters(in: range, with: string)
            let expression = "^[0-9]{0,8}(\\.[0-9]{0,2})?$"
            do {
                let regex : NSRegularExpression = try NSRegularExpression.init(pattern: expression, options: .caseInsensitive)
                let numOfMatches = regex.numberOfMatches(in: finalString, options: .anchored, range: NSRange.init(location: 0, length: finalString.length))
                shouldReturn = numOfMatches != 0
            } catch {
                RBAlert.showWarningAlert(message: error.localizedDescription)
            }
        }
        return shouldReturn
    }
}

extension RBSendOfferCell {

    // MARK: - Textfield delegate

    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if let priceTextField: RBCustomTextField = textField as? RBCustomTextField {
            priceTextField.textFieldType = TextFieldType.accurate
        }
    }
}

extension RBSendOfferCell: UITextViewDelegate {
    // MARK: - Textview delegate
    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return RBGenericMethods.evaluateDescriptionTextView(textView, shouldChangeTextIn: range, replacementText: text, descriptionMaxLimit: self.descriptionMaxLimit)
    }
}
