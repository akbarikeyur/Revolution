//
//  RBLoginViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 31/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBLoginViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var emailLoginTextField: RBCustomTextField!
    @IBOutlet weak var passwordLoginTextField: RBCustomTextField!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.openTermsAndConditionsLogin(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.termsAndConditionsLabel.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.emailLoginTextField.textFieldType = TextFieldType.accurate
        self.passwordLoginTextField.textFieldType = TextFieldType.accurate
        self.passwordLoginTextField.text = ""
    }

    //MARK: - IBActions -
    @IBAction func loginEmailAction(sender: AnyObject) {
        self.view.endEditing(true)
        self.confirmEmailLoginUserValidation()
    }

    @IBAction func loginFacebookAction(sender: AnyObject) {
        self.view.endEditing(true)

        // Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.facebookFetch.rawValue)

        FacebookManager.sharedManager().loginFromController(self, Handler: { (user, error) in
            // Hide loader
            self.view.hideLoader()

            if error == nil && user != nil {

                LogManager.logDebug("user = \(user)")
                self.validateFacebookLogin(loginSocialUser: user!)

            } else if let errorString = error?.localizedDescription {
                RBAlert.showWarningAlert(message: errorString)
            }

        })
    }

    @IBAction func forgotPasswordAction(sender: AnyObject) {
        self.view.endEditing(true)
        self.pushToForgotPasswordController(type: ForgotPasswordIdentifier.forgotPasswordScreenType.forgotPassword, facebookDictionary: nil)
    }

    @IBAction func loginBackAction(sender: AnyObject) {
        self.view.endEditing(true)
        if let navigationContoller: UINavigationController = self.navigationController, navigationContoller.viewControllers.count > 0 {
            for viewController in navigationContoller.viewControllers {
                if let controller: RBSignUpMenuViewController = viewController as? RBSignUpMenuViewController {
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // By signing up you agree to Revolution Buy’s Terms of Use and Privacy Policy.

    //MARK: - Private methods -
    @objc private func openTermsAndConditionsLogin(_ gestureRecognizer: UITapGestureRecognizer) {

        let textStorage = NSTextStorage(attributedString: termsAndConditionsLabel.attributedText!)
        let layoutManager = NSLayoutManager()

        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: termsAndConditionsLabel.bounds.size)
        textContainer.lineFragmentPadding = 0.0

        layoutManager.addTextContainer(textContainer)

        let location: CGPoint = gestureRecognizer.location(in: termsAndConditionsLabel)

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

extension RBLoginViewController: UITextFieldDelegate {

    //MARK: - Textfield delegate -
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        if let loginTextField: RBCustomTextField = textField as? RBCustomTextField {
            loginTextField.textFieldType = TextFieldType.accurate
        }
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == emailLoginTextField, let emailFieldCount: Int = textField.text?.characters.count, emailFieldCount >= 40, string != "" {
            return false
        }

        if textField == passwordLoginTextField, let passwordFieldCount: Int = textField.text?.characters.count, passwordFieldCount >= 15, string != "" {
            return false
        }

        return true
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailLoginTextField && emailLoginTextField.isFirstResponder {
            emailLoginTextField.resignFirstResponder()
            passwordLoginTextField.becomeFirstResponder()
        } else {
            passwordLoginTextField.resignFirstResponder()
            self.confirmEmailLoginUserValidation()
        }
        return true
    }

}

extension RBLoginViewController {

    //MARK: - Validate login -
    fileprivate func confirmEmailLoginUserValidation() {

        let emailUserLogin: UserRegistrationEmailModelValidation = UserRegistrationEmailModelValidation(email: self.emailLoginTextField.text?.trimmed(), password: self.passwordLoginTextField.text)

        do {
            let emailLoginUserModel: UserRegistrationEmailModel = try emailUserLogin.createEmailUser()
            LogManager.logDebug("Success! Person created. \(emailLoginUserModel)")
            self.callLoginEmailAPI(emailModel: emailLoginUserModel)

        } catch UserRegistrationEmailModelValidation.InputError.EnterEmail {

            self.emailLoginTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterEmail.rawValue, completion: nil)

        } catch UserRegistrationEmailModelValidation.InputError.EnterCorrectEmail {

            self.emailLoginTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterValidEmail.rawValue, completion: nil)

        } catch UserRegistrationEmailModelValidation.InputError.EnterPassword {

            self.passwordLoginTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterPassword.rawValue, completion: nil)

        } catch UserRegistrationEmailModelValidation.InputError.PasswordLength {

            self.passwordLoginTextField.textFieldType = TextFieldType.warning
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.passwordLength.rawValue, completion: nil)

        }
        catch {
            LogManager.logDebug("Any other error")
        }

    }

    fileprivate func validateFacebookLogin(loginSocialUser: SocialUser) {

        let socialValidation: SocialUserValidation = SocialUserValidation()
        do {

            let socialUserPamameter: [String: AnyObject] = try socialValidation.validateSocialUser(user: loginSocialUser)
            LogManager.logDebug("Success! Person created. \(socialUserPamameter)")
            self.callSocialLoginAPI(params: socialUserPamameter)

        } catch SocialUserValidation.InputError.underAge {

            FacebookManager.sharedManager().logout()
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.invalidAge.rawValue)

        } catch {
            LogManager.logDebug("Any other error")
        }

    }

}

