//
//  RBVerifyMobileViewController.swift
//  RevolutionBuy
//
//  Created by Sandeep Kumar on 03/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBVerifyMobileViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var firstOTPLetterTextField: RBCustomTextField!
    @IBOutlet weak var secondOTPLetterTextField: RBCustomTextField!
    @IBOutlet weak var thirdOTPLetterTextField: RBCustomTextField!
    @IBOutlet weak var fourthOTPLetterTextField: RBCustomTextField!

    //MARK: - Variables -
    var userSignUpModel: UserAddProfileModel?
    var isUserViaSettings: Bool = false

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializeVerifyMobileClass()
    }

    private func initializeVerifyMobileClass() {

        //Textfield type
        self.firstOTPLetterTextField.font =  UIFont.avenirNextRegular(17.0)
        self.secondOTPLetterTextField.font =  UIFont.avenirNextRegular(17.0)
        self.thirdOTPLetterTextField.font =  UIFont.avenirNextRegular(17.0)
        self.fourthOTPLetterTextField.font =  UIFont.avenirNextRegular(17.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - IBAction -
    @IBAction func verfiyMobileAction(sender: AnyObject) {
        self.view.endEditing(true)
        self.validateMobileOTP()
    }

    @IBAction func resendPinAction(sender: AnyObject) {
        self.view.endEditing(true)
        if let mobileNumberUser: String = self.userSignUpModel?.mobileNumber {
            self.callResendMobileOTP(mobileNumber: mobileNumberUser)
        }
    }

    @IBAction func verfiyMobileBackAction(sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension RBVerifyMobileViewController {

    //MARK: - Validate mobile OTP -
    fileprivate func validateMobileOTP() {

        guard let firstString: String = self.firstOTPLetterTextField.text?.trimmed(), firstString.characters.count > 0, let secondString: String = self.secondOTPLetterTextField.text?.trimmed(), secondString.characters.count > 0, let thirdString: String = self.thirdOTPLetterTextField.text?.trimmed(), thirdString.characters.count > 0, let fourthString: String = self.fourthOTPLetterTextField.text?.trimmed(), fourthString.characters.count > 0 else {
            self.showWarningOnInvalidOTP()
            RBAlert.showWarningAlert(message: SignUpIdentifier.alert.enterPin.rawValue, completion: nil)
            return
        }

        let otpEntered: String = firstString + secondString + thirdString + fourthString

        if let signUpAddProfilUserModel: UserAddProfileModel = self.userSignUpModel {

            if isUserViaSettings == true {
                self.verifyMobileOTPForChangedMobileNumber(signUpModel: signUpAddProfilUserModel, otpEntered: otpEntered)
            } else {
                self.callVerifyMobileOTP(signUpModel: signUpAddProfilUserModel, otpEntered: otpEntered)
            }
        }
    }

    private func showWarningOnInvalidOTP() {
        self.firstOTPLetterTextField.textFieldType = TextFieldType.warning
        self.secondOTPLetterTextField.textFieldType = TextFieldType.warning
        self.thirdOTPLetterTextField.textFieldType = TextFieldType.warning
        self.fourthOTPLetterTextField.textFieldType = TextFieldType.warning
        self.firstOTPLetterTextField.text = ""
        self.secondOTPLetterTextField.text = ""
        self.thirdOTPLetterTextField.text = ""
        self.fourthOTPLetterTextField.text = ""
    }

    //MARK: - API Call Signup user -
    fileprivate func callVerifyMobileOTP(signUpModel: UserAddProfileModel, otpEntered: String) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.verifyingPin.rawValue)

        //Call API
        RBUser.addUserProfileWithPinAPI(signUpModel, otpEntered: otpEntered) { (status, error, message, userModel) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == true && userModel != nil {

                if RBUserManager.sharedManager().isUserGuestUser() == true {
                    RBUserManager.sharedManager().removeGuestUser()
                    self.moveUserToAppropriateScreenAfterVerifyingPIN()
                } else {
                    AppDelegate.presentRootViewController()
                }
                //Track mixpanel event
                self.trackMixpanelEventSignUpUser(userModel: userModel!)
                RBAlert.showSuccessAlert(message: SignUpIdentifier.alert.profileSetUp.rawValue)
            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
                self.showWarningOnInvalidOTP()
            }
        }
    }

    //MARK: - API Call resend mobile pin -
    fileprivate func callResendMobileOTP(mobileNumber: String) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.resendOTP.rawValue)

        //Call API
        RBUserManager.sharedManager().generateOTPAPI(mobileNumber) { (status, error, message) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == true {
                RBAlert.showSuccessAlert(message: message)
            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
            }
        }
    }

    //MARK: - API Call verify change pin -
    fileprivate func verifyMobileOTPForChangedMobileNumber(signUpModel: UserAddProfileModel, otpEntered: String) {

        //Show loader
        self.view.showLoader(mainTitle: "", subTitle: SignUpIdentifier.identifier.verifyingPin.rawValue)

        //Call API
        RBUserManager.sharedManager().otpVerifyForChangedMobileNumber(signUpModel.mobileNumber, oneTimePassword: otpEntered) { (status, error, message) -> (Void) in

            //Hide loader
            self.view.hideLoader()

            if status == true {
                RBAlert.showSuccessAlert(message: message)
                self.moveToSettingsClass()
            } else {
                RBAlert.showWarningAlert(message: message, completion: nil)
                self.showWarningOnInvalidOTP()
            }
        }
    }

    //Move to settings class after updating mobile number
    private func moveToSettingsClass() {
        if let currentNavigationController: UINavigationController = self.navigationController, currentNavigationController.viewControllers.count > 0 {
            for viewController in currentNavigationController.viewControllers {
                if let settingsController: RBSettingsViewController = viewController as? RBSettingsViewController {
                    _ = currentNavigationController.popToViewController(settingsController, animated: true)
                }
            }
        }
    }

    //Move to last controller when user sign up via email completed
    private func moveUserToAppropriateScreenAfterVerifyingPIN() {
        if let addProfileNavigation: UINavigationController = self.navigationController, let addProfileContainerView: RBAddProfileContainerViewController = addProfileNavigation.view.superview?.viewController() as? RBAddProfileContainerViewController, let signUpMenuNavigationController: RBMenuNavigationController = addProfileContainerView.navigationController as? RBMenuNavigationController {
            signUpMenuNavigationController.onSignUpCompletion(true)
        }
    }
}

