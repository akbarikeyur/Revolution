//
//  AppDelegate+Notification.swift
//  TemplateApp
//
//  Created by Arvind Singh on 17/05/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import SwiftyStoreKit

extension AppDelegate {

    func completeIAPTransactions() {

        SwiftyStoreKit.completeTransactions(atomically: true) { products in

            for product in products {
                // swiftlint:disable:next for_where
                if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {

                    if product.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                    print("purchased: \(product.productId)")
                }

                // Pending transection during purchasing
                if product.transaction.transactionState == .purchasing {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }

            }
        }
    }

}
