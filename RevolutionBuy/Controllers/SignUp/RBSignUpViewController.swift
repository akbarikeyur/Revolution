//
//  RBSignUpViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 30/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBSignUpViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var emailTextField: RBCustomTextField!
    @IBOutlet weak var passwordTextField: RBCustomTextField!
    @IBOutlet weak var termsLabel: UILabel!

    //MARK: - Variables -
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.openTermsAndConditions(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.termsLabel.addGestureRecognizer(tapGesture)
    }

    //MARK: - IBActions -
    @IBAction func signUpEmailAction(sender: AnyObject) {
        self.view.endEditing(true)
        self.confirmEmailUserValidation()
    }

    @IBAction func signUpFacebookAction(sender: AnyObject) {
        self.view.endEditing(true)
        // Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.facebookFetch.rawValue)
        FacebookManager.sharedManager().loginFromController(self, Handler: { (user, error) in
            // Hide loader
            self.view.hideLoader()
            if error == nil && user != nil {
                print(user)
                LogManager.logDebug("user = \(user)")
                self.validateFacebookSignup(loginSocialUser: user!)

            } else if let errorString = error?.localizedDescription {
                RBAlert.showWarningAlert(message: errorString)
            }
        })
    }

    @IBAction func signUpBackAction(sender: AnyObject) {
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Private methods -
    @objc private func openTermsAndConditions(_ gestureRecognizer: UITapGestureRecognizer) {

        let textStorage = NSTextStorage(attributedString: termsLabel.attributedText!)
        let layoutManager = NSLayoutManager()

        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: termsLabel.bounds.size)
        textContainer.lineFragmentPadding = 0.0

        layoutManager.addTextContainer(textContainer)

        let location: CGPoint = gestureRecognizer.location(in: termsLabel)

        let characterIndex: UInt = UInt(layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil))

        //Terms and Conditions
        if characterIndex > 43 && characterIndex < 57 {
            pushToTermsController(type: TermsIdentifier.TermsType.Terms, viaSettings: false)
        }

        //Privacy Policy
        if characterIndex > 60 && characterIndex < 76 {
            pushToTermsController(type: TermsIdentifier.TermsType.Privacy, viaSettings: false)
        }
    }
}

extension RBSignUpViewController {

    //MARK: - Validate Signup -
    fileprivate func confirmEmailUserValidation() {

        let emailUser: UserRegistrationEmailModelValidation = UserRegistrationEmailModelValidation(email: self.emailTextField.text?.trimmed(), password: self.passwordTextField.text)

        do {
            let emailUserModel: UserRegistrationEmailModel = try emailUser.createEmailUser()
            LogManager.logDebug("Success! Person created. \(emailUserModel)")
            self.createSignUpEmailParameters(emailModel: emailUserModel)

        } catch UserRegistrationEmailModelValidation.InputError.EnterEmail {

            self.emailTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterEmail.rawValue, completion: nil)

        } catch UserRegistrationEmailModelValidation.InputError.EnterCorrectEmail {

            self.emailTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterValidEmail.rawValue, completion: nil)

        } catch UserRegistrationEmailModelValidation.InputError.EnterPassword {

            self.passwordTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterPassword.rawValue, completion: nil)

        } catch UserRegistrationEmailModelValidation.InputError.PasswordLength {

            self.passwordTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.passwordLength.rawValue, completion: nil)

        }
        catch {
            LogManager.logDebug("Any other error")
        }

    }

    fileprivate func validateFacebookSignup(loginSocialUser: SocialUser) {

        let socialSignupValidation: SocialUserValidation = SocialUserValidation()

        do {

            let socialUserPamameter: [String: AnyObject] = try socialSignupValidation.validateSocialUser(user: loginSocialUser)
            LogManager.logDebug("Success! Person created. \(socialUserPamameter)")
            self.callSocialSignUpAPI(parameter: socialUserPamameter)

        } catch SocialUserValidation.InputError.underAge {

            FacebookManager.sharedManager().logout()
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.invalidAge.rawValue)

        } catch {
            LogManager.logDebug("Any other error")
        }
    }

}

