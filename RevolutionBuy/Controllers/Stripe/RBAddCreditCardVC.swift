//
//  RBAddCreditCardVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 04/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import Stripe

typealias CardAddCompletion = ((_ token: String) -> ())

class RBAddCreditCardVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var nameTextfield: RBCustomTextField!
    @IBOutlet weak var cardNumberTextField: RBCustomTextField!
    @IBOutlet weak var expiryTextfield: RBCustomTextField!
    @IBOutlet weak var cvvTextfield: RBCustomTextField!
    @IBOutlet var monthYearPicker: MonthYearPickerView!

    //MARK: - Variables
    var completion: CardAddCompletion?

    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.monthYearPicker.removeFromSuperview()
        self.expiryTextfield.inputView = self.monthYearPicker
        self.monthYearPicker.onDateSelected = { (month, year) in
            self.setDateInExpiryField(month: month, year: year)
        }
    }

    //MARK: - Clicks
    @IBAction func clickCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func clickContinue(_ sender: UIButton) {

        self.view.endEditing(true)

        let cardValidationObject: CardValidation = CardValidation(username: self.nameTextfield.text?.trimmed(), cardNumber: self.cardNumberTextField.text?.trimmed(), cvvNumber: self.cvvTextfield.text?.trimmed(), endDate: self.expiryTextfield.text?.trimmed())

        do {
            let aValidCard: ValidCard = try cardValidationObject.validateCard()
            self.validateCardDetailsOnStripe(aValidCard)
        } catch {
            self.handleCardValidationError(error: error)
        }
    }

    //MARK: - Private method
    private func handleCardValidationError(error: Error) {

        let errorCode = (error as NSError).code

        switch errorCode {
        case CardValidation.InputErrorCode.InvalidName.rawValue:
            self.nameTextfield.textFieldType = TextFieldType.warning
        case CardValidation.InputErrorCode.InvalidCardNumber.rawValue:
            self.cardNumberTextField.textFieldType = TextFieldType.warning
        case CardValidation.InputErrorCode.InvalidCVV.rawValue:
            self.cvvTextfield.textFieldType = TextFieldType.warning
        default:
            self.expiryTextfield.textFieldType = TextFieldType.warning
        }
        RBAlert.showWarningAlert(message: error.localizedDescription)
    }

    func setDateInExpiryField(month: Int, year: Int) {
        var monthMM: String = "\(month)"
        if month < 10 {
            monthMM = "0" + "\(month)"
        }

        let yearString: String = String(format: "%d", year)
        let yearYY: String = String(yearString.characters.suffix(2))

        self.expiryTextfield.text = "\(monthMM)/\(yearYY)"
    }
}

extension RBAddCreditCardVC {

    //validate fields on stripe
    fileprivate func validateCardDetailsOnStripe(_ validatedCard: ValidCard) {

        // Initiate the card
        let stripCard: STPCardParams = STPCardParams()
        stripCard.name = validatedCard.fullname
        stripCard.number = validatedCard.number
        stripCard.expMonth = validatedCard.expiryMonth
        stripCard.expYear = validatedCard.expiryYear
        stripCard.cvc = validatedCard.cvv

        //Check for network
        guard self.isInternetConnected() else {
            RBAlert.showWarningAlert(message: "Internet connection not available")
            return // do not proceed if user is not connected to internet
        }

        // Create card token from stripe sdk
        self.createStripeToken(cardParameter: stripCard)
    }

    //MARK: Generate Stripe token
    private func createStripeToken(cardParameter: STPCardParams) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: "Processing")

        STPAPIClient.shared().createToken(withCard: cardParameter, completion: { (token, error) -> Void in

            //Hide loader
            self.view.hideLoader()

            if error == nil, let cardToken: String = token?.tokenId {
                // Save card token to server
                self.dismiss(animated: true, completion: {
                    self.completion?(cardToken)
                })
            } else {
                if let errorText: String = error?.localizedDescription {
                    RBAlert.showWarningAlert(message: errorText)
                } else {
                    RBAlert.showWarningAlert(message: "Unable to authorize card")
                }
            }
        })
    }
}
