//
//  RBBuyerTransactionCompletePopupVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 01/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

typealias BuyerTransactionCompletion = (() -> Void)

class RBBuyerTransactionCompletePopupVC: UIViewController {

    //MARK: - Variables
    var parentController: UIViewController!
    var buyerTransactionCompletion: SellerTransactionCompletion?

    //MARK: - Class Methods
    class func showController(on parentController: UIViewController, completion: @escaping(() -> Swift.Void))  {
        let cont: RBBuyerTransactionCompletePopupVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: RBBuyerTransactionCompletePopupVC.storyboardIdentifier()) as! RBBuyerTransactionCompletePopupVC
        cont.parentController = parentController
        cont.parentController.present(cont, animated: true, completion: completion)
    }

    class func showControllerForNotification(on parentController: UIViewController, completion: @escaping(() -> Swift.Void))  {
        let cont: RBBuyerTransactionCompletePopupVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: RBBuyerTransactionCompletePopupVC.storyboardIdentifier()) as! RBBuyerTransactionCompletePopupVC
        cont.parentController = parentController
        cont.buyerTransactionCompletion = completion
        cont.parentController.present(cont, animated: true, completion: nil)
    }

    class func storyboardIdentifier() -> String {
        return "RBBuyerTransactionCompletePopupVC"
    }

    //MARK: - Clicks
    @IBAction func clickRate(_ sender: UIButton) {
        RBGenericMethods.promtToRateApp {
            self.buyerTransactionCompletion?()
            self.parentController.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func clickDismiss(_ sender: UIButton) {
        self.buyerTransactionCompletion?()
        self.parentController.dismiss(animated: true, completion: nil)
    }
}
