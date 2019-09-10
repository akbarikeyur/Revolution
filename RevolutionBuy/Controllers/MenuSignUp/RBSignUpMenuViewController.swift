//
//  RBSignUpMenuViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 29/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSignUpMenuViewController: UIViewController {

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
    }

    //MARK: - IBActions -
    @IBAction func signupAction(sender: AnyObject) {
        self.pushToAgeConfirmation()
    }

    @IBAction func loginAction(sender: AnyObject) {
        self.pushToLoginController()
    }

    @IBAction func guestUserAction(sender: AnyObject) {
        if RBUserManager.sharedManager().isUserGuestUser() {
            self.dismiss(animated: true, completion: nil)
        } else {
            RBGenericMethods.askGuestUserPermission {
                RBUserManager.sharedManager().setGuestUser()
                AppDelegate.presentRootViewController(false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
