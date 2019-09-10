//
//  RBViewSellerOfferDetailViewController+ContactCellDelegate.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 26/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBViewSellerOfferDetailViewController: RBMarkTransactionCompleteTableViewCellDelegate {

    internal func payViaCreditCardClicked() {

        guard let finalPrice: String = self.product.priceProductIncreasedByTenPercent() else {
            RBAlert.showWarningAlert(message: "Unable to generate final amount")
            return
        }

        var selectedCurrency = "AUD"
        var amountText: String = "Payment Amount" + selectedCurrency + " " + finalPrice + "\n"
        var descriptionWithCurrencyArray = self.product.description().components(separatedBy: "&&")
        if descriptionWithCurrencyArray.count > 1 {
            selectedCurrency = descriptionWithCurrencyArray[0] 
        }
        amountText = "Payment Amount " + selectedCurrency + " " + finalPrice + "\n" // Developer Commented
        
//        let amountText: String = "Payment Amount AU$" + finalPrice + "\n" // Developer Commented
        let alertText: String = "An additional 10 percent will be deducted from your card to make online payment."
        let finalText: String = amountText + alertText

        let confirmAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Proceed") {
            self.userConfirmedForOnlinePayment()
        }

        let declineAction: RBConfirmationButtonAttribute = RBConfirmationButtonAttribute.init(title: "Cancel", borderType: ConfirmationButtonType.BorderedOnly)

        RBAlert.showConfirmationAlert(message: finalText, leftButtonAttributes: declineAction, rightButtonAttributes: confirmAction)
    }

    private func userConfirmedForOnlinePayment() {
        if let sellerUserModel: RBUser = self.product.user, sellerUserModel.hasSellerConnectedAccount() == true {
            
            callAPItoMakeOnlinePaymentByPayPal()

            
//            self.presentPayViaCreditCard(with: { (token) in
//             //   self.callAPItoMakeOnlinePaymentByStripeToken(token: token)
//            })
            
            
        } else {
            RBAlert.showWarningAlert(message: "Seller of this product has not added his account details to receive online payments")
        }
        
        
    }

    internal func markCompleteClicked() {
        RBGenericMethods.showMarkTransactionCompleteProceedPrompt {
            self.callAPIToCompleteTransactionFromBuyer()
        }
    }

    internal func callClicked() {
        let number: String = self.product.sellerNumber()
        RBGenericMethods.promtToMakeCall(phoneNumber: number)
    }

    internal func whatsThisClicked(selected: Bool) {
        self.isShowingWhatsThis = selected
        if let index = self.tableDataSource.index(of: kCellIdentifierSellerContact), index != NSNotFound {
            let lastIndexpath: IndexPath = IndexPath(row: index, section: 0)
            self.tblItemDetails.reloadRows(at: [lastIndexpath], with: .none)
            self.tblItemDetails.scrollToRow(at: lastIndexpath, at: .bottom, animated: true)
        }
    }
}
