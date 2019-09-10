
//
//  RBCreateNewPasswordViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 11/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBCreateNewPasswordViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var newPasswordTextField: RBCustomTextField!
    @IBOutlet weak var confirmPasswordTextField: RBCustomTextField!

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: - IBActions -
    @IBAction func createNewPasswordAction(sender: AnyObject) {
        self.view.endEditing(true)
        self.validateChangePasswordField()
    }

    @IBAction func createNewBackAction(sender: AnyObject) {
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RBCreateNewPasswordViewController: UITextFieldDelegate {

    //MARK: - Textfield delegate -
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if let createNewTextField: RBCustomTextField = textField as? RBCustomTextField {
            createNewTextField.textFieldType = TextFieldType.accurate
        }
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == newPasswordTextField || textField == confirmPasswordTextField, let createNewTextField: Int = textField.text?.characters.count, createNewTextField >= 15, string != "" {
            return false
        }

        return true
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension RBCreateNewPasswordViewController {

    //MARK: - Change password validation -
    fileprivate func validateChangePasswordField() {

        guard let newResetPassword: String = self.newPasswordTextField.text, newResetPassword.characters.count > 0 else {
            self.newPasswordTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterNewPassword.rawValue, completion: nil)
            return
        }

        if newResetPassword.characters.count <= 4 || newResetPassword.characters.count > 15 {
            self.newPasswordTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.passwordLength.rawValue, completion: nil)
            return
        }

        guard let confirmResetPassword: String = self.confirmPasswordTextField.text, confirmResetPassword.characters.count > 0 else {
            self.confirmPasswordTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterConfirmPassword.rawValue, completion: nil)
            return
        }

        if newResetPassword == confirmResetPassword {
            self.callChangePasswordAPICall(newPassword: newResetPassword)
        } else {
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.passwordUnmatched.rawValue, completion: nil)
        }
    }

    private func callChangePasswordAPICall(newPassword: String) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.generatingPassword.rawValue)

        //Call API
        RBUserManager.sharedManager().setNewPasswordPassword(newPassword) { (status, user, message, error) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == true, user != nil {

                if let accessToken: String = RBUserManager.sharedManager().activeUser.accessToken {
                    RBUserManager.sharedManager().activeUser = user!
                    RBUserManager.sharedManager().activeUser.accessToken = accessToken
                    RBUserManager.sharedManager().saveActiveUser()
                    AppDelegate.presentRootViewController()
                }
                RBAlert.showSuccessAlert(message: message, completion: nil)
            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }

        }
    }

}

