//
//  RBCardValidation.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 04/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import Stripe

struct ValidCard {
    var fullname: String
    var number: String
    var cvv: String
    var expiryYear: UInt
    var expiryMonth: UInt
}

struct CardValidation {

    var username: String?
    var cardNumber: String?
    var cvvNumber: String?
    var endDate: String?

    let errorInvalidName: Error = RBGenericMethods.createError(code: InputErrorCode.InvalidName.rawValue, message: "Enter a valid name")

    let errorInvalidCardNumber: Error = RBGenericMethods.createError(code: InputErrorCode.InvalidCardNumber.rawValue, message: "Enter a valid card number")

    let errorInvalidCVV: Error = RBGenericMethods.createError(code: InputErrorCode.InvalidCVV.rawValue, message: "Enter a valid cvv")

    let errorInvalidExpiry: Error = RBGenericMethods.createError(code: InputErrorCode.InvalidExpiry.rawValue, message: "Enter a valid expiry date")

    enum InputErrorCode: Int {
        case InvalidName = 0
        case InvalidCardNumber = 1
        case InvalidCVV = 2
        case InvalidExpiry = 3
    }

    func validateCard() throws -> ValidCard {

        guard let theName = self.username, theName.characters.count > 0 else {
            throw errorInvalidName
        }

        var theNumber: String = ""
        if let cardNumber: String = self.cardNumber, self.validateCardNumber(cardNumber) == true {
            theNumber = cardNumber
        } else {
            throw errorInvalidCardNumber
        }

        var expiryYear: UInt = 00
        var expiryMonth: UInt = 00
        if let theExpiry = self.endDate, self.validateExpiryDate(theExpiry) == true {

            let expirationDate: [String] = theExpiry.components(separatedBy: "/")
            let expMonth: UInt = UInt(Int(expirationDate[0])!)
            let expYear: UInt = UInt(Int(expirationDate[1])!)

            expiryMonth = expMonth
            expiryYear = expYear

        } else {
            throw errorInvalidExpiry
        }

        var theCVV: String = ""
        if let cVVNumber: String = self.cvvNumber, self.validateCVVNumber(cVVNumber) == true {
            theCVV = cVVNumber
        } else {
            throw errorInvalidCVV
        }

        return ValidCard(fullname: theName, number: theNumber, cvv: theCVV, expiryYear: expiryYear, expiryMonth: expiryMonth)
    }

    //MARK: - Private methods -
    private func validateCardNumber(_ cardNumberEntered: String?) -> Bool {

        var isCardNumberValid: Bool = false

        guard let cardNumber = cardNumberEntered, cardNumber.characters.count > 0 else {
            return isCardNumberValid
        }

        if STPCardValidator.stringIsNumeric(cardNumber) {

            let cardState: STPCardValidationState = STPCardValidator.validationState(forNumber: cardNumber, validatingCardBrand: true)

            switch cardState {

            case STPCardValidationState.valid:
                isCardNumberValid = true

            case STPCardValidationState.invalid, STPCardValidationState.incomplete:
                break
            }
        }

        return isCardNumberValid
    }

    private func validateExpiryDate(_ expiryDateEntered: String?) -> Bool {

        var isExpiryDateValid: Bool = false

        guard let expiryDate = expiryDateEntered, expiryDate.characters.count > 0 else {
            return isExpiryDateValid
        }

        let expirationDate: [String] = expiryDate.components(separatedBy: "/")

        if expirationDate.count == 2 {
            let expMonth: UInt = UInt(Int(expirationDate[0])!)
            let expYear: UInt = UInt(Int(expirationDate[1])!)

            let cardState: STPCardValidationState = STPCardValidator.validationState(forExpirationYear: String(expYear), inMonth: String(expMonth))

            switch cardState {

            case STPCardValidationState.valid:
                isExpiryDateValid = true

            case STPCardValidationState.invalid, STPCardValidationState.incomplete:
                break
            }
        }

        return isExpiryDateValid
    }

    private func validateCVVNumber(_ cVVNumberEntered: String?) -> Bool {

        var isCVVNumberValid: Bool = false

        guard let cVVNumber = cVVNumberEntered, cVVNumber.characters.count >= 3 else {
            return isCVVNumberValid
        }

        let cardBrand: STPCardBrand = STPCardValidator.brand(forNumber: cVVNumber)
        let cardState: STPCardValidationState = STPCardValidator.validationState(forCVC: cVVNumber, cardBrand: cardBrand)

        switch cardState {

        case STPCardValidationState.valid:
            isCVVNumberValid = true

        case STPCardValidationState.invalid, STPCardValidationState.incomplete:
            break
        }

        return isCVVNumberValid
    }
}
