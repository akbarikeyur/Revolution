
//
//  RBForgotConfirmationViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 11/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

typealias ForgotConfirmHandler = (() -> Void)

class RBForgotConfirmationViewController: UIViewController {

    //MARK: - Variable -
    var completionForgotConfirm: ForgotConfirmHandler?

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - IBAction -
    @IBAction func confirmForgotPasswordAction(sender: AnyObject) {
        completionForgotConfirm?()
        self.dismiss(animated: true, completion: nil)
    }

}