extension RBLoginViewController {

    //MARK: - API call -
    fileprivate func callLoginEmailAPI(emailModel: UserRegistrationEmailModel) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.logingIn.rawValue)

        //Call API
        RBUserManager.sharedManager().loginWithEmail(email: emailModel.email, password: emailModel.password, completion: { (status, error, message, user) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == true && user != nil {

                if user?.isTemporaryPassword() == true {
                    self.pushToCreateNewPasswordController()
                } else if user?.isEmailVerified() == false {
                    RBInfoAlertView.showAlert(message: SignUpIdentifier.alert.unverifiedUser.rawValue, buttonTitle: SignUpIdentifier.title.gotIt.rawValue, onCompletion: {
                        self.pushToLoginController()
                    })
                } else if user?.isEmailVerified() == true && user?.hasUserCompletedProfile() == false {
                    self.addProfileContainerController()
                } else if user?.hasUserCompletedProfile() == true {
                    if RBUserManager.sharedManager().isUserGuestUser() == true {
                        RBUserManager.sharedManager().removeGuestUser()
                        self.moveUserToAppropriateScreenIfUserIsGuestUser()
                    } else {
                        AppDelegate.presentRootViewController()
                        AppDelegate.fetchUnreadNotificationCount()
                        //Track mixpanel event
                        AnalyticsManager.setDistictUserSuperProperties(type: AnalyticsIdentifier.userType.email.rawValue, action: 0, personModel: user)
                    }
                }

            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }
        })
    }

    fileprivate func callSocialLoginAPI(params: [String: AnyObject]) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.logingIn.rawValue)

        //Call API
        RBUserManager.sharedManager().socialLoginWithID(params, completion: { (status, error, message, user, isUserAlreadyExist) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == false && isUserAlreadyExist == false {

                //isUserAlreadyExist is false and will be returned if email is not found
                self.pushToForgotPasswordController(type: ForgotPasswordIdentifier.forgotPasswordScreenType.facebookEmail, facebookDictionary: params)

            } else if status == true && user != nil {

                if user?.hasUserCompletedProfile() == false {
                    self.addProfileContainerController()
                } else if RBUserManager.sharedManager().isUserGuestUser() == true {
                    RBUserManager.sharedManager().removeGuestUser()
                    self.moveUserToAppropriateScreenIfUserIsGuestUser()
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

    private func moveUserToAppropriateScreenIfUserIsGuestUser() {
        if let loginNavigationComtroller: RBMenuNavigationController = self.navigationController as? RBMenuNavigationController {
            loginNavigationComtroller.onSignUpCompletion(true)
        }
    }
}