extension RBVerifyMobileViewController: UITextFieldDelegate {

    //MARK: - Textfield delegate -
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setTextFieldFilled(textField)
    }

    internal func textFieldDidEndEditing(_ textField: UITextField) {
        self.changeValidationTextfieldColor()
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        var shouldProcess: Bool = false //default to reject
        var shouldMoveToNextField: Bool = false //default to remaining on the current field

        let insertStringLength: Int = string.length

        //Process if the backspace character was pressed
        //Process if there is only 1 character right now
        if insertStringLength == 0 || textField.text?.length == 0 { //backspace
            shouldProcess = true
        }

        //here we deal with the UITextField on our own
        if shouldProcess {
            //grab a mutable copy of what's currently in the UITextField
            let mstring: NSMutableString = NSMutableString.init(string: textField.text!)

            if mstring.length == 0 {
                //nothing in the field yet so append the replacement string
                mstring.append(string)

                shouldMoveToNextField = true
            } else {
                //adding a char or deleting?
                if insertStringLength > 0 {
                    mstring.insert(string, at: range.location)
                } else {
                    //delete case - the length of replacement string is zero for a delete
                    mstring.deleteCharacters(in: range)
                }
            }

            //set the text now
            textField.text = mstring as String

            if shouldMoveToNextField {
                self.moveToNextTextField(textField)
            }
        }

        //always return no since we are manually changing the text field
        return false

    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.firstOTPLetterTextField {
            self.secondOTPLetterTextField.becomeFirstResponder()
        } else if textField == self.secondOTPLetterTextField {
            self.thirdOTPLetterTextField.becomeFirstResponder()
        } else if textField == self.thirdOTPLetterTextField {
            self.fourthOTPLetterTextField.becomeFirstResponder()
        } else {
            LogManager.logDebug("verify mobile")
        }
        return true
    }

    private func moveToNextTextField(_ textField: UITextField) {
        if textField == self.firstOTPLetterTextField {
            self.secondOTPLetterTextField.becomeFirstResponder()
        } else if textField == self.secondOTPLetterTextField {
            self.thirdOTPLetterTextField.becomeFirstResponder()
        } else if textField == self.thirdOTPLetterTextField {
            self.fourthOTPLetterTextField.becomeFirstResponder()
        }
    }

    private func setTextFieldAccurate(_ textField: UITextField) {
        if let verifyOTPTextField: RBCustomTextField = textField as? RBCustomTextField {
            verifyOTPTextField.textFieldType = TextFieldType.accurate
        }
    }

    private func setTextFieldFilled(_ textField: UITextField) {
        if let verifyOTPTextField: RBCustomTextField = textField as? RBCustomTextField {
            verifyOTPTextField.textFieldType = TextFieldType.filled
        }
    }

    private func changeValidationTextfieldColor() {

        if let firstString: String = self.firstOTPLetterTextField.text?.trimmed(), firstString.characters.count > 0 {
            self.setTextFieldFilled(self.firstOTPLetterTextField)
        } else {
            self.setTextFieldAccurate(self.firstOTPLetterTextField)
        }

        if let secondString: String = self.secondOTPLetterTextField.text?.trimmed(), secondString.characters.count > 0 {
            self.setTextFieldFilled(self.secondOTPLetterTextField)
        } else {
            self.setTextFieldAccurate(self.secondOTPLetterTextField)
        }

        if let thirdString: String = self.thirdOTPLetterTextField.text?.trimmed(), thirdString.characters.count > 0 {
            self.setTextFieldFilled(self.thirdOTPLetterTextField)
        } else {
            self.setTextFieldAccurate(self.thirdOTPLetterTextField)
        }

        if let fourthString: String = self.fourthOTPLetterTextField.text?.trimmed(), fourthString.characters.count > 0 {
            self.setTextFieldFilled(self.fourthOTPLetterTextField)
        } else {
            self.setTextFieldAccurate(self.fourthOTPLetterTextField)
        }
    }
}

extension RBVerifyMobileViewController {

    //MARK: - Track mixpanel event signup
    fileprivate func trackMixpanelEventSignUpUser(userModel: RBUser) {

        if userModel.isFacebookUser() {
            AnalyticsManager.setDistictUserSuperProperties(type: AnalyticsIdentifier.userType.facebook.rawValue, action: 1, personModel: userModel)
        } else {
            AnalyticsManager.setDistictUserSuperProperties(type: AnalyticsIdentifier.userType.email.rawValue, action: 1, personModel: userModel)
        }

        //Track sing up event
        AnalyticsManager.trackMixpanelEvent(eventName: AnalyticsIdentifier.eventName.signUpEvent.rawValue)
    }

}
