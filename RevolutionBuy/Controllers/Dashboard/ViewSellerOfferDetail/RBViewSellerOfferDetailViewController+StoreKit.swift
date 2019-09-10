//
//  RBViewSellerOfferDetailViewController+StoreKit.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 02/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension RBViewSellerOfferDetailViewController {

    //MARK: - Fetch Store Product
    func fetchStoreProduct(onCompletion: @escaping((_ fetchedProduct: SKProduct) -> ())) {
        self.view.showLoader(subTitle: "Fetching price...")
        let theSet: Set = Set.init([self.inAppProductIdentifier])
        RMStore.default().requestProducts(theSet, success: { (products, invalidProductIdentifiers) in
            self.view.hideLoader()
            if let fetchedProducts = products, fetchedProducts.count > 0, let theProduct: SKProduct = fetchedProducts[0] as? SKProduct {
                onCompletion(theProduct)
            } else {
                RBAlert.showWarningAlert(message: "Price unavailable at the moment.")
            }
        }) { (error) in
            self.view.hideLoader()
            RBAlert.showWarningAlert(message: self.errorMessageFromError(defaultMsg: "Fetching failed. Please try again.", error: error))
        }
    }

    //MARK: - Purchase Store Product
    func initiateProductPurchase(of product: SKProduct) {
        self.view.showLoader(subTitle: "Purchasing...")
        RMStore.default().addPayment(product.productIdentifier, success: { (transaction) in
            self.view.hideLoader()
            guard let theTransaction: SKPaymentTransaction = transaction else {
                RBAlert.showWarningAlert(message: "Invalid transaction. Try again.")
                return
            }
            self.handlePurchaseResponse(transaction: theTransaction)
        }) { (transaction, error) in
            self.view.hideLoader()
            RBAlert.showWarningAlert(message: self.errorMessageFromError(defaultMsg: "Purchasing failed. Please try again.", error: error))
        }
    }

    private func handlePurchaseResponse(transaction: SKPaymentTransaction) {
        //self.extractInAppReceipt()

        guard let updatedTransId: String = transaction.transactionIdentifier else {
            RBAlert.showWarningAlert(message: "Transaction identifier not found. Try again.")
            return
        }

        guard let receiptString: String = self.extractInAppReceiptString() else {
            RBAlert.showWarningAlert(message: "Transaction receipt not found. Try again.")
            return
        }

        if transaction.transactionState == SKPaymentTransactionState.purchased {
            let purchaseResponseObject: RBInAppPurchaseResponse = RBInAppPurchaseResponse.init(transactionId: updatedTransId, transactionReceiptString: receiptString, transaction: transaction)
            self.callAPIToUnlockSellerContactDetails(transactionResponse: purchaseResponseObject)
        } else {
            RBAlert.showWarningAlert(message: "Unable to purchase. Try again.")
        }
    }

    //MARK: - Extract Receipt
    private func extractInAppReceiptString() -> String? {
        if let receiptUrl = Bundle.main.appStoreReceiptURL {
            do {
                let receiptData = try Data.init(contentsOf: receiptUrl)
                let encodedData = receiptData.base64EncodedString()
                return encodedData
            } catch {
                return nil
            }
        }
        return nil
    }

    //MARK: - Error message
    private func errorMessageFromError(defaultMsg: String, error: Error?) -> String {
        if let errorMessage = error?.localizedDescription {
            return errorMessage
        }
        return defaultMsg
    }
}
