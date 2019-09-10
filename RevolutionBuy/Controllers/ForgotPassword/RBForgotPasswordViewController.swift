
//
//  RBForgotPasswordViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 11/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBForgotPasswordViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var emailTextField: RBCustomTextField!
    @IBOutlet weak var titleForgotLabel: RBCustomLabel!
    @IBOutlet weak var subtitleForgotLabel: RBCustomLabel!

    //MARK: - Variables -
    var forgotPasswordScreenWithType: ForgotPasswordIdentifier.forgotPasswordScreenType = ForgotPasswordIdentifier.forgotPasswordScreenType.forgotPassword
    var facebookDictionary: [String: AnyObject] = [String: AnyObject]()

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializeForgotPasswordClass()
    }

    //MARK: - Initialize class -
    private func initializeForgotPasswordClass() {

        switch forgotPasswordScreenWithType {

        case .forgotPassword:

            self.titleForgotLabel.text = ForgotPasswordIdentifier.title.forgot.rawValue
            self.subtitleForgotLabel.text = ForgotPasswordIdentifier.subtitle.forgot.rawValue

        case .facebookEmail:

            self.titleForgotLabel.text = ForgotPasswordIdentifier.title.facebook.rawValue
            self.subtitleForgotLabel.text = ForgotPasswordIdentifier.subtitle.facebook.rawValue
        }

    }

    //MARK: - IBActions -
    @IBAction func sendPasswordAction(sender: AnyObject) {
        self.view.endEditing(true)
        self.validateForgotPasswordField()
    }

    @IBAction func forgotBackAction(sender: AnyObject) {
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)

        if forgotPasswordScreenWithType == ForgotPasswordIdentifier.forgotPasswordScreenType.facebookEmail {
            FacebookManager.sharedManager().logout()
        }
    }

    fileprivate func moveToConfirmForgotPasswordAction() {
        let forgotConfirmationController: RBForgotConfirmationViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: forgotConfirmationIdentifier) as! RBForgotConfirmationViewController
        forgotConfirmationController.completionForgotConfirm = {
            _ = self.navigationController?.popViewController(animated: true)
        }
        self.present(forgotConfirmationController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RBForgotPasswordViewController: UITextFieldDelegate {

    //MARK: - Textfield delegate -
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if let forgotTextField: RBCustomTextField = textField as? RBCustomTextField {
            forgotTextField.textFieldType = TextFieldType.accurate
        }
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == emailTextField, let forgotTextField: Int = textField.text?.characters.count, forgotTextField >= 40, string != "" {
            return false
        }

        return true
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension RBForgotPasswordViewController {

    //MARK: - Forgot password API call -
    fileprivate func validateForgotPasswordField() {

        guard let email: String = self.emailTextField.text, email.characters.count > 0 else {
            self.emailTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterEmail.rawValue, completion: nil)
            return
        }

        if email.isValidEmail() == false {
            self.emailTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterValidEmail.rawValue, completion: nil)
            return
        }

        switch forgotPasswordScreenWithType {

        case .forgotPassword:

            self.callForgotPasswordAPICall(email: email)

        case .facebookEmail:

            self.callSocialSignUpEmilAPI(email: email)
        }
    }

    private func callForgotPasswordAPICall(email: String) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.generatingPassword.rawValue)

        //Call API
        RBUserManager.sharedManager().resetUserPassword(email) { (status, oldPassword, message, error) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == true {
                self.moveToConfirmForgotPasswordAction()
                RBAlert.showSuccessAlert(message: message, completion: nil)
            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }
        }
    }

    private func callSocialSignUpEmilAPI(email: String) {

        self.facebookDictionary.updateValue(email as AnyObject, forKey: "email")

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.logingIn.rawValue)

        //Call API
        RBUserManager.sharedManager().socialLoginWithID(self.facebookDictionary, completion: { (status, error, message, user, isUserAlreadyExist) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == true && user != nil {

                if user?.hasUserCompletedProfile() == false {
                    self.addProfileContainerController()
                } else if RBUserManager.sharedManager().isUserGuestUser() == true {
                    RBUserManager.sharedManager().removeGuestUser()
                    self.moveUserToAppropriateScreenIfUserIsGuestUserAfterSocialSignup()
                } else {
                    AppDelegate.presentRootViewController()
                }

            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }
        })
    }

    private func moveUserToAppropriateScreenIfUserIsGuestUserAfterSocialSignup() {
        if let loginNavigationComtroller: RBMenuNavigationController = self.navigationController as? RBMenuNavigationController {
            loginNavigationComtroller.onSignUpCompletion(true)
        }
    }
}
