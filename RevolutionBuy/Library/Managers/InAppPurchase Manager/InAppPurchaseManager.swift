//
//  InAppPurchaseManager.swift
//
//  Created by Sourabh Bhardwaj on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Foundation
import StoreKit

class InAppPurchaseManager: NSObject {

    // MARK: - Constants
    struct Notifications {
        static let InAppProductPurchasedSuccessNotification = "InAppProductPurchasedSuccessNotification"
        static let InAppProductPurchasedFailedNotification = "InAppProductPurchasedFailedNotification"

        static let InAppProductRestoreSuccessNotification = "InAppProductRestoreSuccessNotification"
        static let InAppProductRestoreFailedNotification = "InAppProductRestoreFailedNotification"
    }

    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productIdentifiers: NSSet?
    typealias RequestProductsCompletionHandler = (_ error: NSError?, _ products: [SKProduct]?) -> ()
    typealias BuyProductsCompletionHandler = (_ error: NSError?) -> ()
    fileprivate var resultHandler: RequestProductsCompletionHandler?
    fileprivate var buyHandler: BuyProductsCompletionHandler?

    // MARK: - Singleton Instance
    fileprivate static let _sharedManager = InAppPurchaseManager()

    class func sharedManager() -> InAppPurchaseManager {
        return _sharedManager
    }

    fileprivate override init() {
        // customize initialization
        super.init()
    }

    // MARK: - Request Products
    func requestProducts(_ identifiers: NSSet, result: @escaping RequestProductsCompletionHandler) {

        guard let _: NSSet? = identifiers, identifiers.count > 0 else {
            return // do not proceed if no identifiers are provided
        }

        LogManager.logInfo("Checking products with iTunes Store")

        self.productIdentifiers = identifiers
        self.resultHandler = result

        self.productsRequest = SKProductsRequest.init(productIdentifiers: identifiers as! Set<String>)
        self.productsRequest?.delegate = self
        self.productsRequest?.start()
    }

    func buyProduct(_ product: SKProduct, quantity: NSInteger = 1, result: @escaping BuyProductsCompletionHandler) {
        self.buyHandler = result
        LogManager.logInfo("Purchase started..")

        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector.init(), name: Constants.InAppProductPurchasedSuccessNotification, object: product)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector.init(), name: Constants.InAppProductPurchasedFailedNotification, object: product)

        let payment: SKMutablePayment! = SKMutablePayment(product: product)
        payment.quantity = quantity
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }

    /**
     Can make payment using device

     - returns: NO if this device is not able or allowed to make payments
     */
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }

    // MARK: - Request Restore
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension InAppPurchaseManager: SKProductsRequestDelegate {

    // MARK: - Product Request Delegates
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        LogManager.logInfo("Loaded list of products...")
        LogManager.logInfo("Products = \(response.products)")
        LogManager.logInfo("Invalid products = \(response.invalidProductIdentifiers)")

        self.productsRequest = nil

        let skProducts = response.products
        if self.resultHandler != nil {
            self.resultHandler!(nil, skProducts)
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        //        Logger.logError("Failed to load list of products = \(error)");
        self.productsRequest = nil
        //        self.arrProducts = nil
        if self.resultHandler != nil {
            self.resultHandler!(error as NSError?, nil)
        }
    }
}

extension InAppPurchaseManager: SKPaymentTransactionObserver {

    // MARK: - Product Payment Delegates
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction: SKPaymentTransaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                transactionCompleted(transaction)

            case .failed:
                transactionFailed(transaction)

            default: // Purchasing
                LogManager.logInfo("Purchasing product in progress..")

            }
        }
    }

    fileprivate func transactionCompleted(_ transaction: SKPaymentTransaction) {
        self.buyHandler!(nil)
        LogManager.logInfo("transaction completed with \(transaction.transactionIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    fileprivate func transactionFailed(_ transaction: SKPaymentTransaction) {
        if transaction.error != nil {

            self.buyHandler!(NSError(domain: NSLocalizedString("InApp Purchase Failure", comment: "InApp Purchase Failure"), code: 408, userInfo: [NSLocalizedDescriptionKey: transaction.error!.localizedDescription]))
            SKPaymentQueue.default().finishTransaction(transaction)
        } else {
            self.buyHandler!(NSError(domain: NSLocalizedString("InApp Purchase Failure", comment: "InApp Purchase Failure"), code: 408, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Transaction failed.", comment: "Transaction failed.")]))
        }

        LogManager.logError("transaction failed with error \(transaction.error)")
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        LogManager.logInfo("Payment queue restore completed for transactions = \(queue.transactions)")
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        LogManager.logError("Payment queue restore failed = \(error)")
    }
}
