//
//  RBSellerAccountViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 04/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

typealias AddStripeCompletion = ((_ success: Bool) -> (Void))

class RBSellerAccountViewController: UIViewController {

    //MARK: - Variable -
    var addStripeCompletion: AddStripeCompletion?

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func openSafariVC() {
        UIApplication.shared.open(URL(string: Constants.PAYMENT_API)!, options: [:]) { (isDone) in
            
        }
    }

    //MARK: - IBActions -
    @IBAction func skipSellerAccountAction(_ sender: AnyObject) {
        self.popToPreviousClass(withSuccess: false)
    }

    @IBAction func addSellerAccountSettingsAction(_ sender: AnyObject) {
     //   self.pushToAddStipeAccountController()
        openSafariVC()
    }

    func onSuccessfullCompletionAddingStripeAccount() {
        self.popToPreviousClass(withSuccess: true)
    }

    private func popToPreviousClass(withSuccess: Bool) {
        self.addStripeCompletion?(withSuccess)
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
