//
//  RBChangePasswordViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 21/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBChangePasswordViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var currentPasswordTextField: RBCustomTextField!
    @IBOutlet weak var newPasswordTextField: RBCustomTextField!
    @IBOutlet weak var confirmPasswordTextField: RBCustomTextField!

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - IBAction -
    @IBAction func backChangePasswordAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func changePasswordAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.validateChangePasswordAction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RBChangePasswordViewController: UITextFieldDelegate {

    //MARK: - Textfield delegate -
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if let changePasswordTextField: RBCustomTextField = textField as? RBCustomTextField {
            changePasswordTextField.textFieldType = TextFieldType.accurate
        }
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == currentPasswordTextField || textField == newPasswordTextField || textField == confirmPasswordTextField, let createNewTextField: Int = textField.text?.characters.count, createNewTextField >= 15, string != "" {
            return false
        }

        return true
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == currentPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            confirmPasswordTextField.resignFirstResponder()
            self.validateChangePasswordAction()
        }

        return true
    }
}

extension RBChangePasswordViewController {

    //MARK: - Validate change password -
    fileprivate func validateChangePasswordAction() {

        guard let currentPassword: String = self.currentPasswordTextField.text, currentPassword.characters.count > 0 else {
            self.currentPasswordTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.currentPassword.rawValue, completion: nil)
            return
        }

        guard let newPassword: String = self.newPasswordTextField.text, newPassword.characters.count > 0 else {
            self.newPasswordTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterNewPassword.rawValue, completion: nil)
            return
        }

        if newPassword.characters.count <= 4 || newPassword.characters.count > 15 {
            self.newPasswordTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.passwordLength.rawValue, completion: nil)
            return
        }

        guard let confirmPassword: String = self.confirmPasswordTextField.text, confirmPassword.characters.count > 0 else {
            self.confirmPasswordTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterConfirmPassword.rawValue, completion: nil)
            return
        }

        if newPassword != confirmPassword {
            self.confirmPasswordTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.passwordUnmatched.rawValue, completion: nil)
            return
        }

        self.callChangePasswordAPI(oldpassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword)
    }

    private func callChangePasswordAPI(oldpassword: String, newPassword: String, confirmPassword: String) {

        //Show loader
        self.view.showLoader(subTitle: "Updating\nPassword")

        //Call change password api
        RBUser.changePassword(oldpassword, newPassword: newPassword, confirmPassword: confirmPassword) { (status, error, message) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == true {
                _ = self.navigationController?.popViewController(animated: true)
                RBAlert.showSuccessAlert(message: message)
            } else {
                RBAlert.showWarningAlert(message: message)
            }

        }
    }
}