extension RBSignUpViewController: UITextFieldDelegate {

    //MARK: - Textfield delegate -
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if let signUpTextField: RBCustomTextField = textField as? RBCustomTextField {
            signUpTextField.textFieldType = TextFieldType.accurate
        }
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == emailTextField, let emailTextFieldCount: Int = textField.text?.characters.count, emailTextFieldCount >= 40, string != "" {
            return false
        }

        if textField == passwordTextField, let passwordTextFieldCount: Int = textField.text?.characters.count, passwordTextFieldCount >= 15, string != "" {
            return false
        }

        return true
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField && emailTextField.isFirstResponder {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            self.confirmEmailUserValidation()
        }
        return true
    }

}

extension RBSignUpViewController {

    //MARK: - API Call -
    fileprivate func createSignUpEmailParameters(emailModel: UserRegistrationEmailModel) {

        //Create email Signup parameter
        var emailSignUpParameters: [String: AnyObject] = [String: AnyObject]()
        emailSignUpParameters.updateValue(emailModel.email as AnyObject, forKey: "email")
        emailSignUpParameters.updateValue(emailModel.password as AnyObject, forKey: "password")
        emailSignUpParameters.updateValue(AppDelegate.delegate().deviceToken() as AnyObject, forKey: "deviceToken")
        emailSignUpParameters.updateValue(deviceID() as AnyObject, forKey: "deviceId")
        emailSignUpParameters.updateValue(DEVICE_TYPE as AnyObject, forKey: "deviceType")

        //Email API
        self.callSignUpEmailAPI(parameter: emailSignUpParameters)
    }

    fileprivate func callSignUpEmailAPI(parameter: [String: AnyObject]) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.signingUp.rawValue)

        //Call API
        RBUserManager.sharedManager().registerWithEmail(parameter) { (status, error, message, user) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == true && user != nil {

                if user?.isEmailVerified() == false {
                    RBInfoAlertView.showAlert(message: SignUpIdentifier.alert.verifyEmail.rawValue, buttonTitle: SignUpIdentifier.title.gotIt.rawValue, onCompletion: {
                        self.pushToLoginController()
                    })
                }

            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }
        }
    }

    fileprivate func callSocialSignUpAPI(parameter: [String: AnyObject]) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.logingIn.rawValue)

        //Call API
        RBUserManager.sharedManager().socialLoginWithID(parameter, completion: { (status, error, message, user, isUserAlreadyExist) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == false && isUserAlreadyExist == false {

                //isUserAlreadyExist is false and will be returned if email is not found
                self.pushToForgotPasswordController(type: ForgotPasswordIdentifier.forgotPasswordScreenType.facebookEmail, facebookDictionary: parameter)

            } else if status == true && user != nil {

                if user?.hasUserCompletedProfile() == false {
                    self.addProfileContainerController()
                } else if RBUserManager.sharedManager().isUserGuestUser() == true {
                    RBUserManager.sharedManager().removeGuestUser()
                    self.moveUserToAppropriateScreenIfUserIsGuestUserSocialLogin()
                } else {
                    AppDelegate.presentRootViewController()
                    AppDelegate.fetchUnreadNotificationCount()
                    //Track mixpanel event
                    AnalyticsManager.setDistictUserSuperProperties(type: AnalyticsIdentifier.userType.facebook.rawValue, action: 0, personModel: user)
                }

            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }
        })
    }

    private func moveUserToAppropriateScreenIfUserIsGuestUserSocialLogin() {
        if let loginNavigationComtroller: RBMenuNavigationController = self.navigationController as? RBMenuNavigationController {
            loginNavigationComtroller.onSignUpCompletion(true)
        }
    }
}
