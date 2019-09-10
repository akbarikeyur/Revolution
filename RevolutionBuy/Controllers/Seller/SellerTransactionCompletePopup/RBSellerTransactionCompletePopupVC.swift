//
//  RBSellerTransactionCompletePopupVC.swift
//  RevolutionBuy
//
//  Created by Pankaj Pal on 11/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

typealias SellerTransactionCompletion = (() -> Void)

class RBSellerTransactionCompletePopupVC: UIViewController {

    //MARK: - Variables
    var parentController: UIViewController!
    var sellerTransactionCompletion: SellerTransactionCompletion?

    //MARK: - Class Methods
    class func showController(on parentController: UIViewController, completion: @escaping(() -> Swift.Void))  {
        let cont: RBSellerTransactionCompletePopupVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: RBSellerTransactionCompletePopupVC.storyboardIdentifier()) as! RBSellerTransactionCompletePopupVC
        cont.parentController = parentController
        cont.parentController.present(cont, animated: true, completion: completion)
    }

    class func showControllerForNotification(on parentController: UIViewController, completion: @escaping(() -> Swift.Void))  {
        let cont: RBSellerTransactionCompletePopupVC = UIStoryboard.sellerStoryboard().instantiateViewController(withIdentifier: RBSellerTransactionCompletePopupVC.storyboardIdentifier()) as! RBSellerTransactionCompletePopupVC
        cont.parentController = parentController
        cont.sellerTransactionCompletion = completion
        cont.parentController.present(cont, animated: true, completion: nil)
    }

    class func storyboardIdentifier() -> String {
        return "RBSellerTransactionCompletePopupVC"
    }

    //MARK: - Clicks
    @IBAction func clickRate(_ sender: UIButton) {
        RBGenericMethods.promtToRateApp {
            self.sellerTransactionCompletion?()
            self.parentController.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func clickDismiss(_ sender: UIButton) {
        self.sellerTransactionCompletion?()
        self.parentController.dismiss(animated: true, completion: nil)
    }
}
