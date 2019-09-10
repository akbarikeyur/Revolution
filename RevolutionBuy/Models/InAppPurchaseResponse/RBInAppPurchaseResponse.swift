//
//  RBInAppPurchaseResponse.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 03/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBInAppPurchaseResponse: NSObject {

    var transactionId: String!
    var transactionReceiptString: String!
    var transaction: SKPaymentTransaction!

    init(transactionId: String, transactionReceiptString: String, transaction: SKPaymentTransaction) {
        self.transactionId = transactionId
        self.transactionReceiptString = transactionReceiptString
        self.transaction = transaction
    }
}
